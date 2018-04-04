part of coffee_book;

class ItemList extends StatefulWidget {
  final String type;

  ItemList({Key key, @required this.type})
      : super(key: key);
  @override
  State<StatefulWidget> createState() => new ItemListState();
}

/// The bulk of the app's "smarts" are in this class
class ItemListState extends State<ItemList> {
  List<Item> items = [];
  StreamSubscription<QuerySnapshot> itemSub;
  Storage storage;
  FirebaseUser user;

  @override
  void initState() {
    super.initState();
    _auth.currentUser().then((FirebaseUser user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed('/');
      } else {
        storage = new Storage.forUser(user: user);
        itemSub?.cancel();
        itemSub = storage.list(widget.type).listen((QuerySnapshot snapshot) {
          final List<Item> items = snapshot.documents
              .map(Storage.fromDocument)
              .toList(growable: false);
          setState(() {
            this.items = items;
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
    itemSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.type),
      ),
      drawer: new DrawerWidget(),
      body: buildContent(),
      floatingActionButton: new FloatingActionButton(
        child: new Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      new ItemForm(user: user, selectedItem: null, type: widget.type,)));
        },
      ),
    );
  }

  Widget buildContent() {
    if (user == null) {
      return new LoadingIndicator();
    } else {
      return new Column(
        children: <Widget>[
          new ItemHeadWidget(
            key: new Key('item-header'),
            onAddItem: this._create,
          ),
          new Expanded(
            flex: 2,
            child: new ListView.builder(
              key: const Key('item-list'),
              itemCount: items.length,
              itemBuilder: _buildItem(),
            ),
          ),
        ],
      );
    }
  }

  IndexedWidgetBuilder _buildItem() {
    return (BuildContext context, int idx) {
      final Item item = items[idx];
      return new ItemWidget(
        key: new Key('item-${item.id}'),
        item: item,
        onDelete: () {
          this._delete(item);
        },
      );
    };
  }

  void _create(String title) {
    Map<String, dynamic> data = {
      'name': title,
    };
    storage.create(widget.type, data);
  }

  void _delete(Item item) {
    storage.delete(item);
  }
}
