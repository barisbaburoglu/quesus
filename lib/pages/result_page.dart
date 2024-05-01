import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:quesus/widgets/app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/secret.dart';
import '../widgets/drawer.dart';

class ResultPage extends StatefulWidget {
  final int point;
  final int maxPoint;
  const ResultPage({
    super.key,
    required this.point,
    required this.maxPoint,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;

  late AnimationController _animationControllerBtn;
  bool _isVisible = false;

  double percent = 0;

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
      } else {
        if (widget.maxPoint == 0) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/description',
            ModalRoute.withName('/description'),
          );
        } else {
          percent = (((widget.point + widget.maxPoint) / 2) / widget.maxPoint);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingUser = true;

    var checkUser = getUser();
  }

  @override
  void dispose() {
    super.dispose();
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
            drawer: userSession.isAdmin == 1 ? const QueSusDrawer() : null,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  Image.asset(
                    'assets/icon.png', // İkonunuzun dosya yolu
                    width: 150.0, // İkonun genişliği
                    height: 150.0, // İkonun yüksekliği
                  ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  Text(
                    percent < 0.4
                        ? "DOĞA KATİLİ"
                        : (percent > 0.40 && percent < 0.70)
                            ? "DOĞA SEVER"
                            : "DOĞA KAHRAMANI",
                    style: GoogleFonts.montserrat(
                      color: percent < 0.4 ? colorRed : colorGreenPrimary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  CircularPercentIndicator(
                    radius: 60.0,
                    lineWidth: 15.0,
                    percent: percent,
                    center: Text(
                      "${(percent * 100).toStringAsFixed(2)}%",
                      style: GoogleFonts.montserrat(
                        color: colorGreenPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    progressColor: colorGreenLight,
                    backgroundColor: colorGreenSecondary.withOpacity(0.5),
                    animation: true,
                    animationDuration: 1200,
                  ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  Text(
                    "Puan : ${widget.point}",
                    style: GoogleFonts.montserrat(
                      color: percent < 0.4 ? colorRed : colorGreenPrimary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: colorGreenPrimary,
                        width: 1,
                      ),
                    ),
                    minWidth: 225,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/description',
                        ModalRoute.withName('/description'),
                      );
                    },
                    color: Colors.white,
                    textColor: colorGreenPrimary,
                    child: SizedBox(
                      width: 225,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(FontAwesomeIcons.backwardStep),
                          SizedBox(width: 5),
                          Text(
                            "Başa Dön",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: calculatedHeight(50, context),
                  ),
                ],
              ),
            ),
          );
  }
}
