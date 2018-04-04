part of coffee_book;

/// A simple model for holding information about each of our items
class Coffee {
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
    @required this.name,
  }) : assert(name != null && name.isNotEmpty);

  Coffee.fromMap(Map<String, dynamic> data)
      : this(name: data['name']);

  Map<String, dynamic> toMap() => {
    'name': this.name,
  };
}