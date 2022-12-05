import 'package:contas_bancarias/repository/firebase_repository.dart';
import 'package:contas_bancarias/view/conta.dart';
import 'package:contas_bancarias/view/deposito.dart';
import 'package:contas_bancarias/view/home.dart';
import 'package:contas_bancarias/view/saque.dart';
import 'package:contas_bancarias/view/transferencia.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

import 'model/conta_bancaria.dart';

Future<void> main() async {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "TIVIC Bank",
    theme: ThemeData(
      primaryColor: const Color(0xff3c5d97)
    ),
    home: const Home(),
      initialRoute: "/",
      routes:{
        "/conta": (context)=>const Conta(),
        "/deposito": (context)=> const Deposito(),
        "/transferencia": (context)=> const Transferencia(),
        "/saque": (context)=> const Saque(),
      }
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
