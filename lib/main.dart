import 'package:contas_bancarias/view/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp( MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "TIVIC Bank",
    home: Home(),
      initialRoute: "/",
      routes:{
        "/conta": (context)=>const Home(),
        "/deposito": (context)=> const Home(),
        "/transferencia": (context)=> const Home(),
        "/saque": (context)=> const Home(),
      }
  ));
}
