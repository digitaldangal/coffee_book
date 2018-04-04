part of coffee_book;

class CoffeeFormWidget extends State<ItemForm> {
  CoffeeFormWidget(Map<String, dynamic> itemData);

  Map<String, dynamic> itemData;

  @override
  Widget build(BuildContext context) {
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
