part of coffee_book;

/// A simple model for holding information about each of our items
class Coffee {
  final String id;
  String type;
  String name;
  String roaster;
  String roastDate;
  String imageName;
  String location;
  String farm;
  String variety;
  String elevation;
  String process;

  Coffee({
    @required this.id,
    @required this.name,
  })  : assert(id != null && id.isNotEmpty),
        assert(name != null && name.isNotEmpty);

  Coffee.fromMap(Map<String, dynamic> data)
      : this(id: data['id'], name: data['name']);

  Map<String, dynamic> toMap() => {
    'id': this.id,
    'name': this.name,
  };
}