import 'package:flutter/material.dart';
import 'package:quesus/constants/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/secret.dart';
import '../helper/api.dart';
import '../models/shuffle_answer.dart';
import '../widgets/app_bar.dart';
import '../widgets/question_view.dart';
import 'signin_page.dart';

//todo change this name
typedef void Randomise(List options);

class QuestionPage extends StatefulWidget {
  int bankId;
  String codeLang;
  String title;
  int maxScore;

  QuestionPage(
      {Key? key,
      required this.bankId,
      required this.codeLang,
      required this.title,
      required this.maxScore})
      : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  final ApiQueSus _apiQueSus = ApiQueSus();

  List optionList = [];

  late SharedPreferences prefs;
  late bool _loadingUser;
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadingUser = true;

    var checkUser = getUser();
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
            body: _futureWidget(),
          );
  }

  _futureWidget() {
    return FutureBuilder(
      future: _apiQueSus.getQuestions(widget.bankId, 0, ""),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List results = snapshot.data!.questions as List;
          ShuffleOptions(
              result: results,
              shuffler: (options) {
                optionList = options;
              });

          return QuestionsPageView(
            results: results,
            optionList: optionList,
            maxScore: widget.maxScore,
          );
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: colorGreenLight,
          ));
        }
      },
    );
  }
}
