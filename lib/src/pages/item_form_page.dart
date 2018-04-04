part of coffee_book;

class ItemForm extends StatefulWidget {
  final String selectedItem;
  final FirebaseUser user;
  final String type;

  ItemForm(
      {Key key,
      @required this.user,
      @required this.type,
      @required this.selectedItem})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => new ItemFormState();
}

class ItemFormState extends State<ItemForm> {
  List<Item> items = [];
  Storage storage;
  Map<String, dynamic> itemData;

  void initState() {
    super.initState();
    storage = new Storage.forUser(user: widget.user);
    itemData = new Map();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.type), actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.save),
          onPressed: () {
            _create();
            Navigator.pop(context);
          },
        ),
      ]),
      body: new SingleChildScrollView(child: buildCoffeeForm()),
    );
  }

  void _create() {
    storage.create(widget.type, itemData);
  }

  void onChange(String key, String text) {
    setState(() {
      itemData[key] = text;
    });
  }

  Widget buildCoffeeForm() {
    return new Column(children: [
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['name'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'name',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['roaster'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'roaster',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['roastDate'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'roastDate',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['location'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'location',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['farm'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'farm',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['variety'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'variety',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['elevation'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'elevation',
          ),
        ),
      ),
      new ListTile(
        leading: new Icon(Icons.person),
        title: new TextField(
          onChanged: (String string) {
            setState(() {
              itemData['process'] = string;
            });
          },
          decoration: new InputDecoration(
            hintText: 'process',
          ),
        ),
      )
    ]);
  }
}
