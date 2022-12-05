
import 'package:contas_bancarias/model/movimento.dart';
import 'package:firebase_database/firebase_database.dart';

import '../model/conta_bancaria.dart';

class FirebaseRepository{
  FirebaseDatabase firebase = FirebaseDatabase.instance;

  Future<void> salvarConta(ContaBancaria cb) async {
    DatabaseReference ref = firebase.ref("contas/${cb.numeroConta}");
    await ref.set(cb.toJson());
  }
  Future<bool> contaExiste(String codigoConta) async {
    final ref = firebase.ref();
    final snapshot = await ref.child('contas/$codigoConta').get();

    return snapshot.exists;
  }
  Future<bool> contaTemSaldo(String codigoConta,double valor) async {
    final ref2 = firebase.ref();
    final snapshot = await ref2.child('contas/$codigoConta/saldo').get();
    if(!snapshot.exists) {
      return false;
    }
      double? saldo = double.tryParse(snapshot.value.toString());
      return (saldo !=null && saldo! >= valor);
  }
  Future<void> salvarMovimento(Movimento movimento) async {
    if(movimento.origem != null){

      final ref2 = firebase.ref();
      final snapshot = await ref2.child('contas/${movimento.origem}/saldo').get();
      if(!snapshot.exists) return;

      double? saldo = double.tryParse(snapshot.value.toString());
      if( saldo == null) return;
      if( saldo! < movimento.valor!) return;

      saldo -= movimento.valor!;

      DatabaseReference ref = firebase.ref("movimento/${movimento.origem}/${DateTime.now().millisecondsSinceEpoch}");
      await ref.set(movimento.toJson());

      DatabaseReference ref3 = firebase.ref("contas/${movimento.origem}");
      await ref3.update({
        "saldo":saldo
      });
    }
    if(movimento.destino != null){

      final ref2 = firebase.ref();
      final snapshot = await ref2.child('contas/${movimento.destino}/saldo').get();
      if(!snapshot.exists) return;

      double? saldo = double.tryParse(snapshot.value.toString());
      if( saldo == null) return;

      saldo += movimento.valor!;

      DatabaseReference ref = firebase.ref("movimento/${movimento.destino}/${DateTime.now().millisecondsSinceEpoch}");
      await ref.set(movimento.toJson());

      DatabaseReference ref3 = firebase.ref("contas/${movimento.destino}");
      await ref3.update({
        "saldo":saldo
      });
    }

  }
}