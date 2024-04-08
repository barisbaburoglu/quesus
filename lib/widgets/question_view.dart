import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/helper/api.dart';
import 'package:quesus/pages/result_page.dart';

import '../constants/colors.dart';
import '../constants/secret.dart';
import '../models/answer.dart';
import '../models/option.dart';
import 'options.dart';

typedef void OptionSelectedCallback(Option option);

class QuestionsPageView extends StatefulWidget {
  final List results;
  final List optionList;
  final int maxScore;

  QuestionsPageView(
      {required this.results,
      required this.optionList,
      required this.maxScore});

  @override
  _QuestionsPageViewState createState() => _QuestionsPageViewState();
}

class _QuestionsPageViewState extends State<QuestionsPageView> {
  late List<Option> _userAnswerList = [];
  List<String> correctanswerlist = [];
  int currentPagePosition = 0;
  PageController _controller = PageController();
  bool visibleQuestion = false;

  int _totalScore = 0;

  @override
  void initState() {
    super.initState();

    _userAnswerList.addAll(widget.results.map((e) => Option()));

    correctanswerlist = [];

    WidgetsBinding.instance.addPostFrameCallback((_) => showCustomOkDialog(
        context, widget.results.elementAt(0).keywords, "Soruyu Göster"));
  }

  void showCustomOkDialog(
      BuildContext context, String content, String btnText) {
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
                title: Text(
                  "Anahtar Kelimeler",
                  style: GoogleFonts.montserrat(
                    color: colorGreenLight,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(content,
                            style: GoogleFonts.montserrat(
                              color: colorGreenPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                      ],
                    ),
                  ),
                ),
                actions: [
                  Center(
                    child: MaterialButton(
                      color: colorGreenLight,
                      onPressed: () {
                        setState(() {
                          visibleQuestion = true;
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Soruyu Göster",
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

  void showScoreDialog(BuildContext context, int index, int puan, int score) {
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
                  score == 1
                      ? FontAwesomeIcons.circleCheck
                      : FontAwesomeIcons.circleXmark,
                  color: score == 1 ? colorGreenLight : colorRed,
                  size: 50,
                ),
                content: SizedBox(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                            score == 1
                                ? "Doğru Cevap \n\n +1"
                                : "Yanlış Cevap \n\n -1",
                            style: GoogleFonts.montserrat(
                              color: score == 1 ? colorGreenPrimary : colorRed,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                        const SizedBox(
                          height: 25,
                        ),
                        Text("Puan : $puan",
                            style: GoogleFonts.montserrat(
                              color: score == 1 ? colorGreenPrimary : colorRed,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            textScaleFactor: 1),
                      ],
                    ),
                  ),
                ),
                actions: [
                  index + 1 == widget.results.length
                      ? Center(
                          child: MaterialButton(
                            color: colorGreenLight,
                            onPressed: () async {
                              for (var answer in _userAnswerList) {
                                var s = await ApiQueSus().createAnswer(Answer(
                                    optionId: answer.id,
                                    userId: userSession.id));
                              }

                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => ResultPage(
                                        point: _totalScore,
                                        maxPoint: widget.results.length),
                                  ),
                                  (route) => false);
                            },
                            child: Text(
                              "Sonucu Gör",
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      : Center(
                          child: MaterialButton(
                            color: colorGreenLight,
                            onPressed: () {
                              Navigator.pop(context);

                              showCustomOkDialog(
                                  context,
                                  widget.results.elementAt(index + 1).keywords,
                                  "Tamam");
                            },
                            child: Text(
                              "Sonraki Soru",
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
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width > 765
                    ? MediaQuery.of(context).size.width * 0.5
                    : MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.85,
                child: Center(
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemCount: widget.results.length,
                    pageSnapping: true,
                    onPageChanged: (position) {
                      setState(() {
                        visibleQuestion = false;
                      });
                      currentPagePosition = position;
                    },
                    itemBuilder: (context, index) {
                      Option userAnswer = _userAnswerList[index];
                      int checkedOptionPosition =
                          widget.optionList[index].indexOf(userAnswer);

                      return !visibleQuestion
                          ? Center(
                              child: CircularProgressIndicator(
                                color: colorGreenLight,
                              ),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              '${index + 1} / ${widget.results.length}',
                                              style: GoogleFonts.montserrat(
                                                color: colorGreenSecondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ]),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            TextButton(
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(20),
                                              ),
                                              onPressed: () {},
                                              child: Text(
                                                'Puan : $_totalScore',
                                                style: GoogleFonts.montserrat(
                                                  color: colorGreenLight,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    '${widget.results.elementAt(index).question}',
                                    style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: colorGreenPrimary),
                                    textAlign: TextAlign.justify,
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Options(
                                    index: index,
                                    optionList: widget.optionList,
                                    selectedPosition: checkedOptionPosition,
                                    onOptionsSelected: (selectedOption) {
                                      _userAnswerList[currentPagePosition] =
                                          selectedOption;

                                      _controller.animateToPage(
                                          currentPagePosition ==
                                                  widget.results.length - 1
                                              ? currentPagePosition
                                              : currentPagePosition + 1,
                                          duration:
                                              const Duration(milliseconds: 300),
                                          curve: Curves.easeIn);

                                      setState(() {
                                        _totalScore =
                                            _totalScore + selectedOption.score!;
                                      });
                                      showScoreDialog(context, index,
                                          _totalScore, selectedOption.score!);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                ],
                              ),
                            );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
