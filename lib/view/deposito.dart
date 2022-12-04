import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/mascara_monetaria.dart';
import 'component/button.dart';
import 'component/input_text.dart';
class Deposito extends StatefulWidget {
  const Deposito({Key? key}) : super(key: key);

  @override
  State<Deposito> createState() => _DepositoState();
}

class _DepositoState extends State<Deposito> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController conta = TextEditingController();
  final TextEditingController valor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Depositar"),
      ),
      body: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      InputText(
                        nomeCampo: "Conta",
                        controller: conta,
                        maxLength: 8,
                        onSaved: (value) => print(value),
                        textInputType: TextInputType.number,
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      InputText(
                        nomeCampo: "Valor",
                        onSaved: (value) =>print(value),
                        textInputType: TextInputType.number,
                        textInputFormatter: [MacaraMonetaria()],
                        controller: valor,
                        prefixo: "R\$",
                      ),

                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                child: Button(text:"Depositar",
                                  icon: const Icon(Icons.monetization_on),
                                  onPressed: (){},
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
