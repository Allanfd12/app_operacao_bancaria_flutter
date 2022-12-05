import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/movimento.dart';
import '../service/conta_service.dart';
import '../util/mascara_monetaria.dart';
import '../util/validator.dart';
import 'component/button.dart';
import 'component/input_text.dart';

class Saque extends StatefulWidget {
  Movimento saque = Movimento();
  Saque({Key? key}) : super(key: key);

  @override
  State<Saque> createState() => _SaqueState();
}

class _SaqueState extends State<Saque> {
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

  void _sacar() async {
    if(esperandoResposta || _formKey.currentState == null) {
      return;
    }
    esperandoResposta = true;
    if (!_formKey.currentState!.validate()) {
      esperandoResposta = false;
      return;
    }
    _formKey.currentState!.save();
    widget.saque.valor = double.tryParse(widget.saque.valorString!.trim().replaceAll('.','').replaceAll(',','.'));
    if(widget.saque.valor == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Valor invalido"), backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    bool contaExiste =  await _ContaService.contaExiste(widget.saque.origem!);
    if(!contaExiste){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conta de Saque não existe"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    bool contaTemSaldo =  await _ContaService.contaTemSaldo(widget.saque.origem!,widget.saque.valor!);
    if(!contaTemSaldo){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Saldo Insuficiente"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }
    bool sucesso =  await _ContaService.registrarMovimento(widget.saque);

    if(sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Saque feito com sucesso"),
          backgroundColor: Colors.green));
      _limpaFormulario();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro ao realizar Saque"),
          backgroundColor: Colors.red));
    }
    esperandoResposta = false;
    _limpaFormulario();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Sacar"),
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
                        onSaved: (value) => widget.saque.origem = value,
                        validator: Validator.notNullOrEmpty,
                        textInputType: TextInputType.number,
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      InputText(
                        nomeCampo: "Valor",
                        onSaved: (value) =>widget.saque.valorString = value,
                        textInputType: TextInputType.number,
                        validator: Validator.notNullOrEmpty,
                        textInputFormatter: [MacaraMonetaria()],
                        controller: valor,
                        prefixo: "R\$",
                      ),

                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                child: Button(text:"Sacar",
                                  icon: const Icon(Icons.output),
                                  onPressed: _sacar,
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
