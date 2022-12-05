import 'dart:math';

import 'package:contas_bancarias/model/conta_bancaria.dart';
import 'package:contas_bancarias/model/movimento.dart';

import '../repository/firebase_repository.dart';

class ContaService{
  FirebaseRepository db = FirebaseRepository();

  Future<String> obterNumeroConta() async{
    String conta;
    do{
      conta = (Random().nextInt(99999999)).toString();
    }while(await db.contaExiste(conta));
      return conta;
  }
  criarConta(ContaBancaria cb) async{
    await db.salvarConta(cb);
  }

  Future<bool> registrarMovimento(Movimento mov) async{
    if(mov.origem != null){
      if(mov.valor != null && !await db.contaTemSaldo(mov.origem!,mov.valor!)){
        return false;
      }
    }
    if(mov.destino != null){
      if(! await db.contaExiste(mov.destino!)){
        return false;
      }
    }
    await db.salvarMovimento(mov);
    return true;
  }

  Future<bool> contaExiste(String codigoConta)async{
    return await db.contaExiste(codigoConta);
  }
  Future<bool> contaTemSaldo(String codigoConta,double saque)async{
    return await db.contaTemSaldo(codigoConta,saque);
  }
}