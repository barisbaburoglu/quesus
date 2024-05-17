import 'dart:io';

import 'package:flutter/gestures.dart';
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
  bool value = false;

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

  void showPrivacyDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(builder: (stfContext, stfsetState) {
          return AlertDialog(
            insetPadding: EdgeInsets.symmetric(
              horizontal: calculatedWidth(25, context),
              vertical: calculatedHeight(25, context),
            ),
            backgroundColor: colorBackground,
            contentPadding:
                EdgeInsets.symmetric(horizontal: calculatedWidth(10, context)),
            titlePadding:
                EdgeInsets.symmetric(vertical: calculatedHeight(20, context)),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'KİŞİSEL VERİLERİN İŞLENMESİNE İLİŞKİN AYDINLATMA METNİ',
                  style: GoogleFonts.montserrat(
                    color: colorGreenPrimary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: Divider(
                    color: colorGreenSecondary,
                    height: 2,
                  ),
                ),
              ],
            ),
            content: SizedBox(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(right: calculatedWidth(20, context)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                        "İşbu Aydınlatma Metni, QueSus uygulaması kullanıcılarının 6698 sayılı Kişisel Verilerin Korunması Kanunu kapsamında kişisel verilerinin Uygulama Sahipleri tarafından işlenmesine ilişkin olarak aydınlatılması amacıyla hazırlanmıştır.",
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'a) Kişisel Verilerin Elde Edilme Yöntemleri ve Hukuki Sebepleri',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        "Kişisel verileriniz, elektronik veya fiziki ortamda toplanmaktadır. İşbu Aydınlatma Metni’nde belirtilen hukuki sebeplerle toplanan kişisel verileriniz Kanun’un 5. ve 6. maddelerinde belirtilen kişisel veri işleme şartları çerçevesinde işlenebilmekte ve paylaşılabilmektedir.",
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text('b) Kişisel Verilerin İşleme Amaçları',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Kişisel verileriniz, Kanun’un 5. ve 6. maddelerinde belirtilen kişisel veri işleme şartları çerçevesinde akademik amaçlarla işlenmektedir.',
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'c) Kişisel Verilerin Paylaşılabileceği Taraflar ve Paylaşım Amaçları',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Kişisel verileriniz, Kanun’un 8. ve 9. maddelerinde belirtilen kişisel veri işleme şartları ve amaçları çerçevesinde, Uygulama Sahipleri tarafından sunulan ürün ve hizmetlerin ilgili kişilerin beğeni, kullanım alışkanlıkları ve ihtiyaçlarına göre özelleştirilerek ilgili kişilere önerilmesi ve tanıtılması için gerekli olan aktivitelerin planlanması ve icrası, Uygulama Sahipleri tarafından sunulan ürün ve hizmetlerden ilgili kişileri faydalandırmak için gerekli çalışmaların iş birimleri tarafından yapılması ve ilgili iş süreçlerinin yürütülmesi için ilgili iş birimleri tarafından gerekli çalışmaların yapılması ve buna bağlı iş süreçlerinin yürütülmesi, Uygulama Sahiplerinin akademik stratejilerinin planlanması ve icrası ve Uygulama Sahipleriyle akademik ilişki içerisinde olan ilgili kişilerin hukuki ve teknik güvenliğinin temini amaçları dahilinde Uygulama Sahiplerinin akademik ortakları ile hukuken yetkili kurum ve kuruluşlar ile hukuken yetkili özel hukuk tüzel kişileriyle paylaşılabilecektir.',
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'd) Veri Sahiplerinin Hakları ve Bu Hakların Kullanılması',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Kişisel veri sahipleri olarak aşağıda belirtilen haklarınıza ilişkin taleplerinizi Veri Sahipleri Tarafından Hakların Kullanılması başlığı altında belirtilen yöntemlerle Uygulama Sahiplerine iletmeniz durumunda talepleriniz Uygulama Sahipleri tarafından mümkün olan en kısa sürede ve her halde 30 (otuz) gün içerisinde değerlendirilerek sonuçlandırılacaktır.',
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Kanun’un 11. maddesi uyarınca kişisel veri sahibi olarak aşağıdaki haklara sahipsiniz:',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: calculatedWidth(10, context),
                      ),
                      child: Text(
                          'Kişisel verilerinizin işlenip işlenmediğini öğrenme,\nKişisel verileriniz işlenmişse buna ilişkin bilgi talep etme,\nKişisel verilerinizin işlenme amacını ve bunların amacına uygun kullanılıp kullanılmadığını öğrenme,\nYurt içinde veya yurt dışında kişisel verilerinizin aktarıldığı üçüncü kişileri bilme,\nKişisel verilerinizin eksik veya yanlış işlenmiş olması hâlinde bunların düzeltilmesini isteme ve bu\nkapsamda yapılan işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,\nKanun ve ilgili diğer kanun hükümlerine uygun olarak işlenmiş olmasına rağmen, işlenmesini gerektiren sebeplerin ortadan kalkması hâlinde kişisel verilerinizin silinmesini veya yok edilmesini isteme ve bu kapsamda yapılan işlemin kişisel verilerin aktarıldığı üçüncü kişilere bildirilmesini isteme,\nİşlenen verilerinizin münhasıran otomatik sistemler vasıtasıyla analiz edilmesi suretiyle kişinin kendisi aleyhine bir sonucun ortaya çıkmasına itiraz etme,\nKişisel verilerinizin kanuna aykırı olarak işlenmesi sebebiyle zarara uğraması hâlinde zararın giderilmesini talep etme.\nKanun’un 28. maddesinin 2. fıkrası veri sahiplerinin talep hakkı bulunmayan halleri sıralamış olup bu kapsamda;\nKişisel veri işlemenin suç işlenmesinin önlenmesi veya suç soruşturması için gerekli olması,\nİlgili kişinin kendisi tarafından alenileştirilmiş kişisel verilerin işlenmesi,\nKişisel veri işlemenin kanunun verdiği yetkiye dayanılarak görevli ve yetkili kamu kurum ve kuruluşları ile kamu kurumu niteliğindeki meslek kuruluşlarınca, denetleme veya düzenleme görevlerinin yürütülmesi ile disiplin soruşturma veya kovuşturması için gerekli olması,\nKişisel veri işlemenin bütçe, vergi ve mali konulara ilişkin olarak Devletin ekonomik ve mali çıkarlarının korunması için gerekli olması,\nhallerinde verilere yönelik olarak yukarıda belirlenen haklar kullanılamayacaktır.\nKanun’un 28. maddesinin 1. fıkrasına göre ise aşağıdaki durumlarda veriler Kanun kapsamı dışında olacağından, veri sahiplerinin talepleri bu veriler bakımından da işleme alınmayacaktır:\nKişisel verilerin, üçüncü kişilere verilmemek ve veri güvenliğine ilişkin yükümlülüklere uyulmak kaydıyla gerçek kişiler tarafından tamamen kendisiyle veya aynı konutta yaşayan aile fertleriyle ilgili faaliyetler kapsamında işlenmesi.\nKişisel verilerin resmi istatistik ile anonim hâle getirilmek suretiyle araştırma, planlama ve istatistik gibi amaçlarla işlenmesi.\nKişisel verilerin millî savunmayı, millî güvenliği, kamu güvenliğini, kamu düzenini, ekonomik güvenliği, özel hayatın gizliliğini veya kişilik haklarını ihlal etmemek ya da suç teşkil etmemek kaydıyla, sanat, tarih, edebiyat veya bilimsel amaçlarla ya da ifade özgürlüğü kapsamında işlenmesi.\nKişisel verilerin millî savunmayı, millî güvenliği, kamu güvenliğini, kamu düzenini veya ekonomik güvenliği sağlamaya yönelik olarak kanunla görev ve yetki verilmiş kamu kurum ve kuruluşları tarafından yürütülen önleyici, koruyucu ve istihbari faaliyetler kapsamında işlenmesi.\nKişisel verilerin soruşturma, kovuşturma, yargılama veya infaz işlemlerine ilişkin olarak yargı makamları veya infaz mercileri tarafından işlenmesi.',
                          style: GoogleFonts.montserrat(fontSize: 16),
                          textAlign: TextAlign.justify,
                          textScaleFactor: 1),
                    ),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text('Veri Sahipleri Tarafından Hakların Kullanılması',
                        style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold, fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Başvurular, ilgili veri sahibinin kimliğini tespit edecek belgelerle birlikte, aşağıdaki yöntemlerden biri ile gerçekleştirilecektir:',
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        "Uygulama Sahipleri, Kanun'da öngörülmüş sınırlar çerçevesinde söz konusu hakları kullanmak isteyen veri sahiplerine, yine Kanun’da öngörülen şekilde azami otuz (30) gün içerisinde cevap vermektedir. Kişisel veri sahipleri adına üçüncü kişilerin başvuru talebinde bulunabilmesi için veri sahibi tarafından başvuruda bulunacak kişi adına noter kanalıyla düzenlenmiş özel vekâletname bulunmalıdır.",
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        'Veri sahibi başvuruları kural olarak ücretsiz olarak işleme alınmakla birlikte, Kişisel Verileri Koruma Kurulu tarafından öngörülen ücret tarifesi[1] üzerinden ücretlendirme yapılabilecektir.',
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                    SizedBox(
                      height: calculatedHeight(10, context),
                    ),
                    Text(
                        "Uygulama Sahipleri, başvuruda bulunan kişinin kişisel veri sahibi olup olmadığını tespit etmek adına ilgili kişiden bilgi talep edebilir, başvuruda belirtilen hususları netleştirmek adına, kişisel veri sahibine başvurusu ile ilgili soru yöneltebilir.",
                        style: GoogleFonts.montserrat(fontSize: 16),
                        textAlign: TextAlign.justify,
                        textScaleFactor: 1),
                  ],
                ),
              ),
            ),
            actions: [
              MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minWidth: 225,
                height: 40,
                padding: const EdgeInsets.all(8),
                onPressed: () {
                  setState(() {
                    value = true;
                  });
                  Navigator.pop(context);
                },
                color: colorGreenPrimary,
                textColor: Colors.white,
                child: SizedBox(
                  width: 225,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Okudum ve Onaylıyorum",
                        style:
                            GoogleFonts.montserrat(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.check),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
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
                    style: TextStyle(
                      color: colorGreenPrimary,
                      fontSize: 11.0, // Yazı büyüklüğü
                      fontWeight: FontWeight.bold, // Yazı kalınlığı
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: colorGreenPrimary),
              onPressed: () => Navigator.of(context).pop(),
            ),
            backgroundColor:
                colorAppBar, // Renkleri düzenlemek için varsayılan değerleri kullanabilirsiniz.
            foregroundColor: colorGreenPrimary,
            shadowColor: colorGreenPrimary,
          ),
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
                          "QUESTIONS SUSTAINABILITY",
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
                        if (!_loadingRegister) ...[
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
                          InkWell(
                            onTap: () {
                              showPrivacyDialog(context);
                            },
                            child: SizedBox(
                              width: 310,
                              child: RichText(
                                textAlign: TextAlign.justify,
                                maxLines: 2,
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text:
                                          'Ki̇şi̇sel Veri̇leri̇n İşlenmesi̇ne İli̇şkin Aydınlatma Metni̇ için tıklayınız',
                                      style: GoogleFonts.montserrat(
                                        color: colorGreenPrimary,
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: calculatedHeight(10, context),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                value: value,
                                checkColor: Colors.white,
                                activeColor: colorGreenPrimary,
                                onChanged: (val) {
                                  setState(() {
                                    value = val!;
                                  });
                                },
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    value = !value;
                                  });
                                },
                                child: SizedBox(
                                  width: 280,
                                  child: RichText(
                                    maxLines: 1,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: 'Okudum ve Onaylıyorum.',
                                          style: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            color: colorGreenLight,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
                              } else if (!value) {
                                setState(() {
                                  _loadingRegister = false;
                                });
                                showInfoDialog(
                                    context,
                                    "Lütfen Ki̇şi̇sel Veri̇Leri̇n İşlenmesi̇ne İli̇şki̇n\nAydınlatma Metni̇nini okuyup onaylayınız.",
                                    0);
                              } else {
                                _futureUser = ApiQueSus().login(
                                  User(
                                    userName: userIdController.text,
                                    password: passwordController.text,
                                    checkedPolicy: value ? 1 : 0,
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const SignUp(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = const Offset(0.0, 1.0);
                                    var end = Offset.zero;
                                    var curve = Curves.easeInOutExpo;

                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve));

                                    var offsetAnimation =
                                        animation.drive(tween);

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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(Icons.app_registration),
                                ],
                              ),
                            ),
                          ),
                        ] else ...[
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
