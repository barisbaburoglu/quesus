import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/helper/api.dart';
import 'package:quesus/models/bank.dart';
import 'package:quesus/models/option.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/secret.dart';
import '../models/question.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/input_edit.dart';
import '../widgets/question_tile.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({
    super.key,
  });

  @override
  State<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage>
    with TickerProviderStateMixin {
  late QuestionList questionList;
  late SharedPreferences prefs;
  late bool _loadingUser;
  late bool _loadingQuestions;

  TextEditingController countTopController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<TextEditingController> optionsControllers = [];
  List<int> scores = [];

  final questionFocusNode = FocusNode();
  final keywordsFocusNode = FocusNode();
  final countTopFocusNode = FocusNode();

  bool showAllQuestions = false;

  getUser() async {
    prefs = await SharedPreferences.getInstance();
    userSession.id = prefs.getInt('userId') ?? 0;
    userSession.userName = prefs.getString('userName') ?? '';
    userSession.isAdmin = prefs.getInt('isAdmin') ?? 0;

    setState(() {
      _loadingUser = false;
      if (userSession.userName!.isEmpty) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const SignIn(),
            ),
            (route) => false);
      }
    });
  }

  void getQuestions() async {
    questionList = await ApiQueSus()
        .getQuestions(1, 1, searchController.text);

    setState(() {
      _loadingQuestions = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingUser = true;
    _loadingQuestions = true;

    var checkUser = getUser();
    var q = getQuestions();
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
    return _loadingUser
        ? Center(
            child: CircularProgressIndicator(
              color: colorGreenPrimary,
            ),
          )
        : Scaffold(
            backgroundColor: colorBackground,
            appBar: const QueSusAppBar(),
            drawer: const QueSusDrawer(),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: calculatedHeight(25, context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: colorGreenPrimary,
                              width: 1,
                            ),
                          ),
                          minWidth: 150,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          onPressed: () {
                            countTopController.text =
                                questionList.questionCount!.toString();
                            showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                  return AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                        horizontal:
                                            calculatedWidth(50, context),
                                        vertical:
                                            calculatedHeight(250, context)),
                                    titlePadding: EdgeInsets.all(10),
                                    backgroundColor: colorBackground,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Ayarlar',
                                          style: GoogleFonts.montserrat(
                                            color: colorGreenPrimary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 15,
                                          ),
                                          child: Divider(
                                            color: colorGreenSecondary,
                                            height: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                    content: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: calculatedWidth(200, context),
                                          height:
                                              calculatedHeight(100, context),
                                          child: Center(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                InputEdit(
                                                  focusNode: countTopFocusNode,
                                                  controller:
                                                      countTopController,
                                                  text:
                                                      'Gösterilecek Soru Sayısı',
                                                  maxLines: 1,
                                                  textInputType:
                                                      TextInputType.number,
                                                  inputFormatters: <
                                                      TextInputFormatter>[
                                                    FilteringTextInputFormatter
                                                        .digitsOnly
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
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
                                          Bank bank = Bank();
                                          bank.id = 1;
                                          bank.questionCount = int.parse(
                                              countTopController.text);
                                          var s = await ApiQueSus()
                                              .updateBank(bank)
                                              .then(
                                            (value) {
                                              getQuestions();
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                        child: const Text('Kaydet'),
                                      ),
                                    ],
                                  );
                                });
                              },
                            );
                          },
                          color: Colors.white,
                          textColor: colorGreenPrimary,
                          child: SizedBox(
                            width: 150,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Ayarlar",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Icon(FontAwesomeIcons.gears),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Sorular",
                            style: GoogleFonts.montserrat(
                              color: colorGreenPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minWidth: 100,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            onPressed: () async {
                              TextEditingController questionController =
                                  TextEditingController();

                              TextEditingController keywordsController =
                                  TextEditingController();

                              optionsControllers = List.generate(
                                  5, (index) => TextEditingController());
                              scores = List.generate(5, (index) => -1);

                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      backgroundColor: colorBackground,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      titlePadding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Yeni Soru Tanımlama',
                                            style: GoogleFonts.montserrat(
                                              color: colorGreenPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Divider(
                                              color: colorGreenSecondary,
                                              height: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: calculatedWidth(
                                                    250, context),
                                                height: calculatedHeight(
                                                    618, context),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    padding: EdgeInsets.only(
                                                      right: calculatedWidth(
                                                          10, context),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InputEdit(
                                                          focusNode:
                                                              questionFocusNode,
                                                          controller:
                                                              questionController,
                                                          text: 'Soru',
                                                          maxLines: 2,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: [],
                                                        ),
                                                        InputEdit(
                                                          focusNode:
                                                              keywordsFocusNode,
                                                          controller:
                                                              keywordsController,
                                                          text:
                                                              'Anahtar Kelimeler',
                                                          maxLines: 2,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: [],
                                                        ),
                                                        Column(
                                                          children:
                                                              List.generate(5,
                                                                  (index) {
                                                            return Row(
                                                              children: [
                                                                Checkbox(
                                                                  value: scores[
                                                                          index] ==
                                                                      1,
                                                                  checkColor:
                                                                      colorGreenPrimary,
                                                                  onChanged:
                                                                      (bool?
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      for (int i =
                                                                              0;
                                                                          i < scores.length;
                                                                          i++) {
                                                                        scores[i] =
                                                                            -1;
                                                                      }
                                                                      scores[index] =
                                                                          value!
                                                                              ? 1
                                                                              : -1;
                                                                    });
                                                                  },
                                                                ),
                                                                Expanded(
                                                                  child:
                                                                      InputEdit(
                                                                    focusNode:
                                                                        questionFocusNode,
                                                                    controller:
                                                                        optionsControllers[
                                                                            index],
                                                                    text:
                                                                        "cevap ${index + 1}",
                                                                    maxLines: 1,
                                                                    textInputType:
                                                                        TextInputType
                                                                            .text,
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
                                                keywordsController
                                                    .text.isEmpty ||
                                                optionsControllers.any(
                                                    (x) => x.text.isEmpty) ||
                                                !scores.any((x) => x == 1)) {
                                              print(optionsControllers
                                                  .any((x) => x.text.isEmpty));
                                              showInfoDialog(
                                                  context,
                                                  "Lütfen tüm alanları eksiksiz doldurunuz!",
                                                  0);
                                            } else {
                                              Question questionNew = Question();
                                              questionNew.bankId = 1;
                                              questionNew.question =
                                                  questionController.text;
                                              questionNew.keywords =
                                                  keywordsController.text;
                                              List<Option> optionList = [];
                                              for (var i = 0; i < 5; i++) {
                                                Option option = Option(
                                                  score: scores[i],
                                                  choice: optionsControllers[i]
                                                      .text,
                                                );
                                                optionList.add(option);
                                              }
                                              questionNew.options = optionList;

                                              var s = await ApiQueSus()
                                                  .createQuestion(questionNew)
                                                  .then(
                                                (value) {
                                                  setState(() {
                                                    _loadingQuestions = true;
                                                  });
                                                  getQuestions();
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }
                                          },
                                          child: const Text('Kaydet'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                            color: Colors.white,
                            textColor: colorGreenPrimary,
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.plus,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Yeni",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: InputEdit(
                        focusNode: keywordsFocusNode,
                        controller: searchController,
                        text: 'Soru Ara',
                        maxLines: 1,
                        textInputType: TextInputType.text,
                        inputFormatters: [],
                        onChanged: (p0) {
                          setState(() {
                            _loadingQuestions = true;
                          });
                          getQuestions();
                        },
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20, vertical: 5),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.start,
                    //     children: [
                    //       Checkbox(
                    //         value: showAllQuestions,
                    //         checkColor: colorGreenPrimary,
                    //         onChanged: (bool? value) {
                    //           setState(() {
                    //             showAllQuestions = value!;
                    //             getQuestions();
                    //           });
                    //         },
                    //       ),
                    //       Text(
                    //         "Tüm Soruları Göster",
                    //         style: GoogleFonts.montserrat(
                    //           color: colorGreenPrimary,
                    //           fontSize: 14,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    _loadingQuestions
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colorGreenPrimary,
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: calculatedWidth(10, context),
                                ),
                                itemCount: questionList.questions!.length,
                                itemBuilder: (context, index) {
                                  return QuestionTile(
                                    index: index,
                                    question: questionList.questions![index],
                                    getQuestion: getQuestions,
                                    onPressed: () async {
                                      var s = await ApiQueSus()
                                          .deleteQuestion(
                                              questionList.questions![index])
                                          .then((value) {
                                        setState(() {
                                          _loadingQuestions = true;
                                        });
                                        getQuestions();
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
