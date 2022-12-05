import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../model/movimento.dart';
import '../service/conta_service.dart';
import '../util/mascara_monetaria.dart';
import '../util/validator.dart';
import 'component/button.dart';
import 'component/input_text.dart';

class Transferencia extends StatefulWidget {
  Movimento transferencia = Movimento();
  Transferencia({Key? key}) : super(key: key);

  @override
  State<Transferencia> createState() => _TransferenciaState();
}

class _TransferenciaState extends State<Transferencia> {
  final ContaService _ContaService = ContaService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController contaOrigem = TextEditingController();
  final TextEditingController contaDestino = TextEditingController();
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
    contaOrigem.value = _valor('');
    contaDestino.value = _valor('');
  }

  void _trasferir() async {
    if(esperandoResposta || _formKey.currentState == null) {
      return;
    }
    esperandoResposta = true;
    if (!_formKey.currentState!.validate()) {
      esperandoResposta = false;
      return;
    }
    _formKey.currentState!.save();
    widget.transferencia.valor = double.tryParse(widget.transferencia.valorString!.trim().replaceAll('.','').replaceAll(',','.'));
    if(widget.transferencia.valor == null){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Valor invalido"), backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    bool contaExiste =  await _ContaService.contaExiste(widget.transferencia.origem!);
    if(!contaExiste){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conta de Origem não existe"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }

    contaExiste =  await _ContaService.contaExiste(widget.transferencia.destino!);
    if(!contaExiste){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Conta de Destino não existe"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }
    bool contaTemSaldo =  await _ContaService.contaTemSaldo(widget.transferencia.origem!,widget.transferencia.valor!);
    if(!contaTemSaldo){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Saldo Insuficiente para Transferência"),
          backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }
    bool sucesso =  await _ContaService.registrarMovimento(widget.transferencia);

    if(sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Transferência feita com sucesso"),
          backgroundColor: Colors.green));
      _limpaFormulario();
    }else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Erro ao realizar Transferência"),
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
        title: const Text("Transferir"),
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
                        nomeCampo: "Conta Origem",
                        controller: contaOrigem,
                        maxLength: 8,
                        onSaved: (value) => widget.transferencia.origem = value,
                        validator: Validator.notNullOrEmpty,
                        textInputType: TextInputType.number,
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      InputText(
                        nomeCampo: "Conta Destino",
                        controller: contaDestino,
                        maxLength: 8,
                        onSaved: (value) => widget.transferencia.destino = value,
                        validator: Validator.notNullOrEmpty,
                        textInputType: TextInputType.number,
                        textInputFormatter: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                      ),
                      InputText(
                        nomeCampo: "Valor",
                        onSaved: (value) =>widget.transferencia.valorString =value,
                        validator: Validator.notNullOrEmpty,
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
                                child: Button(text:"Transferir",
                                  icon: const Icon(Icons.compare_arrows),
                                  onPressed: _trasferir,
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
