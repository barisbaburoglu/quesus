import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';

class InputRightLabel extends StatefulWidget {
  final IconData? iconData;
  final bool? readOnly;
  final bool? obscureText;
  final double? hintFontSize;
  final double width;
  final double height;
  final String text;
  final String rightText;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final Function()? onEditingComplete;
  final Function(String)? onChanged;
  final FocusNode focusNode;

  const InputRightLabel({
    Key? key,
    this.iconData,
    this.readOnly,
    this.obscureText,
    this.hintFontSize,
    required this.width,
    required this.height,
    required this.text,
    required this.rightText,
    required this.controller,
    this.onEditingComplete,
    this.onChanged,
    this.textInputType,
    this.inputFormatters,
    required this.focusNode,
  }) : super(key: key);

  @override
  State<InputRightLabel> createState() => _InputRightLabelState();
}

class _InputRightLabelState extends State<InputRightLabel> {
  String labelUserInput = '';
  late double btnMenuFontSize;
  late FocusNode userIdFocusNode;
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
      child: SizedBox(
        width: widget.width >= 310 ? 310 : widget.width,
        height: widget.height,
        child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          focusNode: widget.focusNode,
          inputFormatters: widget.inputFormatters,
          keyboardType: widget.textInputType,
          obscureText: widget.obscureText ?? false,
          readOnly: widget.readOnly ?? false,
          style: GoogleFonts.montserrat(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            filled: true,
            fillColor: colorGreenPrimary,
            hintText: labelUserInput,
            hintStyle: TextStyle(
              color: colorGreenSecondary,
            ),
            prefixIcon: Icon(
              size: 15,
              widget.iconData,
              color: colorGreenSecondary,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: colorGreenPrimary, width: 2.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: colorGreenLight, width: 2.0),
            ),
          ),
          controller: widget.controller,
          autocorrect: false,
          enableSuggestions: false,
          autofocus: false,
          onEditingComplete: widget.onEditingComplete,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
