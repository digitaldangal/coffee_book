part of coffee_book;

class ItemWidget extends StatefulWidget {
  final Item item;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onDelete;

  ItemWidget({
    Key key,
    @required this.item,
    this.onTitleChanged,
    this.onDelete,
  })  : assert(item != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => new _CoffeeWidgetState();
}

class _CoffeeWidgetState extends State<ItemWidget> {

  @override
  void initState() {
    super.initState();
  }

  Widget _buildTitle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.body1;
    return new Text(widget.item.itemData['name'], style: titleStyle);
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[
        new Expanded(
          flex: 2,
          child: _buildTitle(context),
        ),
        new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: widget.onDelete,
        ),
      ],
    );
  }
}