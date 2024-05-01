import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:quesus/models/report.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

//Local imports
import '../constants/dimensions.dart';
import '../helper/save_file_mobile.dart'
    if (dart.library.html) '../helper/save_file_web.dart';

import '../constants/colors.dart';
import '../constants/secret.dart';
import '../helper/api.dart';
import '../widgets/app_bar.dart';
import '../widgets/drawer.dart';
import '../widgets/input_edit.dart';
import '../widgets/report_rows.dart';
import 'signin_page.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({
    super.key,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  late List<Report> reportList;
  late SharedPreferences prefs;
  late bool _loadingUser;
  late bool _loadingUsers;

  TextEditingController searchUserController = TextEditingController();
  TextEditingController searchQuestionController = TextEditingController();

  bool isAdmin = false;
  bool isActive = false;

  final searchUserFocusNode = FocusNode();
  final searchQuestionFocusNode = FocusNode();

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

  void getReport() async {
    reportList = await ApiQueSus()
        .getReport(searchUserController.text, searchQuestionController.text);

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
    var q = getReport();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> generateExcel() async {
    //Create a Excel document.

    //Creating a workbook.
    final Workbook workbook = Workbook();
    //Accessing via index
    final Worksheet sheet = workbook.worksheets[0];
    sheet.showGridlines = false;

    // Enable calculation for worksheet.
    sheet.enableSheetCalculations();

    //Set data in the worksheet.
    sheet.getRangeByName('A1').columnWidth = 10;
    sheet.getRangeByName('B1:C1').columnWidth = 30;
    sheet.getRangeByName('D1').columnWidth = 20;
    sheet.getRangeByName('E1').columnWidth = 10;

    //title begin
    sheet.getRangeByName('A1').text = 'QueSus Rapor';
    sheet.getRangeByName('A1').cellStyle.fontSize = 16;
    sheet.getRangeByName('A1').cellStyle.fontColor = '#F4ECD7';
    sheet.getRangeByName('A1').cellStyle.bold = true;
    final Range rangeTitle = sheet.getRangeByName('A1:E1');
    rangeTitle.cellStyle.backColor = '#0F4F07';
    rangeTitle.merge();
    rangeTitle.cellStyle.hAlign = HAlignType.center;
    rangeTitle.cellStyle.vAlign = VAlignType.center;
    //title end

    sheet.getRangeByName('A2:E2').cellStyle.bold = true;

    sheet.getRangeByIndex(2, 1).setText('Kullanıcı');
    sheet.getRangeByIndex(2, 1).cellStyle.hAlign = HAlignType.center;
    for (var i = 0; i < reportList.length; i++) {
      sheet.getRangeByIndex(3 + i, 1).setText(reportList[i].userName);
    }

    sheet.getRangeByIndex(2, 2).setText('Soru');
    sheet.getRangeByIndex(2, 2, 2, 3).merge();
    sheet.getRangeByIndex(2, 2).cellStyle.hAlign = HAlignType.center;
    for (var i = 0; i < reportList.length; i++) {
      sheet.getRangeByIndex(3 + i, 2, 3 + i, 3).merge();
      sheet.getRangeByIndex(3 + i, 2).setText(reportList[i].question);
    }

    sheet.getRangeByIndex(2, 4).setText('Cevap');
    sheet.getRangeByIndex(2, 4).cellStyle.hAlign = HAlignType.center;
    for (var i = 0; i < reportList.length; i++) {
      sheet.getRangeByIndex(3 + i, 4).cellStyle.hAlign = HAlignType.center;
      sheet.getRangeByIndex(3 + i, 4).setText(reportList[i].choice);
    }

    sheet.getRangeByIndex(2, 5).setText('Puan');
    sheet.getRangeByIndex(2, 5).cellStyle.hAlign = HAlignType.center;
    for (var i = 0; i < reportList.length; i++) {
      sheet.getRangeByIndex(3 + i, 5).cellStyle.hAlign = HAlignType.center;
      sheet
          .getRangeByIndex(3 + i, 5)
          .setNumber(reportList[i].score!.toDouble());
      sheet.getRangeByIndex(3 + i, 5).cellStyle.fontColor =
          reportList[i].score! == 1 ? '#8ABA52' : '#e28086';
      sheet.getRangeByIndex(3 + i, 5).cellStyle.bold = true;
    }

    //sheet.getRangeByIndex(15, 6, 20, 7).numberFormat = r'$#,##0.00';
    // Score -1 olan ve 1 olan rapor sayılarını hesapla
    int scoreFalseCount =
        reportList.where((report) => report.score == -1).length;
    int scoreTrueCount = reportList.where((report) => report.score == 1).length;

    sheet.getRangeByName('B${3 + reportList.length}').setText('TOPLAM DOĞRU');
    sheet.getRangeByName('B${3 + reportList.length}').cellStyle.fontSize = 8;
    sheet.getRangeByName('B${3 + reportList.length}').cellStyle.hAlign =
        HAlignType.center;
    sheet
        .getRangeByName('B${3 + reportList.length + 1}')
        .setNumber(scoreTrueCount.toDouble());
    sheet.getRangeByName('B${3 + reportList.length + 1}').cellStyle.fontSize =
        14;
    sheet.getRangeByName('B${3 + reportList.length + 1}').cellStyle.hAlign =
        HAlignType.center;
    sheet.getRangeByName('B${3 + reportList.length + 1}').cellStyle.bold = true;
    sheet.getRangeByName('C${3 + reportList.length}').setText('TOPLAM YANLIŞ');
    sheet.getRangeByName('C${3 + reportList.length}').cellStyle.fontSize = 8;
    sheet.getRangeByName('C${3 + reportList.length}').cellStyle.hAlign =
        HAlignType.center;
    sheet
        .getRangeByName('C${3 + reportList.length + 1}')
        .setNumber(scoreFalseCount.toDouble());
    sheet.getRangeByName('C${3 + reportList.length + 1}').cellStyle.fontSize =
        14;
    sheet.getRangeByName('C${3 + reportList.length + 1}').cellStyle.hAlign =
        HAlignType.center;
    sheet.getRangeByName('C${3 + reportList.length + 1}').cellStyle.bold = true;

    final Range range6 = sheet.getRangeByName(
        'A${3 + reportList.length}:E${3 + reportList.length + 1}');
    range6.cellStyle.backColor = '#F4ECD7';
    final Range range7 = sheet.getRangeByName('E${3 + reportList.length}');
    final Range range8 = sheet.getRangeByName('E${3 + reportList.length + 1}');
    range7.setText('TOPLAM PUAN');
    range7.cellStyle.fontSize = 8;
    range8.cellStyle.hAlign = HAlignType.center;
    range8.setFormula('=SUM(E3:E${3 + (reportList.length - 1)})');
    range8.cellStyle.fontSize = 14;
    range8.cellStyle.hAlign = HAlignType.center;
    range8.cellStyle.bold = true;

    //footer begin
    sheet.getRangeByIndex(3 + reportList.length + 2, 1).text = 'QueSus';
    sheet.getRangeByIndex(3 + reportList.length + 2, 1).cellStyle.fontSize = 12;

    final Range range9 = sheet.getRangeByName(
        'A${3 + reportList.length + 2}:E${3 + reportList.length + 3}');
    range9.cellStyle.fontColor = '#F4ECD7';
    range9.cellStyle.backColor = '#0F4F07';
    range9.merge();
    range9.cellStyle.hAlign = HAlignType.center;
    range9.cellStyle.vAlign = VAlignType.center;
    //footer end

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();

    //Save and launch the file.
    await saveAndLaunchFile(bytes,
        'QueSus_Report_${DateFormat('yyyyMMdd_HHmm').format(DateTime.now())}.xlsx');
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
                child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          20, 5, calculatedWidth(10, context), 5),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rapor",
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
                              side: BorderSide(
                                color: colorGreenPrimary,
                                width: 1,
                              ),
                            ),
                            minWidth: 150,
                            height: 40,
                            padding: const EdgeInsets.all(8),
                            onPressed: generateExcel,
                            color: Colors.white,
                            textColor: colorGreenPrimary,
                            child: SizedBox(
                              width: 150,
                              child: Flex(
                                mainAxisAlignment: MainAxisAlignment.center,
                                direction: Axis.horizontal,
                                children: const [
                                  Text(
                                    "Excel indir",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(width: 5),
                                  Icon(FontAwesomeIcons.fileExcel),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          10, 5, calculatedWidth(10, context), 5),
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: calculatedWidth(175, context),
                            child: InputEdit(
                              focusNode: searchUserFocusNode,
                              controller: searchUserController,
                              text: 'Kullanıcı Filtrele',
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              onChanged: (p0) {
                                setState(() {
                                  _loadingUsers = true;
                                });
                                getReport();
                              },
                            ),
                          ),
                          SizedBox(
                            width: calculatedWidth(175, context),
                            child: InputEdit(
                              focusNode: searchQuestionFocusNode,
                              controller: searchQuestionController,
                              text: 'Soru Filtrele',
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              inputFormatters: [],
                              onChanged: (p0) {
                                setState(() {
                                  _loadingUsers = true;
                                });
                                getReport();
                              },
                            ),
                          ),
                        ],
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
                              padding: const EdgeInsets.only(
                                  left: 10, top: 5, bottom: 5),
                              child: ReportRows(
                                reportList: reportList,
                              ),

                              // ListView.builder(
                              //   padding: EdgeInsets.only(
                              //     right: calculatedWidth(10, context),
                              //   ),
                              //   itemCount: reportList.length,
                              //   itemBuilder: (context, index) {
                              //     return
                              //     ReportTile(
                              //       index: index,
                              //       reportRow: reportList[index],
                              //       onPressed: () async {},
                              //     );
                              //   },
                              // ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          );
  }
}
