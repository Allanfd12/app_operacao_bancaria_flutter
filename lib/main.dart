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
        "/conta": (context)=>Conta(),
        "/deposito": (context)=> Deposito(),
        "/transferencia": (context)=> Transferencia(),
        "/saque": (context)=> Saque(),
      }
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
