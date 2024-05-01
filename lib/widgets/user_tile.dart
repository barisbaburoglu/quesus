import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/models/user.dart';
import 'package:quesus/widgets/input_edit.dart';

import '../constants/colors.dart';
import '../constants/dimensions.dart';
import '../helper/api.dart';
import '../models/question.dart';
import 'input_right_label.dart';

class UserTile extends StatefulWidget {
  final int index;
  final User user;
  final Function() getUser;
  final Function()? onPressed;

  const UserTile({
    Key? key,
    required this.user,
    required this.index,
    required this.getUser,
    required this.onPressed,
  }) : super(key: key);

  @override
  _UserTileState createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final questionFocusNode = FocusNode();
  final passwordFocusNode = FocusNode();

  bool isAdmin = false;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    userNameController.text = widget.user.userName!;
    passwordController.text = "";

    isAdmin = widget.user.isAdmin! == 1;
    isActive = widget.user.isActive! == 1;
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
    return Card(
      color: widget.user.isActive == 1 ? Colors.white : colorRed,
      elevation: 2,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: calculatedHeight(80, context),
              width: 25,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "${widget.index + 1}",
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: widget.user.isActive == 1
                        ? colorGreenPrimary
                        : Colors.white,
                  ),
                  maxLines: 1,
                  softWrap: true,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: 20,
              child: VerticalDivider(
                color: widget.user.isActive == 1
                    ? colorGreenPrimary
                    : Colors.white,
                width: 2,
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
              height: calculatedHeight(80, context),
              width: calculatedWidth(150, context),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  userNameController.text,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: widget.user.isActive == 1
                        ? colorGreenPrimary
                        : Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            if (widget.user.isAdmin == 1) ...[
              SizedBox(
                height: 20,
                child: VerticalDivider(
                  color: widget.user.isActive == 1
                      ? colorGreenPrimary
                      : Colors.white,
                  width: 2,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                height: calculatedHeight(80, context),
                width: calculatedWidth(60, context),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Yönetici",
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.user.isActive == 1
                          ? colorGreenPrimary
                          : Colors.white,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ],
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              backgroundColor: colorBackground,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              titlePadding:
                                  const EdgeInsets.symmetric(vertical: 10),
                              title: const Icon(
                                FontAwesomeIcons.triangleExclamation,
                                color: Colors.deepOrange,
                                size: 40,
                              ),
                              content: Text(
                                "Silmek istediğinize emin misiniz?",
                                style: GoogleFonts.montserrat(
                                  color: colorGreenPrimary,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
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
                                  onPressed: widget.onPressed,
                                  child: const Text('Evet, Sil'),
                                ),
                              ],
                            );
                          });
                        },
                      );
                    },
                    child: Icon(
                      FontAwesomeIcons.trashCan,
                      color:
                          widget.user.isActive == 1 ? colorRed : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) {
              return StatefulBuilder(builder: (context, setState) {
                return AlertDialog(
                  backgroundColor: colorBackground,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  titlePadding: const EdgeInsets.symmetric(vertical: 10),
                  title: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Kullanıcı Düzenleme',
                        style: GoogleFonts.montserrat(
                            color: colorGreenPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
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
                    ],
                  ),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: calculatedWidth(250, context),
                            height: calculatedHeight(650, context),
                            child: Center(
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(
                                  right: calculatedWidth(10, context),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InputEdit(
                                      focusNode: questionFocusNode,
                                      controller: userNameController,
                                      text: 'Kullanıcı',
                                      maxLines: 1,
                                      textInputType: TextInputType.text,
                                      inputFormatters: [],
                                    ),
                                    InputEdit(
                                      focusNode: passwordFocusNode,
                                      controller: passwordController,
                                      text: 'Şifre',
                                      maxLines: 1,
                                      textInputType: TextInputType.text,
                                      inputFormatters: [],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isAdmin,
                                            checkColor: colorGreenPrimary,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isAdmin = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Yönetici",
                                            style: GoogleFonts.montserrat(
                                              color: colorGreenPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Checkbox(
                                            value: isActive,
                                            checkColor: colorGreenPrimary,
                                            onChanged: (bool? value) {
                                              setState(() {
                                                isActive = value!;
                                              });
                                            },
                                          ),
                                          Text(
                                            "Aktif",
                                            style: GoogleFonts.montserrat(
                                              color: colorGreenPrimary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
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
                        if (userNameController.text.isEmpty) {
                          showInfoDialog(
                              context,
                              "Lütfen gerekli alanları eksiksiz doldurunuz!",
                              0);
                        } else {
                          User userUpdate = User();
                          userUpdate = widget.user;
                          userUpdate.userName = userNameController.text;
                          if (passwordController.text.isNotEmpty) {
                            userUpdate.password = ApiQueSus()
                                .encryptData(passwordController.text)
                                .toString();
                          }

                          userUpdate.isAdmin = isAdmin ? 1 : 0;
                          userUpdate.isActive = isActive ? 1 : 0;

                          var s = await ApiQueSus().updateUser(userUpdate).then(
                            (value) {
                              widget.getUser();
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                      child: const Text('Güncelle'),
                    ),
                  ],
                );
              });
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    userNameController.dispose();

    super.dispose();
  }
}
