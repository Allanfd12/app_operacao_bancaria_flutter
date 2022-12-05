
import 'package:firebase_database/firebase_database.dart';

import '../model/conta_bancaria.dart';

class FirebaseRepository{
  FirebaseDatabase firebase = FirebaseDatabase.instance;

  Future<void> salvarConta(ContaBancaria c) async {
    DatabaseReference ref = firebase.ref("contas/${c.conta}");
    await ref.set(c.toJson());
  }
  Future<bool> contaExiste(String codigoConta) async {
    final ref = firebase.ref();
    final snapshot = await ref.child('contas/$codigoConta').get();

    return snapshot.exists;
  }

}