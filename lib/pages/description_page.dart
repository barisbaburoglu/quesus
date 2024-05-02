import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/pages/question_page.dart';
import 'package:quesus/pages/questions_page.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/secret.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';

class DescriptionPage extends StatefulWidget {
  const DescriptionPage({super.key});

  @override
  State<DescriptionPage> createState() => _DescriptionPageState();
}

class _DescriptionPageState extends State<DescriptionPage>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers = [];
  late List<Animation<Offset>> _animations = [];

  late AnimationController _animationControllerBtn;
  bool _isVisible = false;

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
        _startAnimations();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingUser = true;

    var checkUser = getUser();

    _controllers = List.generate(
      5,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1000),
      ),
    );

    _animations = List.generate(
      5,
      (index) => Tween<Offset>(
        begin: const Offset(20, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          curve: Curves.easeInOut,
          parent: _controllers[index],
        ),
      ),
    );

    _animationControllerBtn = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;
      setState(() {
        _isVisible = true;
      });
      _animationControllerBtn.forward();
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _animationControllerBtn.dispose();
    super.dispose();
  }

  void _startAnimations() {
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 500), () {
        _controllers[i].forward();
      });
    }
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  Image.asset(
                    'assets/icon.png', // İkonunuzun dosya yolu
                    width: 200.0, // İkonun genişliği
                    height: 200.0, // İkonun yüksekliği
                  ),
                  Text(
                "QUESTIONNAIRE SUSTAINABILITY",
                style: TextStyle(
                  color: colorGreenPrimary,
                  fontSize: 12.0, // Yazı büyüklüğü
                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                ),
              ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  SizedBox(
                    height: calculatedHeight(40, context),
                    width: calculatedWidth(250, context),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'NASIL OYNANIR?',
                        style: GoogleFonts.josefinSans(
                          fontSize: 30,
                          color: colorGreenLight,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        softWrap: false,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: calculatedHeight(10, context),
                  ),
                  SizedBox(
                    width: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildListItem("1. İlk madde", 0),
                        _buildListItem("2. İkinci madde", 1),
                        _buildListItem("3. Üçüncü madde", 2),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: calculatedHeight(25, context),
                  ),
                  AnimatedOpacity(
                    opacity: _isVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 500),
                    child: MaterialButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minWidth: 225,
                      height: 40,
                      padding: const EdgeInsets.all(8),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionPage(
                                    title: "QueSus",
                                    bankId: 1,
                                    codeLang: "tr",
                                    maxScore: 3,
                                  )),
                        );
                      },
                      color: colorGreenPrimary,
                      textColor: Colors.white,
                      child: SizedBox(
                        width: 225,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Başla",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.play_arrow),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: calculatedHeight(10, context),
                  ),
                ],
              ),
            ),
          );
  }

  Widget _buildListItem(String text, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SlideTransition(
        position: _animations[index],
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: colorGreenPrimary),
        ),
      ),
    );
  }
}
