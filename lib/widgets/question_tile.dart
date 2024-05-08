import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/widgets/input_edit.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../helper/api.dart';
import '../models/option.dart';
import '../models/question.dart';
import 'input_right_label.dart';

class QuestionTile extends StatefulWidget {
  final int index;
  final Question question;
  final Function() getQuestion;
  final Function()? onPressed;

  const QuestionTile({
    Key? key,
    required this.question,
    required this.index,
    required this.getQuestion,
    required this.onPressed,
  }) : super(key: key);

  @override
  _QuestionTileState createState() => _QuestionTileState();
}

class _QuestionTileState extends State<QuestionTile> {
  TextEditingController questionController = TextEditingController();
  TextEditingController keywordsController = TextEditingController();

  List<TextEditingController> optionsControllers = [];
  List<int> scores = [];

  final questionFocusNode = FocusNode();
  final keywordsFocusNode = FocusNode();

  
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    questionController.text = widget.question.question!;
    keywordsController.text = widget.question.keywords!;

    
    isActive = widget.question.isActive! == 1;

    for (var index = 0; index < widget.question.options!.length; index++) {
      TextEditingController optionController = TextEditingController();
      optionController.text = widget.question.options![index].choice!;
      optionsControllers.add(optionController);
      scores.add(widget.question.options![index].score!);
    }
    
  }

  void showInfoDialog(BuildContext context, String content, int iconType) {
    showDialog(
        barrierDismissible: false,
        useRootNavigator: false,
        context: context,
        builder: (context) => WillPopScope(
              onWillPop: () async {
                return false; // Geri tuşuna basıldığında işlem yapma
              },
              child: AlertDialog(
                backgroundColor: colorBackground,
                title: Icon(
                  iconType == 1
                      ? FontAwesomeIcons.circleCheck
                      : FontAwesomeIcons.circleXmark,
                  color: iconType == 1 ? colorGreenLight : colorRed,
                  size: 50,
                ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          content,
                          style: GoogleFonts.montserrat(
                            color: colorGreenPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                          textScaleFactor: 1,
                        ),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: MaterialButton(
                      color: colorGreenLight,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Tamam",
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: calculatedHeight(80, context),
              width: 25,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${widget.index + 1}",
                  style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                       color: widget.question.isActive == 1
                        ? colorGreenPrimary
                        : Colors.white,),
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 20,
              child: VerticalDivider(
                 color: widget.question.isActive == 1
                        ? colorGreenPrimary
                        : Colors.white,
                width: 2,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: calculatedHeight(80, context),
              width: calculatedWidth(210, context),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' ${questionController.text}',
                  style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                       color: widget.question.isActive == 1
                        ? colorGreenPrimary
                        : Colors.white,),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: colorBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              titlePadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              title: const Icon(
                                FontAwesomeIcons.triangleExclamation,
                                color: Colors.deepOrange,
                                size: 40,
                              ),
                              content: Text(
                                "Silmek istediğinize emin misiniz?",
                                style: GoogleFonts.montserrat(
                                  color: colorGreenPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                              ),
                              actions: [
                                MaterialButton(
                                  color: colorRed,
                                  textColor: Colors.white,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Vazgeç'),
                                ),
                                MaterialButton(
                                  color: colorGreenPrimary,
                                  textColor: Colors.white,
                                  onPressed: widget.onPressed,
                                  child: const Text('Evet, Sil'),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                    child: Icon(
                      FontAwesomeIcons.trashCan,
                      color: colorRed,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  titlePadding: const EdgeInsets.symmetric(vertical: 10),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Soru Düzenleme',
                        style: GoogleFonts.montserrat(
                            color: colorGreenPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 5,
                        ),
                        child: Divider(
                          color: colorGreenSecondary,
                          height: 2,
                        ),
                      ),
                    ],
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: calculatedWidth(250, context),
                            height: calculatedHeight(618, context),
                            child: Center(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  right: calculatedWidth(10, context),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isActive,
                                            checkColor: colorGreenPrimary,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isActive = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Aktif",
                                            style: GoogleFonts.montserrat(
                                              color: colorGreenPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InputEdit(
                                      focusNode: questionFocusNode,
                                      controller: questionController,
                                      text: 'Soru',
                                      maxLines: 2,
                                      textInputType: TextInputType.text,
                                      inputFormatters: [],
                                    ),
                                    InputEdit(
                                      focusNode: keywordsFocusNode,
                                      controller: keywordsController,
                                      text: 'Anahtar Kelimeler',
                                      maxLines: 2,
                                      textInputType: TextInputType.text,
                                      inputFormatters: [],
                                    ),
                                    Column(
                                      children: List.generate(
                                          widget.question.options!.length,
                                          (index) {
                                        return Row(
                                          children: [
                                            Checkbox(
                                              value: scores[index] == 1,
                                              checkColor: colorGreenPrimary,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  for (int i = 0;
                                                      i < scores.length;
                                                      i++) {
                                                    scores[i] = -1;
                                                  }
                                                  scores[index] =
                                                      value! ? 1 : -1;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: InputEdit(
                                                focusNode: questionFocusNode,
                                                controller:
                                                    optionsControllers[index],
                                                text: "cevap ${index + 1}",
                                                maxLines: 1,
                                                textInputType:
                                                    TextInputType.text,
                                                inputFormatters: [],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    MaterialButton(
                      color: colorRed,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Vazgeç'),
                    ),
                    MaterialButton(
                      color: colorGreenPrimary,
                      textColor: Colors.white,
                      onPressed: () async {
                        if (questionController.text.isEmpty ||
                            keywordsController.text.isEmpty ||
                            optionsControllers.any((x) => x.text.isEmpty) ||
                            !scores.any((x) => x == 1)) {
                          showInfoDialog(context,
                              "Lütfen tüm alanları eksiksiz doldurunuz!", 0);
                        } else {
                          Question questionUpdate = Question();
                          questionUpdate = widget.question;
                          questionUpdate.question = questionController.text;
                          questionUpdate.keywords = keywordsController.text;
                          questionUpdate.isActive = isActive ? 1 : 0;
                          for (var i = 0;
                              i < questionUpdate.options!.length;
                              i++) {
                            questionUpdate.options![i].score = scores[i];
                            questionUpdate.options![i].choice =
                                optionsControllers[i].text;
                          }

                          var s = await ApiQueSus()
                              .updateQuestion(questionUpdate)
                              .then(
                            (value) {
                              widget.getQuestion();
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: const Text('Güncelle'),
                    ),
                  ],
                );
              });
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    questionController.dispose();

    for (var i = 0; i < widget.question.options!.length; i++) {
      optionsControllers[i].dispose();
    }
    super.dispose();
  }
}
