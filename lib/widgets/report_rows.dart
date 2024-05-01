import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quesus/constants/dimensions.dart';

import '../constants/colors.dart';
import '../models/report.dart';

class ReportRows extends StatefulWidget {
  final List<Report> reportList;

  const ReportRows({
    Key? key,
    required this.reportList,
  }) : super(key: key);

  @override
  State<ReportRows> createState() => _ReportRowsState();
}

class _ReportRowsState extends State<ReportRows> {
  @override
  Widget build(BuildContext context) {
    Map<String, List<Report>> groupedReports = {};

    for (var report in widget.reportList) {
      if (!groupedReports.containsKey(report.uniqKey)) {
        groupedReports[report.uniqKey!] = [];
      }
      groupedReports[report.uniqKey]?.add(report);
    }

    return ListView.builder(
      itemCount: groupedReports.length,
      itemBuilder: (context, index) {
        var key = groupedReports.keys.toList()[index];
        var reports = groupedReports[key]!;

        var userName = reports.first.userName;
        var totalScore = reports.fold(
            0, (previousValue, report) => previousValue + report.score!);

        return ExpansionTile(
          title: Text(
            '$userName - Toplam Puan: $totalScore',
            style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: colorGreenPrimary),
            maxLines: 1,
            softWrap: true,
            textAlign: TextAlign.left,
          ),
          children: reports.map((report) {
            return ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Soru: ',
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width -
                        calculatedWidth(75, context),
                    child: Text(
                      "${report.question}",
                      style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: colorGreenPrimary),
                      maxLines: 2,
                      softWrap: true,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Verilen Cevap: ',
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${report.choice}',
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: report.score == 1 ? colorGreenLight : colorRed),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(
                    width: calculatedWidth(5, context),
                  ),
                  SizedBox(
                    height: 10,
                    child: VerticalDivider(
                      color: colorGreenPrimary,
                      width: 2,
                    ),
                  ),
                  SizedBox(
                    width: calculatedWidth(5, context),
                  ),
                  Text(
                    'Puan: ',
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.normal,
                        color: Colors.black),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    '${report.score}',
                    style: GoogleFonts.montserrat(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: report.score == 1 ? colorGreenLight : colorRed),
                    maxLines: 1,
                    softWrap: true,
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
