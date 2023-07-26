import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/util/util.dart';

abstract class AssessmentResultsRepo {
  Future<List<AssessmentResults>> addAssessmentResults(
      List<AssessmentResults> assessmentResults, NewAssessment newAssessment);

  Future<List<AssessmentResults>> getAllAssessmentResults();

  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate);

  Future<List<AssessmentResults>> getAssessmentResultsByCurrentUserNotConfirm();

  Future<List<AssessmentResults>> getAssessmentResultsNotConfirmByCPTS();

  Future<List<AssessmentVariableResults>> getAssessmentVariableResult(String idAssessment);

  Future<void> updateAssessmentResultForExaminee(AssessmentResults assessmentResults);

  Future<List<AssessmentResults>> searchAssessmentResultsBasedOnName(String searchName, int searchLimit);

  Future<List<AssessmentResults>> getAllAssessmentResultsPaginated(
      int limit, AssessmentResults? lastAssessment, DateTime? filterStart, DateTime? filterEnd);

  Future<String> makePDFSimulator(AssessmentResults assessmentResults);
}

class AssessmentResultsRepoImpl implements AssessmentResultsRepo {
  AssessmentResultsRepoImpl({FirebaseFirestore? db, UserPreferences? userPreferences})
      : _db = db ?? FirebaseFirestore.instance,
        _userPreferences = userPreferences;

  final FirebaseFirestore? _db;
  final UserPreferences? _userPreferences;

