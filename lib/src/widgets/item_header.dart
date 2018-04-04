part of coffee_book;

/// The header widget for our main list page
class ItemHeadWidget extends StatelessWidget {
  final TextEditingController _newTitleController = new TextEditingController();

  /// The key to locate the internal text input
  final Key textInputKey;

  /// Callback for when a new task should be created
  final ValueSetter<String> onAddItem;

  ItemHeadWidget({
    Key key,
    this.textInputKey,
    @required this.onAddItem,
  })  : assert(onAddItem != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = <Widget>[];

    // Always add the input box
    children.add(new Expanded(
      flex: 2,
      child: new TextField(
        key: textInputKey,
        controller: _newTitleController,
        decoration: new InputDecoration(hintText: 'What needs to be done?'),
        onSubmitted: (String value) {
          // Notify that we're adding a new item, and clear the text field
          this.onAddItem(value);
          _newTitleController.text = "";
        },
      ),
    ));

    return new Padding(
      // If we have the toggle all box, left the icon be our left padding
      padding: new EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: new Row(children: children),
    );
  }
}
