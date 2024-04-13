import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/secret.dart';
import '../pages/signin_page.dart';

class QueSusAppBar extends StatefulWidget implements PreferredSizeWidget {
  const QueSusAppBar({Key? key}) : super(key: key);

  @override
  State<QueSusAppBar> createState() => _QueSusAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _QueSusAppBarState extends State<QueSusAppBar> {
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
    _loadingUser = true;
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/quesuslogo.png',
                    width: 160,
                  ),
                ],
              ),
            ),
            InkWell(
              mouseCursor: SystemMouseCursors.click,
              onTap: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.clear();

                var s = await getUser();
              },
              child: Row(
                children: [
                  Text(
                    "Çıkış",
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    FontAwesomeIcons.powerOff,
                    size: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      backgroundColor:
          colorAppBar, // Renkleri düzenlemek için varsayılan değerleri kullanabilirsiniz.
      foregroundColor: colorGreenPrimary,
      shadowColor: colorGreenPrimary,
    );
  }
}
