import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/pages/question_page.dart';
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

  Color _animatedColor = colorGreenPrimary;

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

  }


  void _startAnimations() {
    Timer.periodic(const Duration(milliseconds: 400), (timer) {
      if(mounted){
        setState(() {
          _animatedColor = _animatedColor == colorGreenPrimary ? colorGreenLight : colorGreenPrimary;
        });
      }
      
    });
  }

  @override
  Widget build(BuildContext context) {
    double contentWidth = MediaQuery.of(context).size.width < 768 ? 300 : 700;
    double imageWidth = MediaQuery.of(context).size.width < 768 ? 250 : 400;
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
              child: SizedBox(
                width: contentWidth,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: calculatedHeight(20, context),
                    ),
                    // Image.asset(
                    //   'assets/icon.png', // İkonunuzun dosya yolu
                    //   width: 200.0, // İkonun genişliği
                    //   height: 200.0, // İkonun yüksekliği
                    // ),
                    // Text(
                    //   "QUESTIONS SUSTAINABILITY",
                    //   style: TextStyle(
                    //     color: colorGreenPrimary,
                    //     fontSize: 12.0, // Yazı büyüklüğü
                    //     fontWeight: FontWeight.bold, // Yazı kalınlığı
                    //   ),
                    // ),
                    // SizedBox(
                    //   height: calculatedHeight(25, context),
                    // ),
                    SizedBox(
                      height: calculatedHeight(40, context),
                      width: calculatedWidth(250, context),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'Oyun Yönergesi',
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
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - calculatedHeight(175, context),
                      child: SingleChildScrollView(
                        child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Text(
                              "1.	Başla butonu ile oyun başlatılır",
                              style: TextStyle(fontSize: 16, color: colorGreenPrimary, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Center(
                              child: MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minWidth: 100,
                                height: 20,
                                padding: const EdgeInsets.all(8),
                                onPressed: () {},
                                color: colorGreenPrimary,
                                textColor: Colors.white,
                                child: SizedBox(
                                  width: 100,
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
                              height: calculatedHeight(20, context),
                            ),
                            Text(
                              "2.	Anahtar Kelimeler sayfası gelir. Verilen anahtar kelimelerle ilgili internetten araştırma yapılıp sayfaya geri dönülür ve Soruyu Göster butonuna tıklanır.",
                              style: TextStyle(fontSize: 16, color: colorGreenPrimary, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Center(
                              child: Image.asset(
                                'assets/2.jpg', 
                                width: imageWidth, 
                              ),
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Text(
                              "3.	Soru sayfası açılır. Soru sayfasında çıkan soru cevaplanır. ",
                              style: TextStyle(fontSize: 16, color: colorGreenPrimary, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Center(
                              child: Image.asset(
                                'assets/3.jpg',
                                width: imageWidth, 
                              ),
                                              
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Text(
                              "4.	Soru yanıtlandığında sorunun doğru veya yanlış olduğuna dair sayfa açılır. Doğru ise 1 puan kazanılır yanlış ise 1 puan kaybedilir. ",
                              style: TextStyle(fontSize: 16, color: colorGreenPrimary, fontWeight: FontWeight.bold,),
                              textAlign: TextAlign.left,
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Center(
                                  child: Image.asset(
                                    'assets/4-1.jpg',
                                    width: imageWidth / 2, 
                                  ),                 
                                ),
                                Center(
                                  child: Image.asset(
                                    'assets/4-2.jpg',
                                    width: imageWidth / 2, 
                                  ),                 
                                ),
                              ],
                            ),
                            SizedBox(
                              height: calculatedHeight(50, context),
                            ),
                            Center(
                              child: Text(
                                "Başlamak için butona bas!",
                                style: TextStyle(fontSize: 16, color: _animatedColor, fontWeight: FontWeight.bold,),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                              ),
                            ),
                            SizedBox(
                              height: calculatedHeight(10, context),
                            ),
                            Center(
                              child: Icon(
                                FontAwesomeIcons.downLong,
                                size: 20,
                                color: _animatedColor, 
                              ),
                            ),
                            SizedBox(
                              height: calculatedHeight(20, context),
                            ),
                            Center(
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
                              height: calculatedHeight(20, context),
                            ),
                          ],
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
