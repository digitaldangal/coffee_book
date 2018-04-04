part of coffee_book;

class Storage {
  final FirebaseUser user;

  CollectionReference get usersCollectionRef =>
      Firestore.instance.collection('users');

  Storage.forUser({
    @required this.user,
  }) : assert(user != null);

  static Item fromDocument(DocumentSnapshot document) =>
      new Item.fromMap(document.data);

  Map<String, dynamic> _toMap(Item item, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(item.toMap());
    result['uid'] = user.uid;

    return result;
  }

  /// Returns a stream of data snapshots for the user, paginated using limit/offset
  Stream<QuerySnapshot> list(String type, {int limit, int offset}) {
    CollectionReference collectionReference =
        usersCollectionRef.document(user.uid).getCollection(type);
    Stream<QuerySnapshot> snapshots = collectionReference.snapshots;
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<void> create(String type, Map<String, dynamic> itemData) async {
    CollectionReference collectionReference =
        usersCollectionRef.document(user.uid).getCollection(type);
    DocumentReference documentReference = collectionReference.document();
    Item item = new Item(
        id: documentReference.documentID,
        type: type,
        itemData: new Map.from(itemData),
        uid: user.uid);
    Map<String, dynamic> data = _toMap(item, {
      'created': new DateTime.now().toUtc().toIso8601String(),
    });
    documentReference.setData(data);
  }

  Future<bool> update(Item item) async {
    if (user.uid == item.uid) {
      CollectionReference collectionReference =
          usersCollectionRef.document(user.uid).getCollection(item.type);
      DocumentReference documentReference =
          collectionReference.document(item.id);
      Map<String, dynamic> data = _toMap(item, {
        'updated': new DateTime.now().toUtc().toIso8601String(),
      });
      documentReference.setData(data);
      return true;
    } else {
      throw new Exception('Permission Denied');
    }
  }

  Future<bool> delete(Item item) async {
    if (user.uid == item.uid) {
      CollectionReference collectionReference =
          usersCollectionRef.document(user.uid).getCollection(item.type);
      DocumentReference documentReference =
          collectionReference.document(item.id);
      documentReference.delete();
      return true;
    } else {
      throw new Exception('Permission Denied');
    }
  }
}
