import 'package:flutter/gestures.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/constants/dimensions.dart';
import 'package:quesus/pages/signin_page.dart';

import '../constants/colors.dart';
import '../widgets/app_bar.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth= MediaQuery.of(context).size.width;
    double fontsize = screenWidth < 768 ? 12 : 16;
    double paddingText = screenWidth < 768 ? 15 : (screenWidth >= 768 && screenWidth < 1400)? 75 : 120 ;
    double widthText = screenWidth - (calculatedWidth(paddingText, context) * 2);
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/quesuslogo.png',
                width: 150,
              ),
              Text(
                "QUESTIONS SUSTAINABILITY",
                style: GoogleFonts.montserrat(
                  color: colorGreenPrimary,
                  fontSize: 11.0, // Yazı büyüklüğü
                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                ),
              ),
            ],
          ),
        ),
        backgroundColor:
            colorAppBar, // Renkleri düzenlemek için varsayılan değerleri kullanabilirsiniz.
        foregroundColor: colorGreenPrimary,
        shadowColor: colorGreenPrimary,
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: calculatedHeight(20, context)),
              Image.asset(
                'assets/icon.png', // İkonunuzun dosya yolu
                width: 150.0, // İkonun genişliği
                height: 150.0, // İkonun yüksekliği
              ),
              Text(
                "QUESTIONS SUSTAINABILITY",
                style: GoogleFonts.montserrat(
                  color: colorGreenPrimary,
                  fontSize: 12.0, // Yazı büyüklüğü
                  fontWeight: FontWeight.bold, // Yazı kalınlığı
                ),
              ),
              SizedBox(height: calculatedHeight(50, context)),
              SizedBox(
                width: widthText,
                child: Text(
                  'Bu uygulama Kahramanmaraş İstiklal Üniversitesi, Bilimsel Araştırma Projeleri Koordinasyon Birimi tarafından desteklenen 2022/3-2 BAP numaralı “Sürdürülebilirlik Bilgi Düzeyi Ölçeği ve Sürdürülebilirlik Soru Bankası Geliştirilmesi” başlıklı proje kapsamında geliştirilmiştir. Oyunlaştırma destekli soru cevaplama uygulamasıdır. Vermiş olduğunuz cevapların içten cevaplar olması araştırmamız için önemlidir. Cevaplar veya sonuçlar okuldaki herhangi bir dersinizin notlandırılmasında kullanılmayacaktır. Herhangi bir şekilde kişisel bilgileriniz ile birlikte cevaplar herhangi bir platformda paylaşılmayacaktır.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.montserrat(
                    fontSize: fontsize,
                    color: colorGreenPrimary,
                  ),
                ),
              ),
              SizedBox(height: calculatedHeight(20, context)),
              SizedBox(
                width: widthText,
                child: Text(
                  'Bu çalışma tamamen gönüllülük esasına dayalıdır ve kişisel bilgileriniz araştırmacıların dışındaki kişi veya kurumlarla paylaşılmayacaktır. Mekan tasarımında sürdürülebilirlik bilgisini ölçmeyi hedefleyen bu ölçeğin geliştirilmesi sürecine destek olmanız araştırmamızı geliştirebilme açısından oldukça önemlidir. Toplamda 40 soru bulunan bu uygulama değerli görüşleriniz doğrultusunda şekillendirilecektir.',
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.montserrat(
                    fontSize: fontsize,
                    color: colorGreenPrimary,
                  ),
                ),
              ),
              SizedBox(height: calculatedHeight(20, context)),
              Text(
                'Başarı dileklerimizle sevgiler sunarız…',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: fontsize + 2,
                  color: colorGreenPrimary,
                ),
              ),
              SizedBox(height: calculatedHeight(50, context)),
              SizedBox(
                width: widthText,
                child: RichText(
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Proje Yürütücüsü: ',
                        style: GoogleFonts.montserrat(
                          color: colorGreenPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Doç. Dr. Meryem Geçimli',
                        style: GoogleFonts.montserrat(
                          color: colorGreenPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: calculatedHeight(10, context)),
              SizedBox(
                width: widthText,
                child: RichText(
                  textAlign: TextAlign.end,
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Araştırmacı: ',
                        style: GoogleFonts.montserrat(
                          color: colorGreenPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Dr. Öğr. Üyesi Kemal Köksal',
                        style: GoogleFonts.montserrat(
                          color: colorGreenPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: calculatedHeight(50, context)),
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 225,
                height: 40,
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignIn()),
                  );
                },
                color: colorGreenPrimary,
                textColor: Colors.white,
                child: SizedBox(
                  width: 225,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Giriş Yap",
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.play_arrow),
                    ],
                  ),
                ),
              ),
              SizedBox(height: calculatedHeight(50, context)),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Image(
                      image: AssetImage("assets/cc.png"),
                      width: 20,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "All Rights Reserved",
                    ),
                  ],
                ),
              ),
              SizedBox(height: calculatedHeight(10, context)),
            ],
          ),
        ),
      ),
    );
  }
}
