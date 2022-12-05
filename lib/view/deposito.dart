import 'package:contas_bancarias/model/movimento.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../service/conta_service.dart';
import '../util/mascara_monetaria.dart';
import '../util/validator.dart';
import 'component/button.dart';
import 'component/input_text.dart';
class Deposito extends StatefulWidget {
  Movimento deposito = Movimento();
  Deposito({Key? key}) : super(key: key);

  @override
  State<Deposito> createState() => _DepositoState();
}

class _DepositoState extends State<Deposito> {
  final ContaService _ContaService = ContaService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController conta = TextEditingController();
  final TextEditingController valor = TextEditingController();
  bool esperandoResposta = false;

  TextEditingValue _valor(String val) {
    return TextEditingValue(
      text: val,
      selection: TextSelection.fromPosition(
        TextPosition(offset: val.length),
      ),
    );
  }

  void _limpaFormulario() {
    valor.value = _valor('');
    conta.value = _valor('');
  }

  void _depositar() async{
    if(esperandoResposta || _formKey.currentState == null) {
      return;
    }
    esperandoResposta = true;
    if (!_formKey.currentState!.validate()) {
      esperandoResposta = false;
      return;
    }
    _formKey.currentState!.save();
    widget.deposito.valor = double.tryParse(widget.deposito.valorString!.trim().replaceAll('.','').replaceAll(',','.'));
    if(widget.deposito.valor == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Valor invalido"), backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    bool contaExiste =  await _ContaService.contaExiste(widget.deposito.destino!);
    if(!contaExiste){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conta de depósito não existe"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    bool sucesso =  await _ContaService.registrarMovimento(widget.deposito);

    if(sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Deposito feito com sucesso"),
          backgroundColor: Colors.green));
      _limpaFormulario();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro ao realizar deposito"),
          backgroundColor: Colors.red));
    }
    esperandoResposta = false;
  }

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
                        validator: Validator.notNullOrEmpty,
                        maxLength: 8,
                        onSaved: (value) => widget.deposito.destino=value,
                        textInputType: TextInputType.number,
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      InputText(
                        nomeCampo: "Valor",
                        onSaved: (value) =>widget.deposito.valorString=value,
                        textInputType: TextInputType.number,
                        textInputFormatter: [MacaraMonetaria()],
                        controller: valor,
                        validator: Validator.notNullOrEmpty,
                        prefixo: "R\$",
                      ),

                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                child: Button(text:"Depositar",
                                  icon: const Icon(Icons.monetization_on),
                                  onPressed: _depositar,
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
