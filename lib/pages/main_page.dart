import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quesus/pages/description_page.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/secret.dart';
import '../widgets/popup.dart';
import 'splash_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
  }) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with WidgetsBindingObserver {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  late bool checkingConnection;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  final userIdController = TextEditingController();
  final passwordController = TextEditingController();

  final userIdFocusNode = FocusNode();
  final passwordIdFocusNode = FocusNode();

  bool visibilityPopup = false;
  int maxlinesPopup = 1;
  String textPopup = "";

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
    super.initState();

    checkingConnection = true;

    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _loadingUser = true;

    getUser();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();

    super.dispose();
  }

  // Cihazın internet bağlantısı durumunu kontrol etmek için kullanılır.
  // Daha sonra, cihazın bağlantı durumunu güncellemek için
  // _updateConnectionStatus(result) fonksiyonu çağrılır.
  // Bağlantı durumu güncellendikten sonra uygulama, bağlantı durumuna göre
  // gerekli işlemleri gerçekleştirebilir.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();

      setState(() {
        checkingConnection = false;
      });
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  // Cihazın bağlantı durumunu güncellemek için kullanılır
  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Init.instance.initialize(),
        builder: (context, AsyncSnapshot snapshot) {
          if (checkingConnection) {
            return Center(
              child: CircularProgressIndicator(
                color: colorGreenPrimary,
              ),
            );
          } else {
            if (_connectionStatus.toString() == "ConnectivityResult.none") {
              //İnternet bağlantısı yoksa çalışır, popup açar.
              //Eğer butona tıklarsa uygulamadan çıkar,
              //interneti açarsa bağlantı durumu güncellenir ve
              //giriş yapması için kullanıcı adı ve şifre inputları gelir.
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: colorBackground,
                  title: const Center(child: Text("QueSus")),
                ),
                backgroundColor: Colors.black,
                body: Center(
                  child: Popup(
                    width: 310,
                    text: "YOU'RE NOT CONNECTED\n TO A NETWORK!",
                    maxLines: 2,
                    padding: EdgeInsets.only(
                      top: 336,
                    ),
                    onTapClose: () {
                      //uygulamayı kapatır.
                      exit(0);
                    },
                  ),
                ),
              );
            } else {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const MaterialApp(
                  debugShowCheckedModeBanner: false,
                  home: Splash(),
                );
              } else {
                //İnternet bağlantısı varsa çalışır, kullanıcı adı ve şifre isteyen bölüm
                return _loadingUser
                    ? Center(
                        child: CircularProgressIndicator(
                          color: colorGreenPrimary,
                        ),
                      )
                    : userSession.userName!.isEmpty
                        ? const SignIn()
                        : const DescriptionPage();
              }
            }
          }
        });
  }
}
