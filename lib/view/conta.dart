
import 'package:contas_bancarias/view/component/button.dart';
import 'package:contas_bancarias/view/component/input_password.dart';
import 'package:contas_bancarias/view/component/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:math';
class Conta extends StatefulWidget {
  const Conta({Key? key}) : super(key: key);

  @override
  State<Conta> createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nome = TextEditingController();
  final TextEditingController documento = TextEditingController();
  final TextEditingController dataNascimento = TextEditingController();
  final TextEditingController conta = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController senhaConfirmacao = TextEditingController();
  DateTime selectedDate = DateTime.now();

  TextEditingValue valor(String val) {
    return TextEditingValue(
      text: val,
      selection: TextSelection.fromPosition(
        TextPosition(offset: val.length),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dataNascimento.value =
            valor(DateFormat('dd/MM/yyyy').format(selectedDate));
      });
    }
  }

  @override
  void initState() {
    super.initState();
    conta.value = valor((Random().nextInt(99999999)).toString());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Criar Conta"),
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
                        nomeCampo: "Nome",
                        controller: nome,
                        onSaved: (value) => print(value),
                      ),
                        InputText(
                              nomeCampo: "Número do Documento",
                              controller: documento,
                              onSaved: (value) => print(value),
                              textInputType: TextInputType.number,
                              textInputFormatter: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),

                      Row(
                        children: [
                          Expanded(
                            child: InputText(
                              nomeCampo: "Número Conta",
                              onSaved: (value) => print(value),
                              controller: conta,
                              readOnly: true,
                            ),
                          ),
                          Expanded(
                            child:InputText(
                              nomeCampo: "Nascimento",
                              onTap: () => _selectDate(context),
                              onSaved: (value) =>print(value),
                              readOnly: true,
                              controller: dataNascimento,
                            ),
                          )
                        ],
                      ),
                      InputPassword(
                        nomeCampo: "Senha",
                        controller: senha,
                        onSaved: (value) => print(value),
                        maxLength: 4,
                      ),
                      InputPassword(
                        nomeCampo: "Confirmação de Senha",
                        controller: senhaConfirmacao,
                        onSaved: (value) => print(value),
                        maxLength: 4,
                      ),
                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                child: Button(text:"Salvar",
                                  icon: const Icon(Icons.save),
                                  onPressed: (){},
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
