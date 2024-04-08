import 'package:flutter/material.dart';
import 'package:quesus/constants/colors.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Animasyon süresi
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0.0, -1.0), // Yukarıdan başlangıç pozisyonu
      end: const Offset(0.0, 0.0), // Ortada bitiş pozisyonu
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut, // Animasyon eğrisi
      ),
    );

    // Animasyon başladığında
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _offsetAnimation, // Resim için animasyonlu pozisyon
              child: Image.asset(
                'assets/icon.png', // İkonunuzun dosya yolu
                width: 200.0, // İkonun genişliği
                height: 200.0, // İkonun yüksekliği
              ),
            ),
            SlideTransition(
              position: _offsetAnimation, // Yazı için animasyonlu pozisyon
              child: Text(
                "QUESTIONNAIRE SUSTAINABILITY",
                style: TextStyle(
                  color: colorGreenPrimary,
                  fontSize: 12.0, // Yazı büyüklüğü
                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class Init {
  Init._();
  static final instance = Init._();

  Future initialize() async {
    // Burası, uygulamanızın ihtiyaç duyduğu kaynakları başlatabileceğiniz yerdir.
    // açılış ekranı görüntülenir.
    await Future.delayed(const Duration(seconds: 3));
  }
}
