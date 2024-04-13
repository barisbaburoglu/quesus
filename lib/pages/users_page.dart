import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/helper/api.dart';
import 'package:quesus/models/bank.dart';
import 'package:quesus/models/option.dart';
import 'package:quesus/pages/signin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../constants/secret.dart';
import '../models/question.dart';
import '../models/user.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/input_edit.dart';
import '../widgets/question_tile.dart';
import '../widgets/user_tile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({
    super.key,
  });

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> with TickerProviderStateMixin {
  late List<User> userList;
  late SharedPreferences prefs;
  late bool _loadingUser;
  late bool _loadingUsers;

  TextEditingController searchController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isAdmin = false;
  bool isActive = false;

  final questionFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();
  final searchFocusNode = FocusNode();

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

  void getUsers() async {
    userList = await ApiQueSus().getUsers(searchController.text);

    setState(() {
      _loadingUsers = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadingUser = true;
    _loadingUsers = true;

    var checkUser = getUser();
    var q = getUsers();
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
    return _loadingUser
        ? Center(
            child: CircularProgressIndicator(
              color: colorGreenPrimary,
            ),
          )
        : Scaffold(
            backgroundColor: colorBackground,
            appBar: const QueSusAppBar(),
            drawer: const QueSusDrawer(),
            body: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: calculatedHeight(25, context),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Kullanıcılar",
                            style: GoogleFonts.montserrat(
                              color: colorGreenPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          MaterialButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            minWidth: 100,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            onPressed: () async {
                              TextEditingController userNameController =
                                  TextEditingController();

                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return AlertDialog(
                                      backgroundColor: colorBackground,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 20),
                                      titlePadding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Yeni Kullanıcı Tanımlama',
                                            style: GoogleFonts.montserrat(
                                              color: colorGreenPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
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
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: calculatedWidth(
                                                    250, context),
                                                height: calculatedHeight(
                                                    650, context),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    padding: EdgeInsets.only(
                                                      right: calculatedWidth(
                                                          10, context),
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        InputEdit(
                                                          focusNode:
                                                              questionFocusNode,
                                                          controller:
                                                              userNameController,
                                                          text: 'Kullanıcı',
                                                          maxLines: 2,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: [],
                                                        ),
                                                        InputEdit(
                                                          focusNode:
                                                              passwordFocusNode,
                                                          controller:
                                                              passwordController,
                                                          text: 'Şifre',
                                                          maxLines: 2,
                                                          textInputType:
                                                              TextInputType
                                                                  .text,
                                                          inputFormatters: [],
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Checkbox(
                                                                value: isAdmin,
                                                                checkColor:
                                                                    colorGreenPrimary,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    isAdmin =
                                                                        value!;
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                "Yönetici",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color:
                                                                      colorGreenPrimary,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20,
                                                                  vertical: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Checkbox(
                                                                value: isActive,
                                                                checkColor:
                                                                    colorGreenPrimary,
                                                                onChanged:
                                                                    (bool?
                                                                        value) {
                                                                  setState(() {
                                                                    isActive =
                                                                        value!;
                                                                  });
                                                                },
                                                              ),
                                                              Text(
                                                                "Aktif",
                                                                style: GoogleFonts
                                                                    .montserrat(
                                                                  color:
                                                                      colorGreenPrimary,
                                                                  fontSize: 14,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        MaterialButton(
                                          color: colorRed,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Vazgeç'),
                                        ),
                                        MaterialButton(
                                          color: colorGreenPrimary,
                                          textColor: Colors.white,
                                          onPressed: () async {
                                            if (userNameController
                                                    .text.isEmpty ||
                                                passwordController
                                                    .text.isEmpty) {
                                              showInfoDialog(
                                                  context,
                                                  "Lütfen tüm alanları eksiksiz doldurunuz!",
                                                  0);
                                            } else {
                                              User userNew = User();
                                              userNew.userName =
                                                  userNameController.text;
                                              userNew.password =
                                                  passwordController.text;
                                              userNew.isAdmin = isAdmin ? 1 : 0;
                                              userNew.isActive =
                                                  isActive ? 1 : 0;

                                              var s = await ApiQueSus()
                                                  .createUser(userNew)
                                                  .then(
                                                (value) {
                                                  setState(() {
                                                    _loadingUsers = true;
                                                  });
                                                  getUsers();
                                                  Navigator.pop(context);
                                                },
                                              );
                                            }
                                          },
                                          child: const Text('Kaydet'),
                                        ),
                                      ],
                                    );
                                  });
                                },
                              );
                            },
                            color: Colors.white,
                            textColor: colorGreenPrimary,
                            child: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(
                                    FontAwesomeIcons.plus,
                                    size: 15,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    "Yeni",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: InputEdit(
                        focusNode: searchFocusNode,
                        controller: searchController,
                        text: 'Kullanıcı Ara',
                        maxLines: 1,
                        textInputType: TextInputType.text,
                        inputFormatters: [],
                        onChanged: (p0) {
                          setState(() {
                            _loadingUsers = true;
                          });
                          getUsers();
                        },
                      ),
                    ),
                    _loadingUsers
                        ? Center(
                            child: CircularProgressIndicator(
                              color: colorGreenPrimary,
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 10),
                              child: ListView.builder(
                                padding: EdgeInsets.only(
                                  right: calculatedWidth(10, context),
                                ),
                                itemCount: userList.length,
                                itemBuilder: (context, index) {
                                  return UserTile(
                                    index: index,
                                    user: userList[index],
                                    getUser: getUsers,
                                    onPressed: () async {
                                      var s = await ApiQueSus()
                                          .deleteUser(userList[index])
                                          .then((value) {
                                        setState(() {
                                          _loadingUsers = true;
                                        });
                                        getUsers();
                                        Navigator.pop(context);
                                      });
                                    },
                                  );
                                },
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
