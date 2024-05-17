import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/pages/about_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/secret.dart';
import '../pages/signin_page.dart';

class QueSusDrawer extends StatefulWidget {
  const QueSusDrawer({super.key});

  @override
  State<QueSusDrawer> createState() => _QueSusDrawerState();
}

class _QueSusDrawerState extends State<QueSusDrawer> {
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
              builder: (context) => const AboutPage(),
            ),
            (route) => false);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingUser = true;
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return userSession.isAdmin == 1
        ? Drawer(
            // Sol menü
            backgroundColor: colorBackground,
            shadowColor: colorGreenPrimary,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: const Icon(FontAwesomeIcons.house),
                  title: Text(
                    'QueSus',
                    style: GoogleFonts.montserrat(
                      color: colorGreenPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: colorGreenPrimary,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/description');
                  },
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
                ListTile(
                  leading: const Icon(FontAwesomeIcons.question),
                  title: Text(
                    'Soru İşlemleri',
                    style: GoogleFonts.montserrat(
                      color: colorGreenPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: colorGreenPrimary,
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, "/questions", (route) => false);
                  },
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
                ListTile(
                  leading: const Icon(FontAwesomeIcons.person),
                  title: Text(
                    'Kullanıcı İşlemleri',
                    style: GoogleFonts.montserrat(
                      color: colorGreenPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: colorGreenPrimary,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/users');
                  },
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
                ListTile(
                  leading: const Icon(FontAwesomeIcons.chartPie),
                  title: Text(
                    'Rapor',
                    style: GoogleFonts.montserrat(
                      color: colorGreenPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: colorGreenPrimary,
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/report');
                  },
                ),
              ],
            ),
          )
        : const SizedBox();
  }
}
