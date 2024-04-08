import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/svg.dart';

class Popup extends StatefulWidget {
  final bool? isCircularProgress;
  final double width;
  final String text;
  final int maxLines;
  final EdgeInsetsGeometry padding;
  final Function() onTapClose;
  const Popup({
    Key? key,
    this.isCircularProgress,
    required this.width,
    required this.text,
    required this.maxLines,
    required this.padding,
    required this.onTapClose,
  }) : super(key: key);

  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Container(
            color: Colors.black54.withOpacity(0.5),
          ),
        ),
        widget.isCircularProgress == true
            ? Center(
                child: SizedBox(
                  width: calculatedWidth(30, context),
                  height: calculatedWidth(30, context),
                  child: CircularProgressIndicator(
                    color: colorGreenPrimary,
                    strokeWidth: 5,
                  ),
                ),
              )
            : Padding(
                padding: widget.padding,
                child: Center(
                  child: SizedBox(
                    width: widget.width,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xffffffff),
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                width: 1.0, color: colorGreenPrimary),
                          ),
                          margin: EdgeInsets.fromLTRB(
                              0.0, calculatedHeight(50.0, context), 0.0, 0.0),
                          child: Padding(
                            padding:
                                EdgeInsets.all(calculatedWidth(25, context)),
                            child: SizedBox(
                              width: calculatedWidth(310, context),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.text,
                                  style: GoogleFonts.josefinSans(
                                    fontSize: calculatedFontSize(16, context),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    height: 1.3333333333333333,
                                  ),
                                  maxLines: widget.maxLines,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: widget.onTapClose,
                          child: Align(
                            alignment: Alignment.topRight,
                            child: SizedBox(
                              width: calculatedWidth(46.0, context),
                              height: calculatedWidth(46.0, context),
                              child: Stack(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      color: colorGreenPrimary,
                                      borderRadius: const BorderRadius.all(
                                          Radius.elliptical(9999.0, 9999.0)),
                                    ),
                                  ),
                                  Center(
                                    child: SizedBox(
                                      width: calculatedWidth(17, context),
                                      height: calculatedWidth(17, context),
                                      child: SvgPicture.string(
                                        svgPopupShape,
                                        allowDrawingOutsideViewBox: true,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}
