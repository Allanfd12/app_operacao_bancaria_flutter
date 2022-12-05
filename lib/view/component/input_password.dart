import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputPassword extends StatefulWidget {
  final String nomeCampo;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? textInputFormatter;
  final int? maxLength;
  final String? prefixo;
  final bool? autofocus;
  final bool? readOnly;
  final TextEditingController? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final GestureTapCallback? onTap;
  const InputPassword({Key? key, required this.nomeCampo, this.textInputType, this.readOnly, this.textInputFormatter, this.maxLength, this.prefixo,  this.autofocus, this.controller, this.onSaved, this.onTap, this.validator}) : super(key: key);

  @override
  _InputPasswordState createState() => _InputPasswordState();
}

class _InputPasswordState extends State<InputPassword> {
  bool passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromRGBO(230, 230, 230, 1),
        margin: const EdgeInsets.only(bottom: 5, top: 5),
        padding: const EdgeInsets.all(5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                cursorColor: Theme.of(context).primaryColor,
                readOnly: widget.readOnly == true,
                onSaved: widget.onSaved,
                validator: widget.validator,
                onTap: widget.onTap,
                controller: widget.controller,
                autofocus: widget.autofocus == true,
                keyboardType:widget.textInputType,
                maxLength: widget.maxLength,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                inputFormatters:widget.textInputFormatter, // Impede a escrita de letras
                obscureText: !passwordVisible  ,//This will obscure text dynamically
                decoration: InputDecoration(
                  counterText:'',
                  labelText: widget.nomeCampo,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold,color:Theme.of(context).primaryColor),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  contentPadding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 1.5)),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  prefixText: widget.prefixo,
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),
            ]
        )
    );
  }
}
