import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/pages/signup_page.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../helper/api.dart';
import '../models/user.dart';
import '../widgets/input_right_label.dart';
import '../widgets/popup.dart';

class SignIn extends StatefulWidget {
  const SignIn({
    Key? key,
  }) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  Future<User>? _futureUser;
  bool _loadingRegister = false;
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  final userIdFocusNode = FocusNode();
  final passwordIdFocusNode = FocusNode();

  bool visibilityPopup = false;
  int maxlinesPopup = 1;
  String textPopup = "";

  bool isLogin = true;
  AnimationController? animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
  }

  @override
  void dispose() {
    super.dispose();
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
    Size size = MediaQuery.of(context).size;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: GestureDetector(
        onTap: () {
          // Kullanıcı ekrana dokunduğunda, eğer klavye açıksa onu kapatır.
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: colorBackground,
          body: Center(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: Column(
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
                          height: calculatedHeight(50, context),
                        ),
                        //title registration
                        SizedBox(
                          height: calculatedHeight(40, context),
                          width: calculatedWidth(250, context),
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'HOŞ GELDİNİZ',
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
                          height: calculatedHeight(50, context),
                        ),
                        if(!_loadingRegister)...[
                        InputRightLabel(
                          focusNode: userIdFocusNode,
                          width: calculatedWidth(310, context),
                          height: calculatedHeight(75, context),
                          iconData: FontAwesomeIcons.userLarge,
                          controller: userIdController,
                          text: 'Kullanıcı Adı',
                          rightText: 'Kullanıcı Adı',
                        ),
                        SizedBox(
                          height: calculatedHeight(10, context),
                        ),
                        InputRightLabel(
                          focusNode: passwordIdFocusNode,
                          width: calculatedWidth(310, context),
                          height: calculatedHeight(75, context),
                          iconData: FontAwesomeIcons.lock,
                          controller: passwordController,
                          obscureText: true,
                          text: 'Şifre',
                          rightText: 'Şifre',
                        ),
                        SizedBox(
                          height: calculatedHeight(25, context),
                        ),

                        // Signin button
                        MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minWidth: 225,
                          height: 40,
                          padding: const EdgeInsets.all(8),
                          onPressed: () {
                            setState(() {
                              _loadingRegister = true;
                            });
                            if (userIdController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              setState(() {
                                _loadingRegister = false;
                              });
                              showInfoDialog(
                                  context, "Lütfen her alanı doldurunuz!", 0);
                            } else {
                              _futureUser = ApiQueSus().login(
                                User(
                                  userName: userIdController.text,
                                  password: passwordController.text,
                                  isAdmin: 0,
                                ),
                              );
                              _futureUser!.then((user) {
                                setState(() {
                                  _loadingRegister = false;
                                });
                                if (user.error != "") {
                                  showInfoDialog(
                                      context, user.error.toString(), 0);
                                } else {
                                  Navigator.pushNamedAndRemoveUntil(
                                    context,
                                    '/description',
                                    ModalRoute.withName('/description'),
                                  );
                                }
                              });
                            }
                          },
                          color: colorGreenPrimary,
                          textColor: Colors.white,
                          child: SizedBox(
                            width: 225,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Giriş Yap",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.login),
                              ],
                            ),
                          ),
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
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                        const SignUp(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  var begin = const Offset(0.0, 1.0);
                                  var end = Offset.zero;
                                  var curve = Curves.easeInOutExpo;

                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve));

                                  var offsetAnimation = animation.drive(tween);

                                  return SlideTransition(
                                    position: offsetAnimation,
                                    child: child,
                                  );
                                },
                                transitionDuration:
                                    const Duration(milliseconds: 1000),
                              ),
                            );
                          },
                          color: Colors.white,
                          textColor: colorGreenPrimary,
                          child: SizedBox(
                            width: 225,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "Kayıt Ol",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.app_registration),
                              ],
                            ),
                          ),
                        ),
                        ]else...[
                          CircularProgressIndicator(
                          color: colorGreenPrimary,
                        ),
                        ]
                      ],
                    ),
                  ),
                ),

                //durumları göstermek için popup
                Visibility(
                  visible: visibilityPopup,
                  child: Popup(
                    width: calculatedWidth(310, context),
                    text: textPopup,
                    maxLines: maxlinesPopup,
                    padding:
                        EdgeInsets.only(top: calculatedHeight(336, context)),
                    onTapClose: () {
                      setState(() {
                        visibilityPopup = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
