import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';

class InputEdit extends StatefulWidget {
  final String text;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLines;
  Function(String)? onChanged;

  InputEdit({
    Key? key,
    required this.text,
    required this.focusNode,
    required this.controller,
    required this.maxLines,
    required this.textInputType,
    required this.inputFormatters,
    this.onChanged,
  }) : super(key: key);

  @override
  State<InputEdit> createState() => _InputEditState();
}

class _InputEditState extends State<InputEdit> {
  String labelUserInput = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    labelUserInput = widget.text;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.focusNode.requestFocus();
        },
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: widget.controller,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.textInputType,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                        BorderSide(width: 0.5, color: colorGreenPrimary),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  labelText: widget.text,
                ),
                maxLines: widget.maxLines,
                onChanged: widget.onChanged,
              ),
            ],
          ),
        ));
  }
}
