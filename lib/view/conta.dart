
import 'package:contas_bancarias/model/conta_bancaria.dart';
import 'package:contas_bancarias/service/conta_service.dart';
import 'package:contas_bancarias/util/validator.dart';
import 'package:contas_bancarias/view/component/button.dart';
import 'package:contas_bancarias/view/component/input_password.dart';
import 'package:contas_bancarias/view/component/input_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
class Conta extends StatefulWidget {
  ContaBancaria conta = ContaBancaria();
  Conta({Key? key}) : super(key: key);

  @override
  State<Conta> createState() => _ContaState();
}

class _ContaState extends State<Conta> {
  final ContaService _criarContaService = ContaService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dataNascimento = TextEditingController();
  final TextEditingController conta = TextEditingController();
  final TextEditingController nome = TextEditingController();
  final TextEditingController documento = TextEditingController();
  final TextEditingController senha = TextEditingController();
  final TextEditingController senhaConf = TextEditingController();
  DateTime selectedDate = DateTime.now();
  bool esperandoResposta = false;

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
    obterNumeroConta();
  }

  Future<void> obterNumeroConta() async{
    String numeroConta = await _criarContaService.obterNumeroConta();
    conta.value = valor(numeroConta);
    widget.conta.numeroConta = numeroConta;
  }
  void _limpaFormulario() {
    dataNascimento.value = valor('');
    nome.value = valor('');
    documento.value = valor('');
    senha.value = valor('');
    senhaConf.value = valor('');
  }
  void _criarContaBancaria() async{

    if(esperandoResposta || _formKey.currentState == null) {
      return;
    }

    esperandoResposta = true;
    if (!_formKey.currentState!.validate()) {
      esperandoResposta = false;
      return;
    }
    _formKey.currentState!.save();
    if(!Validator.isPasswordsEqual(widget.conta.senha, widget.conta.senhaConfirmacao)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("As senhas não conferem"), backgroundColor: Colors.red));
      esperandoResposta = false;
      return;
    }
    await _criarContaService.criarConta(widget.conta);

    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
        content: Text("Conta ${widget.conta.numeroConta!} Cadastrada com sucesso"), backgroundColor: Colors.green));

    await obterNumeroConta();
    _limpaFormulario();
    esperandoResposta = false;

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
                        onSaved: (value) => widget.conta.nome=value,
                        validator: Validator.notNullOrEmpty,
                      ),
                        InputText(
                              nomeCampo: "Número do Documento",
                              controller: documento,
                              onSaved: (value) => widget.conta.documento=value,
                              validator: Validator.notNullOrEmpty,
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
                              controller: conta,
                              onSaved: (value) => widget.conta.numeroConta=value,
                              readOnly: true,
                            ),
                          ),
                          Expanded(
                            child:InputText(
                              nomeCampo: "Nascimento",
                              onTap: () => _selectDate(context),
                              validator: Validator.notNullOrEmpty,
                              onSaved: (value) =>widget.conta.dataNascimento=value,
                              readOnly: true,
                              controller: dataNascimento,
                            ),
                          )
                        ],
                      ),
                      InputPassword(
                        nomeCampo: "Senha",
                        controller: senha,
                        validator: Validator.notNullOrEmpty,
                        onSaved: (value) => widget.conta.senha=value,
                        maxLength: 4,
                      ),
                      InputPassword(
                        nomeCampo: "Confirmação de Senha",
                        controller: senhaConf,
                        validator: Validator.notNullOrEmpty,
                        onSaved: (value) => widget.conta.senhaConfirmacao=value,
                        maxLength: 4,
                      ),
                      Row(children: [
                        Expanded(
                            child: Padding(
                                padding:
                                const EdgeInsets.only(left: 10,bottom: 10, right: 10),
                                child: Button(text:"Salvar",
                                  icon: const Icon(Icons.save),
                                  onPressed: _criarContaBancaria,
                                )
                            ))
                      ]),
                    ],
                  )))),
    );
  }
}
