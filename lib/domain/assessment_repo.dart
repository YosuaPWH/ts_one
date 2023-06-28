import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';

abstract class AssessmentRepo {
  // assessment period
  Future<List<AssessmentPeriod>> getAllAssessmentPeriods();
  Future<AssessmentPeriod> getAssessmentPeriodById(String id);
  Future<AssessmentPeriod> addAssessmentPeriod(
      AssessmentPeriod assessmentPeriodModel);
  Future<AssessmentPeriod> updateAssessmentPeriod(
      AssessmentPeriod assessmentPeriodModel);
  Future<void> deleteAssessmentPeriod(String id);

  // assessment variables
  Future<List<AssessmentVariables>> getAllAssessmentVariables(
      String assessmentPeriodId);
  Future<AssessmentVariables> addAssessmentVariable(
      AssessmentVariables assessmentVariablesModel);
  Future<AssessmentVariables> updateAssessmentVariable(
      AssessmentVariables assessmentVariablesModel);
  Future<void> deleteAssessmentVariable(String id);

  // assessment flight details
  Future<AssessmentFlightDetails> getAllAssessmentFlightDetails();
  Future<AssessmentFlightDetails> addAssessmentFlightDetails(
      AssessmentFlightDetails assessmentFlightDetailsModel);
  Future<AssessmentFlightDetails> updateAssessmentFlightDetails(
      AssessmentFlightDetails assessmentFlightDetailsModel);
  Future<void> deleteAssessmentFlightDetails(String nameFlightDetails);
}

class AssessmentRepoImpl implements AssessmentRepo {
  AssessmentRepoImpl({
    FirebaseFirestore? db,
  }) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore? _db;

  // assessment period
  @override
  Future<List<AssessmentPeriod>> getAllAssessmentPeriods() async {
    List<AssessmentPeriod> assessmentPeriods = [];
    List<AssessmentVariables> assessmentVariables = [];

    try {
      // get all assessment periods by sorting from the latest "period" to the oldest
      assessmentPeriods = await _db!
          .collection(AssessmentPeriod.firebaseCollection)
          .orderBy(AssessmentPeriod.keyPeriod, descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          assessmentPeriods.add(AssessmentPeriod.fromFirebase(
              doc.data() as Map<String, dynamic>));
        });
        return assessmentPeriods;
      });
    } catch (e) {
      print("Exception in AssessmentRepo on getAllAssessmentPeriod: $e");
    }

    return assessmentPeriods;
  }

  @override
  Future<AssessmentPeriod> getAssessmentPeriodById(String id) async {
    AssessmentPeriod assessmentPeriod = AssessmentPeriod();
    List<AssessmentVariables> assessmentVariables = [];

    try {
      assessmentPeriod = await _db!
          .collection(AssessmentPeriod.firebaseCollection)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        return AssessmentPeriod.fromFirebase(
            documentSnapshot.data() as Map<String, dynamic>);
      });

      assessmentVariables = await _db!
          .collection(AssessmentVariables.firebaseCollection)
          .where(AssessmentVariables.keyAssessmentPeriodId,
              isEqualTo: assessmentPeriod.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          assessmentVariables.add(AssessmentVariables.fromFirebase(
              doc.data() as Map<String, dynamic>));
        });
        return assessmentVariables;
      });
      assessmentPeriod.assessmentVariables = assessmentVariables;
    } catch (e) {
      print("Exception in AssessmentRepo on getAssessmentPeriodById: $e");
    }
    return assessmentPeriod;
  }

  @override
  Future<AssessmentPeriod> addAssessmentPeriod(
      AssessmentPeriod assessmentPeriodModel) {
    // TODO: implement addAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<AssessmentPeriod> updateAssessmentPeriod(
      AssessmentPeriod assessmentPeriodModel) {
    // TODO: implement updateAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssessmentPeriod(String id) {
    // TODO: implement deleteAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<List<AssessmentVariables>> getAllAssessmentVariables(
      String assessmentPeriodId) {
    // TODO: implement getAllAssessmentVariables
    throw UnimplementedError();
  }

  @override
  Future<AssessmentVariables> addAssessmentVariable(
      AssessmentVariables assessmentVariablesModel) {
    // TODO: implement addAssessmentVariable
    throw UnimplementedError();
  }

  @override
  Future<AssessmentVariables> updateAssessmentVariable(
      AssessmentVariables assessmentVariablesModel) {
    // TODO: implement updateAssessmentVariable
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssessmentVariable(String id) {
    // TODO: implement deleteAssessmentVariable
    throw UnimplementedError();
  }

  // ==================== Assessment Flight Details ==============================================================

  @override
  Future<AssessmentFlightDetails> getAllAssessmentFlightDetails() async {
    List<String> assessmentFlightDetails = [];
    try {
      await _db!
          .collection(AssessmentFlightDetails.firebaseCollection)
          .doc(AssessmentFlightDetails.firebaseDocument)
          .get()
          .then((value) {
        log("flightdetail: ${value.data()![AssessmentFlightDetails.flightDetailsKey]}");
        (value.data()![AssessmentFlightDetails.flightDetailsKey])
            .forEach((element) {
          assessmentFlightDetails.add(element.toString());
        });
      });

      return AssessmentFlightDetails(flightDetails: assessmentFlightDetails);
    } catch (e) {
      log("Exception in AssessmentRepo on getAllAssessmentFlightDetails: $e");
    }

    return AssessmentFlightDetails(flightDetails: assessmentFlightDetails);
  }

  @override
  Future<AssessmentFlightDetails> addAssessmentFlightDetails(
      AssessmentFlightDetails assessmentFlightDetailsModel) {
    // TODO: implement addAssessmentFlightDetails
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssessmentFlightDetails(String nameFlightDetails) {
    // TODO: implement deleteAssessmentFlightDetails
    throw UnimplementedError();
  }

  @override
  Future<AssessmentFlightDetails> updateAssessmentFlightDetails(
      AssessmentFlightDetails assessmentFlightDetailsModel) {
    // TODO: implement updateAssessmentFlightDetails
    throw UnimplementedError();
  }
}
