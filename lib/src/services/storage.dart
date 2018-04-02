part of coffee_book;

final CollectionReference coffeeCollection = Firestore.instance.collection('coffees');

class Storage {
  final FirebaseUser user;

  Storage.forUser({
    @required this.user,
  }) : assert(user != null);

  static Coffee fromDocument(DocumentSnapshot document) => _fromMap(document.data);

  static Coffee _fromMap(Map<String, dynamic> data) => new Coffee.fromMap(data);

  Map<String, dynamic> _toMap(Coffee item, [Map<String, dynamic> other]) {
    final Map<String, dynamic> result = {};
    if (other != null) {
      result.addAll(other);
    }
    result.addAll(item.toMap());
    result['uid'] = user.uid;

    return result;
  }

  /// Returns a stream of data snapshots for the user, paginated using limit/offset
  Stream<QuerySnapshot> list({int limit, int offset}) {

    Stream<QuerySnapshot> snapshots = coffeeCollection.where('uid', isEqualTo: this.user.uid).snapshots;
    if (offset != null) {
      snapshots = snapshots.skip(offset);
    }
    if (limit != null) {
      // TODO can probably use _query.limit in an intelligent way with offset
      snapshots = snapshots.take(limit);
    }
    return snapshots;
  }

  Future<Coffee> create(String name) async {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot newDoc = await tx.get(coffeeCollection.document());
      final Coffee newItem = new Coffee(id: newDoc.documentID, name: name);
      final Map<String, dynamic> data = _toMap(newItem, {
        'created': new DateTime.now().toUtc().toIso8601String(),
      });
      await tx.set(newDoc.reference, data);

      return data;
    };

    return Firestore.instance.runTransaction(createTransaction).then(_fromMap).catchError((e) {
      print('dart error: $e');
      return null;
    });
  }

  Future<bool> update(Coffee item) async {
    final TransactionHandler updateTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(coffeeCollection.document(item.id));
      // Permission check
      if (doc['uid'] != this.user.uid) {
        throw new Exception('Permission Denied');
      }

      await tx.update(doc.reference, _toMap(item));
      return {'result': true};
    };

    return Firestore.instance.runTransaction(updateTransaction).then((r) => r['result']).catchError((e) {
      print('dart error: $e');
      return false;
    });
  }

  Future<bool> delete(String id) async {
    final TransactionHandler deleteTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(coffeeCollection.document(id));
      // Permission check
      if (doc['uid'] != this.user.uid) {
        throw new Exception('Permission Denied');
      }

      await tx.delete(doc.reference);
      return {'result': true};
    };

    return Firestore.instance.runTransaction(deleteTransaction).then((r) => r['result']).catchError((e) {
      print('dart error: $e}');
      return false;
    });
  }
}