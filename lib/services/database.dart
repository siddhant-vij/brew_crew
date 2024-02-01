import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_user.dart';
import '../models/brew.dart';

class DatabaseService {
  final String? uid;

  DatabaseService({
    this.uid,
  });

  final CollectionReference brewCollection =
      FirebaseFirestore.instance.collection('brews');

  Future<void> updateUserData({
    required String name,
    required String sugars,
    required int strength,
  }) async {
    return await brewCollection.doc(uid).set({
      'name': name,
      'sugars': sugars,
      'strength': strength,
    });
  }

  Stream<List<Brew>> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Brew(
        name: doc.get('name') ?? 'New Crew Member',
        sugars: doc.get('sugars') ?? '0',
        strength: doc.get('strength') ?? 100,
      );
    }).toList();
  }

  Stream<AppUserData> get userData {
    return brewCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  AppUserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUserData(
      uid: uid!,
      name: snapshot.get('name'),
      sugars: snapshot.get('sugars'),
      strength: snapshot.get('strength'),
    );
  }
}
