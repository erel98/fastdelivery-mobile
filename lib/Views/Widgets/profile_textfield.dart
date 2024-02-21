import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String? hintText;
  final Function(String)? onChanged;
  final TextInputType inputType;
  const ProfileTextfield({
    super.key,
    required this.controller,
    this.hintText,
    this.onChanged,
    required this.inputType,
  });
  @override
  // ignore: library_private_types_in_public_api
  _ProfileTextfieldState createState() => _ProfileTextfieldState();
}

class _ProfileTextfieldState extends State<ProfileTextfield> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.only(bottom: 20),
      child: CupertinoTextField(
        controller: widget.controller,
        enabled: true,
        onChanged: widget.onChanged,
        keyboardType: widget.inputType,
        textAlign: TextAlign.center,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        /* decoration: const InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ), */
      ),
    );
  }
}
