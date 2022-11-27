import 'package:flutter/material.dart';

class Button extends StatefulWidget {
  final String text;
  final Icon icon;
  final VoidCallback? onPressed;
  const Button( {Key? key,required this.text, required this.icon, this.onPressed}) : super(key: key);

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
          shape: MaterialStateProperty.all<
              RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      32.0),
                  )),
          backgroundColor:
          MaterialStateProperty
              .all<Color>(const Color(0xff3c5d97))),
      onPressed: widget.onPressed,
      label:  Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            widget.text,
            style: const TextStyle(fontSize: 20),
          )),
      icon: widget.icon,
    );
  }
}
