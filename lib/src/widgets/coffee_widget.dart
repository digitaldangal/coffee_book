part of coffee_book;

class CoffeeWidget extends StatefulWidget {
  final Coffee coffee;
  final bool disabled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onDelete;

  CoffeeWidget({
    Key key,
    @required this.coffee,
    this.disabled = false,
    this.onToggle,
    this.onTitleChanged,
    this.onDelete,
  })  : assert(coffee != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => new _CoffeeWidgetState();
}

class _CoffeeWidgetState extends State<CoffeeWidget> {
  final TextEditingController _editTitleController = new TextEditingController();

  bool _editMode;

  @override
  void initState() {
    super.initState();
    _editMode = false;
  }

  Widget _buildEditTitle() {
    final String title = widget.coffee.name;

    // Make sure the controller always has our current value
    _editTitleController.text = title;
    // Select all the text when we show the edit box
    _editTitleController.selection = new TextSelection(baseOffset: 0, extentOffset: title.length);

    return new TextField(
      autofocus: true,
      controller: _editTitleController,
      onSubmitted: (value) {
        setState(() {
          _editMode = false;
        });
        widget.onTitleChanged(value);
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.body1;
    if (widget.disabled) {
      titleStyle = titleStyle.copyWith(color: Colors.grey);
    }

    return new GestureDetector(
      child: new Text(widget.coffee.name, style: titleStyle),
      onLongPress: widget.disabled
          ? null
          : () {
        // Long press to edit
        if (widget.onTitleChanged != null) {
          setState(() {
            _editMode = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget titleChild = (!widget.disabled && _editMode) ? _buildEditTitle() : _buildTitle(context);

    return new Row(
      children: <Widget>[
        new Expanded(
          flex: 2,
          child: titleChild,
        ),
        new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: widget.disabled ? null : widget.onDelete,
        ),
      ],
    );
  }
}