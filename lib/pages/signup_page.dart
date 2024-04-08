import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/pages/signin_page.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../helper/api.dart';
import '../models/user.dart';
import '../widgets/input_right_label.dart';
import '../widgets/popup.dart';

class SignUp extends StatefulWidget {
  const SignUp({
    Key? key,
  }) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin {
  Future<User>? _futureUser;
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordAgainController = TextEditingController();

  final userIdFocusNode = FocusNode();
  final passwordIdFocusNode = FocusNode();
  final passwordIdAgainFocusNode = FocusNode();

  bool _loadingRegister = false;

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

  void showRedirectDialog(BuildContext context, String content, int iconType) {
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
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const SignIn(),
                          ),
                          (route) => false,
                        );
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
          appBar: AppBar(
            title: const Text(
              "Giriş Yap",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            backgroundColor: colorGreenPrimary,
            foregroundColor: Colors.white,
            leading: BackButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          body: Center(
            child: Stack(
              children: <Widget>[
                SingleChildScrollView(
                  child: Center(
                    child: _loadingRegister
                        ? CircularProgressIndicator(
                            color: colorGreenPrimary,
                          )
                        : Column(
                            children: [
                              SizedBox(
                                height: calculatedHeight(25, context),
                              ),
                              Image.asset(
                                'assets/icon.png', // İkonunuzun dosya yolu
                                width: 200.0, // İkonun genişliği
                                height: 200.0, // İkonun yüksekliği
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
                                    'KAYIT OL',
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
                              // InputRightLabel(
                              //   focusNode: userIdFocusNode,
                              //   width: calculatedWidth(310, context),
                              //   height: calculatedHeight(75, context),
                              //   iconData: FontAwesomeIcons.userLarge,
                              //   controller: userIdController,
                              //   text: 'Ad Soyad',
                              //   rightText: 'Ad Soyad',
                              // ),
                              // SizedBox(
                              //   height: calculatedHeight(10, context),
                              // ),
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
                                height: calculatedHeight(10, context),
                              ),
                              InputRightLabel(
                                focusNode: passwordIdAgainFocusNode,
                                width: calculatedWidth(310, context),
                                height: calculatedHeight(75, context),
                                iconData: FontAwesomeIcons.lock,
                                controller: passwordAgainController,
                                obscureText: true,
                                text: 'Şifre Tekrar',
                                rightText: 'Şifre Tekrar',
                              ),
                              SizedBox(
                                height: calculatedHeight(25, context),
                              ),

                              // Signup button
                              MaterialButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                minWidth: 225,
                                height: 40,
                                padding: const EdgeInsets.all(8),
                                onPressed: () async {
                                  _loadingRegister = true;
                                  if (userIdController.text.isEmpty ||
                                      passwordController.text.isEmpty ||
                                      passwordAgainController.text.isEmpty) {
                                    _loadingRegister = false;
                                    showInfoDialog(context,
                                        "Lütfen her alanı doldurunuz!", 0);
                                  } else if (!RegExp(
                                          r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$') //^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!.@#\$&*~]).{8,}$ // ^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$
                                      .hasMatch(passwordController.text)) {
                                    _loadingRegister = false;
                                    showInfoDialog(
                                        context,
                                        "Şifreniz en az 8 karakter,\nbir büyük harf ve rakam içermelidir.",
                                        0);
                                  } else if (passwordController.text !=
                                      passwordAgainController.text) {
                                    _loadingRegister = false;
                                    showInfoDialog(
                                        context, "Şifreler aynı olmalıdır!", 0);
                                  } else {
                                    _futureUser = ApiQueSus().createUser(
                                      User(
                                        userName: userIdController.text,
                                        password: passwordController.text,
                                        isAdmin: 0,
                                      ),
                                    );
                                    _futureUser!.then(
                                      (user) {
                                        _loadingRegister = false;
                                        showRedirectDialog(
                                            context,
                                            "Kaydınız Başarılı \n\n Giriş sayfasından giriş yapabilirsiniz.",
                                            1);
                                      },
                                    );
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
                                        "Kayıt Ol",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(Icons.app_registration),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: calculatedHeight(25, context),
                              ),
                            ],
                          ),
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