  @override
  Future<List<AssessmentResults>> addAssessmentResults(
      List<AssessmentResults> assessmentResults, NewAssessment newAssessment) async {
    List<AssessmentResults> assessmentResultsList = AssessmentResults.extractDataFromNewAssessment(newAssessment);
    try {
      for (var assessmentResult in assessmentResultsList) {
        assessmentResult.id =
            "assessment-result-${assessmentResult.examinerStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
        await _db!
            .collection(AssessmentResults.firebaseCollection)
            .doc(assessmentResult.id)
            .set(assessmentResult.toFirebase());

        for (var assessmentVariableResult in assessmentResult.variableResults) {
          assessmentVariableResult.id =
              "assessment-variable-result-${assessmentVariableResult.assessmentVariableId}-${assessmentResult.examinerStaffIDNo}-${Util.convertDateTimeDisplay(assessmentResult.date.toString())}";
          assessmentVariableResult.assessmentResultsId = assessmentResult.id;
          await _db!
              .collection(AssessmentVariableResults.firebaseCollection)
              .doc(assessmentVariableResult.id)
              .set(assessmentVariableResult.toFirebase());
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return assessmentResultsList;
  }

  @override
  Future<List<AssessmentResults>> getAllAssessmentResults() async {
    List<AssessmentResults> assessmentResultsList = [];
    try {
      QuerySnapshot querySnapshot = await _db!.collection(AssessmentResults.firebaseCollection).get();

      for (var doc in querySnapshot.docs) {
        AssessmentResults assessmentResults = AssessmentResults.fromFirebase(doc.data() as Map<String, dynamic>);
        QuerySnapshot querySnapshot2 = await _db!
            .collection(AssessmentVariableResults.firebaseCollection)
            .where(AssessmentVariableResults.keyAssessmentResultsId, isEqualTo: assessmentResults.id)
            .get();
        for (var doc2 in querySnapshot2.docs) {
          AssessmentVariableResults assessmentVariableResults =
              AssessmentVariableResults.fromFirebase(doc2.data() as Map<String, dynamic>);
          assessmentResults.variableResults.add(assessmentVariableResults);
        }
        assessmentResultsList.add(assessmentResults);
      }
    } catch (e) {
      print(e.toString());
    }
    return assessmentResultsList;
  }

  @override
  Future<List<AssessmentResults>> getAssessmentResultsFilteredByDate(DateTime startDate, DateTime endDate) async {
    List<AssessmentResults> assessmentResultsList = [];
    try {
      QuerySnapshot querySnapshot = await _db!
          .collection(AssessmentResults.firebaseCollection)
          .where(AssessmentResults.keyDate, isGreaterThanOrEqualTo: startDate)
          .where(AssessmentResults.keyDate, isLessThanOrEqualTo: endDate)
          .get();

      for (var doc in querySnapshot.docs) {
        AssessmentResults assessmentResults = AssessmentResults.fromFirebase(doc.data() as Map<String, dynamic>);
        QuerySnapshot querySnapshot2 = await _db!
            .collection(AssessmentVariableResults.firebaseCollection)
            .where(AssessmentVariableResults.keyAssessmentResultsId, isEqualTo: assessmentResults.id)
            .get();
        for (var doc2 in querySnapshot2.docs) {
          AssessmentVariableResults assessmentVariableResults =
              AssessmentVariableResults.fromFirebase(doc2.data() as Map<String, dynamic>);
          assessmentResults.variableResults.add(assessmentVariableResults);
        }
        assessmentResultsList.add(assessmentResults);
      }
    } catch (e) {
      print(e.toString());
    }
    return assessmentResultsList;
  }

  @override
  Future<List<AssessmentResults>> getAssessmentResultsByCurrentUserNotConfirm() async {
    final userPreferences = _userPreferences;
    final userId = userPreferences!.getIDNo();
    int dummyUserId = 1029620;
    List<AssessmentResults> assessmentResults = [];

    try {
      await _db!
          .collection(AssessmentResults.firebaseCollection)
          .where(AssessmentResults.keyExaminerStaffIDNo, isEqualTo: userId)
          .where(AssessmentResults.keyConfirmedByInstructor, isEqualTo: true)
          .where(AssessmentResults.keyConfirmedByExaminer, isEqualTo: false)
          .get()
          .then((value) {
        for (var element in value.docs) {
          assessmentResults.add(AssessmentResults.fromFirebase(element.data()));
        }
      });
    } catch (e) {
      log("Exception in AssessmentResultRepo on getAssessmentResultsByCurrentUserNotConfirm: $e");
    }
    return assessmentResults;
  }

  @override
  Future<List<AssessmentResults>> getAssessmentResultsNotConfirmByCPTS() async {
    List<AssessmentResults> assessmentResults = [];

    try {
      await _db!
          .collection(AssessmentResults.firebaseCollection)
          // .where(AssessmentResults.keyConfirmedByExaminer, isEqualTo: true)
          .where(AssessmentResults.keyConfirmedByInstructor, isEqualTo: true)
          .where(AssessmentResults.keyConfirmedByCPTS, isEqualTo: false)
          .get()
          .then((value) {
        for (var element in value.docs) {
          assessmentResults.add(AssessmentResults.fromFirebase(element.data()));
        }
      });
    } catch (e) {
      log("Exception in AssessmentResultRepo on getAssessmentResultsNotConfirmByCPTS: $e");
    }

    return assessmentResults;
  }

  int assessmentVariableCollectionComparator(DocumentSnapshot a, DocumentSnapshot b) {
    final idA = int.tryParse(a.id.split('-')[4]); // Extract the numerical part from the ID of document A
    final idB = int.tryParse(b.id.split('-')[4]); // Extract the numerical part from the ID of document B

    if (idA != null && idB != null) {
      return idA.compareTo(idB);
    }
    return 0;
  }

  @override
  Future<List<AssessmentVariableResults>> getAssessmentVariableResult(String idAssessment) async {
    List<AssessmentVariableResults> assessmentVariableResults = [];

    try {
      final documents = await _db!
          .collection(AssessmentVariableResults.firebaseCollection)
          .where(AssessmentVariableResults.keyAssessmentResultsId, isEqualTo: idAssessment)
          .get()
          .then((value) {
        return value.docs;
      });

      documents.sort(assessmentVariableCollectionComparator);

      for (var element in documents) {
        assessmentVariableResults.add(AssessmentVariableResults.fromFirebase(element.data()));
      }
    } catch (e) {
      log("Exception in AssessmentResultRepo on getAssessmentVariableResult: $e");
    }

    return assessmentVariableResults;
  }

  @override
  Future<void> updateAssessmentResultForExaminee(AssessmentResults assessmentResults) async {
    try {
      await _db!
          .collection(AssessmentResults.firebaseCollection)
          .doc(assessmentResults.id)
          .update(assessmentResults.toFirebase());
    } catch (e) {
      log("Exception in AssessmentResultRepo on updateAssessmentResultForExaminee: $e");
    }
  }

  @override
  Future<List<AssessmentResults>> searchAssessmentResultsBasedOnName(String searchName, int searchLimit) async {
    List<AssessmentResults> assessmentResultsList = [];

    try {
      log("KAMU SEARCH NAME: $searchName");
      Query query = _db!
          .collection(AssessmentResults.firebaseCollection)
          .orderBy(AssessmentResults.keyNameExaminee)
          .limit(searchLimit)
          .startAt([searchName]).endAt(['$searchName\uf8ff']);

      final assessmentData = await query.get();

      assessmentResultsList =
          assessmentData.docs.map((e) => AssessmentResults.fromFirebase(e.data() as Map<String, dynamic>)).toList();

      log("JUMLAH SEARCH ${assessmentResultsList.length}");
    } catch (e) {
      log("Exception in AssessmentResultRepo on searchAssessmentResultsBasedOnName: $e");
    }

    return assessmentResultsList;
  }

  @override
  Future<List<AssessmentResults>> getAllAssessmentResultsPaginated(
      int limit, AssessmentResults? lastAssessment, DateTime? filterStart, DateTime? filterEnd) async {
    List<AssessmentResults> assessmentResultsList = [];

    try {
      Query query;
      log("BRAPa jln ${filterStart.toString()} ${filterEnd.toString()}");
      if (filterStart != null && filterEnd != null) {
        query = _db!
            .collection(AssessmentResults.firebaseCollection)
            .where('date', isGreaterThanOrEqualTo: filterStart)
            .where('date', isLessThanOrEqualTo: filterEnd)
            .orderBy(AssessmentResults.keyDate, descending: true)
            .limit(limit);
      } else {
        query = _db!
            .collection(AssessmentResults.firebaseCollection)
            .orderBy(AssessmentResults.keyDate, descending: true)
            .limit(limit);
      }

      if (lastAssessment != null) {
        final lastDocumentAssessment =
            await _db!.collection(AssessmentResults.firebaseCollection).doc(lastAssessment.id).get();

        query = query.startAfterDocument(lastDocumentAssessment);
      }

      final assessmentData = await query.get();
      log("BRAPa ${assessmentData.docs.length}");
      // assessmentResultsList = assessmentData.docs
      //   .map((e) => AssessmentResults.fromFirebase(e.data() as Map<String, dynamic>))
      //   .toList();

      for (var element in assessmentData.docs) {
        assessmentResultsList.add(AssessmentResults.fromFirebase(element.data() as Map<String, dynamic>));
      }
    } catch (e) {
      log("Exception in AssessmentResultRepo on getAllAssessmentResultsPaginated: $e");
    }

    return assessmentResultsList;
  }

  @override
  Future<String> makePDFSimulator(AssessmentResults assessmentResults) async {
    List<String> listOfTrainingCheckingDetails = assessmentResults.trainingCheckingDetails;
    String flightDetails = assessmentResults.sessionDetails;

    try {
      // get temporary directory path
      Directory? tempDir = await getExternalStorageDirectory();

      // Load the existing PDF document.
      final PdfDocument document =
          PdfDocument(inputBytes: File('${tempDir?.path}/QZ_TS1_SIM_04JUL2020_rev02.pdf').readAsBytesSync());

      // ============================= FOR CANDIDATE DETAIL ================================================

      List<String> pdfCandidateDetail = [
        "Other Crew Member Rank & Name.",
        "Rank & Name.",
        "License No.",
        "License Expiry",
        "Staff No.",
        "SIM ident.",
        "Aircraft Type.",
        "Airport & Route.",
        "Sim Hours"
      ];

      // For name
      List<MatchedItem> candidateDetailCollection = PdfTextExtractor(document).findText(pdfCandidateDetail);
      bool sameName = false;
      for (var matched in candidateDetailCollection) {
        Rect textbounds = matched.bounds;

        switch (matched.text) {
          case "Other Crew Member Rank & Name.":
            document.pages[0].graphics.drawString(
              "${assessmentResults.examineeRank}. ${assessmentResults.otherStaffIDNo}",
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "Rank & Name.":
            if (!sameName) {
              document.pages[0].graphics.drawString(
                "${assessmentResults.examineeRank}. ${assessmentResults.examineeName}",
                PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
                brush: PdfBrushes.black,
                bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 300, 50),
              );
              sameName = true;
            }
            break;

          case "License No.":
            document.pages[0].graphics.drawString(
              assessmentResults.examinerStaffIDNo.toString(),
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "License Expiry":
            document.pages[0].graphics.drawString(
              Util.convertDateTimeDisplay(assessmentResults.licenseExpiry.toString()),
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "Staff No.":
            document.pages[0].graphics.drawString(
              assessmentResults.examinerStaffIDNo.toString(),
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "SIM ident.":
            document.pages[0].graphics.drawString(
              assessmentResults.simIdent == "" ? "-" : assessmentResults.simIdent.toString(),
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "Aircraft Type.":
            document.pages[0].graphics.drawString(
              assessmentResults.aircraftType,
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "Airport & Route.":
            document.pages[0].graphics.drawString(
              assessmentResults.airportAndRoute,
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;

          case "Sim Hours":
            document.pages[0].graphics.drawString(
              assessmentResults.simulationHours,
              PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              brush: PdfBrushes.black,
              bounds: Rect.fromLTWH(textbounds.topLeft.dx, textbounds.topLeft.dy + 8, 100, 50),
            );
            break;
        }
      }

      // ====================================== FOR TRAINING / CHECKING DETAILS ======================================

      //Find the text and get matched items.
      List<MatchedItem> listOfTrainingCheckingDetailsMatchedItemCollection =
          PdfTextExtractor(document).findText(listOfTrainingCheckingDetails);

      // Get the matched item in the collection using index.
      // MatchedItem matchedText = listOfTrainingCheckingDetailsMatchedItemCollection[0];

      // Loop for listOfTrainingCheckingDetailsMatchedItemCollection
      for (var matched in listOfTrainingCheckingDetailsMatchedItemCollection) {
        MatchedItem text = matched;
        Rect textBounds = text.bounds;

        // Draw pages 1 on Training / Checking Details
        document.pages[0].graphics.drawString(
            flightDetails.substring(0, 1), PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
            brush: PdfBrushes.black,
            bounds: Rect.fromLTWH(textBounds.topLeft.dx - 14, textBounds.topLeft.dy - 2, 100, 50));
      }

      // ====================================== FOR ASSESSMENT VARIABLES ==============================================
      List<AssessmentVariableResults> assessmentVariableResults = assessmentResults.variableResults;

      List<String> titleVariableResults = assessmentVariableResults.map((e) => e.assessmentVariableName.trim()).toList();

      //Find the text and get matched items.
      List<MatchedItem> flightAssessmentMatchedItemCollection = PdfTextExtractor(document).findText(titleVariableResults);

      for (var matchedVariable in flightAssessmentMatchedItemCollection) {
        MatchedItem text = matchedVariable;
        Rect textBounds = text.bounds;
        // log("KAMU ${matchedVariable.text}");
        log("saaya ${assessmentVariableResults[1].assessmentVariableName} dan ${matchedVariable.text}");

        for (var assessment in assessmentVariableResults) {

          if (assessment.assessmentVariableName.trim().toLowerCase() == matchedVariable.text.trim().toLowerCase()) {

            if (!assessment.isNotApplicable) {

              if (assessment.assessmentSatisfactory == "Satisfactory") {
                document.pages[0].graphics.drawString(
                    "S",
                    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(textBounds.topLeft.dx + 70, textBounds.topLeft.dy - 2, 100, 50));
              } else {
                document.pages[0].graphics.drawString(
                    "U",
                    PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
                    brush: PdfBrushes.black,
                    bounds: Rect.fromLTWH(textBounds.topLeft.dx + 60, textBounds.topLeft.dy - 2, 100, 50));
              }

            } else {
              // document.pages[0].graphics.drawString(
              //     "N/A",
              //     PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
              //     brush: PdfBrushes.black,
              //     bounds: Rect.fromLTWH(textBounds.topLeft.dx + 60, textBounds.topLeft.dy - 2, 100, 50));
            }



            // switch (assessment)

            // if (assessment.)
            document.pages[0].graphics.drawString(
                "v",
                PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold),
                brush: PdfBrushes.black,
                bounds: Rect.fromLTWH(textBounds.topLeft.dx + 14, textBounds.topLeft.dy - 2, 100, 50));
          }
        }
      }



      // Save and dispose the document.
      String pathSavePDF =
          "${tempDir?.path}/${assessmentResults.examineeName}-${Util.convertDateTimeDisplay(assessmentResults.date.toString())}.pdf";

      File(pathSavePDF).writeAsBytesSync(await document.save());

      document.dispose();

      return pathSavePDF;
    } catch (e) {
      log("Exception in AssessmentResultRepo on makePDFSimulator: $e");
    }
    return "Failed";
  }
}
