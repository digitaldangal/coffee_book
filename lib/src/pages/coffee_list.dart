part of coffee_book;

/// The filter values for which kind of filter tasks we will show
enum TypeFilter {
  ALL,
  ACTIVE,
  COMPLETED,
}

class CoffeeList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new CoffeeListState();
}

/// The bulk of the app's "smarts" are in this class
class CoffeeListState extends State<CoffeeList> {
  TypeFilter typeFilter;
  List<Coffee> coffees;

  /// List of coffees that are disabled in the UI while async operations are performed
  Set<String> disabledCoffees;

  StreamSubscription<QuerySnapshot> coffeeSub;
  Storage storage;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    typeFilter = TypeFilter.ALL;
    coffees = [];
    disabledCoffees = new Set();

    _auth.currentUser().then((FirebaseUser user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        storage = new Storage.forUser(user: user);
        coffeeSub?.cancel();
        coffeeSub = storage.list().listen((QuerySnapshot snapshot) {
          final List<Coffee> coffees = snapshot.documents.map(Storage.fromDocument).toList(growable: false);
          setState(() {
            this.coffees = coffees;
          });
        });

        setState(() {
          this.user = user;
        });
      }
    });
  }

  @override
  void dispose() {
    coffeeSub?.cancel();
    super.dispose();
  }

  void setFilter(TypeFilter filter) {
    setState(() {
      typeFilter = filter;
    });
  }

  Widget buildToggleButton(TypeFilter type, String text) {
    final bool enabled = type == typeFilter;

    Widget button = new MaterialButton(
      key: new Key('filter-button-${text.toLowerCase()}'),
      textColor: enabled ? Colors.black : Colors.grey,
      child: new Text(text),
      onPressed: () => setFilter(type),
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      minWidth: 0.0,
    );

    if (enabled) {
      button = new Container(
        decoration: new BoxDecoration(
          border: new Border.all(),
          borderRadius: new BorderRadius.circular(3.0),
        ),
        child: button,
      );
    }

    return button;
  }

  Widget buildContent(int remainingActive) {
    if (user == null) {
      return new LoadingIndicator();
    } else {
      // Apply our filter. If no filter just copy list, otherwise check the completed status
      // This is done at build time to simply our state and what we must keep track of
      final bool onlyActive = typeFilter == TypeFilter.ACTIVE;
      final List<Coffee> visibleCoffees =
      typeFilter == TypeFilter.ALL ? coffees : coffees.toList(growable: false);

      final bool allCompleted = coffees.isNotEmpty && remainingActive == 0;

      return new Column(
        children: <Widget>[
          new CoffeeHeaderWidget(
            key: new Key('coffee-header'),
            showToggleAll: coffees.length > 0,
            toggleAllActive: allCompleted,
            onChangeToggleAll: () {
              this._toggleAll(!allCompleted);
            },
            onAddCoffee: this._createCoffee,
          ),
          new Expanded(
            flex: 2,
            child: new ListView.builder(
              key: const Key('coffee-list'),
              itemCount: visibleCoffees.length,
              itemBuilder: _buildCoffeeItem(visibleCoffees),
            ),
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Number of remaining tasks to complete
    final int remainingActive = coffees.length;

    final ThemeData themeData = Theme.of(context);

    return new Scaffold(
      appBar: new AppBar(
        title: const Text('Coffees'),
      ),
      drawer: new Drawer(
        child: new ListView(
          primary: false,
          children: <Widget>[
            new DrawerHeader(
              child: new Center(
                child: new Text(
                  "Coffee Book",
                  style: themeData.textTheme.title,
                ),
              ),
            ),
            new ListTile(
              title: const Text('Logout', textAlign: TextAlign.right),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () async {
                await signOutWithGoogle();
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        ),
      ),
      body: buildContent(remainingActive),
      bottomNavigationBar: new Padding(
        padding: const EdgeInsets.all(10.0),
        child: new Stack(
          fit: StackFit.loose,
          alignment: AlignmentDirectional.centerStart,
          children: <Widget>[
            new Text('$remainingActive item${remainingActive == 1 ? '' : 's'} left'),
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                buildToggleButton(TypeFilter.ALL, 'All'),
                buildToggleButton(TypeFilter.ACTIVE, 'Active'),
                buildToggleButton(TypeFilter.COMPLETED, 'Completed'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Method to create the widget builder for the coffees that are passed in
  /// This allows us to have a separate function, to keep the code clean, while still allowing us to calculate the
  /// result of the filters are build-time.
  IndexedWidgetBuilder _buildCoffeeItem(List<Coffee> coffees) {
    return (BuildContext context, int idx) {
      final Coffee coffee = coffees[idx];
      return new CoffeeWidget(
        key: new Key('coffee-${coffee.id}'),
        coffee: coffee,
        disabled: disabledCoffees.contains(coffee.id),
        onToggle: (completed) {
          this._toggleCoffee(coffee, completed);
        },
        onTitleChanged: (newTitle) {
          this._editCoffee(coffee, newTitle);
        },
        onDelete: () {
          this._deleteCoffee(coffee);
        },
      );
    };
  }

  void _disableCoffee(Coffee coffee) {
    setState(() {
      disabledCoffees.add(coffee.id);
    });
  }

  void _enabledCoffee(Coffee coffee) {
    setState(() {
      disabledCoffees.remove(coffee.id);
    });
  }

  void _toggleAll(bool toggled) {
    coffees.forEach((t) => this._toggleCoffee(t, toggled));
  }

  void _createCoffee(String title) {
    storage.create(title);
  }

  void _deleteCoffee(Coffee coffee) {
    this._disableCoffee(coffee);
    storage.delete(coffee.id).catchError((_) {
      this._enabledCoffee(coffee);
    });
  }

  void _toggleCoffee(Coffee coffee, bool completed) {
    this._disableCoffee(coffee);
    storage.update(coffee).whenComplete(() {
      this._enabledCoffee(coffee);
    });
  }

  void _editCoffee(Coffee coffee, String newName) {
    this._disableCoffee(coffee);
    coffee.name = newName;
    storage.update(coffee).whenComplete(() {
      this._enabledCoffee(coffee);
    });
  }
}