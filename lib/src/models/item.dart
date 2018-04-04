part of coffee_book;

/// A simple model for holding information about each of our items
class Item {
  final String id;
  String uid;
  String type;
  Map<String, String> itemData;

  Item({
    @required this.id,
    @required this.type,
    @required this.itemData,
    @required this.uid,
  })  : assert(id != null && id.isNotEmpty),
        assert(type != null && type.isNotEmpty),
        assert(uid != null && uid.isNotEmpty),
        assert(itemData != null && itemData.isNotEmpty);

  Item.fromMap(Map<String, dynamic> data)
      : this(
            id: data['id'],
            itemData: new Map.from(data['itemData']),
            type: data['type'],
            uid: data['uid']);

  Map<String, dynamic> toMap() => {
        'id': this.id,
        'uid': this.uid,
        'type': this.type,
        'itemData': this.itemData,
      };
}
