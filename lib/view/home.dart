
import 'package:flutter/material.dart';

import 'component/button.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void _criarConta() {
    Navigator.pushNamed(context, "/conta");
  }
  void _depositar() {
    Navigator.pushNamed(context, "/deposito");
  }
  void _transferir() {
    Navigator.pushNamed(context, "/transferencia");
  }
  void _sacar() {
    Navigator.pushNamed(context, "/saque");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(230, 237, 241, 1),
        body: Container(
            padding: const EdgeInsets.all(40),
            color: const Color.fromRGBO(230, 237, 241, 1),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Container(
                    margin: const EdgeInsets.only(bottom: 30),
                    child: Image.asset(
                      'images/logo.png',
                      height: 100,
                      fit: BoxFit.contain,
                    ),
                  ),
                  //const Divider(thickness: 2, height: 10),
                  const Spacer(),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(children:  [
                          Expanded(
                              child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                  child: Button(text:"Criação de contas"
                                      ,icon: const Icon(Icons.account_balance),
                                  onPressed: _criarConta,)
                              ))
                        ]),
                        Row(children:  [
                          Expanded(
                              child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                  child: Button(text:"Depósito bancário",
                                    icon: const Icon(Icons.monetization_on),
                                      onPressed: _depositar
                                  )
                              ))
                        ]),
                        Row(children:  [
                          Expanded(
                              child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                  child: Button(text:"Saque de saldo",
                                    icon: const Icon(Icons.output),
                                    onPressed: _sacar,
                                  )
                              ))
                        ]),
                        Row(children: [
                          Expanded(
                              child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 10, right: 10),
                                  child: Button(text:"Transferência bancária",
                                    icon: const Icon(Icons.compare_arrows),
                                  onPressed: _transferir,
                                  )
                              ))
                        ]),

                        const SizedBox(
                          height: 40.0,
                        ),
                      ]),
                ])));;
  }
}
