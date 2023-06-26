import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';

abstract class AssessmentRepo {
  // assessment period
  Future<List<AssessmentPeriodModel>> getAllAssessmentPeriods();
  Future<AssessmentPeriodModel> getAssessmentPeriodById(String id);
  Future<AssessmentPeriodModel> addAssessmentPeriod(AssessmentPeriodModel assessmentPeriodModel);
  Future<AssessmentPeriodModel> updateAssessmentPeriod(AssessmentPeriodModel assessmentPeriodModel);
  Future<void> deleteAssessmentPeriod(String id);

  // assessment variables
  Future<List<AssessmentVariablesModel>> getAllAssessmentVariables(String assessmentPeriodId);
  Future<AssessmentVariablesModel> addAssessmentVariable(AssessmentVariablesModel assessmentVariablesModel);
  Future<AssessmentVariablesModel> updateAssessmentVariable(AssessmentVariablesModel assessmentVariablesModel);
  Future<void> deleteAssessmentVariable(String id);
}

class AssessmentRepoImpl implements AssessmentRepo {
  AssessmentRepoImpl({
    FirebaseFirestore? db,
  }) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore? _db;

  // assessment period
  @override
  Future<List<AssessmentPeriodModel>> getAllAssessmentPeriods() async {
    List<AssessmentPeriodModel> assessmentPeriods = [];
    List<AssessmentVariablesModel> assessmentVariables = [];

    try {
      // get all assessment periods by sorting from the latest "period" to the oldest
      assessmentPeriods = await _db!
          .collection(AssessmentPeriodModel.firebaseCollection)
          .orderBy(AssessmentPeriodModel.keyPeriod, descending: true)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          assessmentPeriods.add(AssessmentPeriodModel.fromFirebase(doc.data() as Map<String, dynamic>));
        });
        return assessmentPeriods;
      });
    } catch (e) {
      print("Exception in AssessmentRepo on getAllAssessmentPeriod: $e");
    }

    return assessmentPeriods;
  }

  @override
  Future<AssessmentPeriodModel> getAssessmentPeriodById(String id) async {
    AssessmentPeriodModel assessmentPeriod = AssessmentPeriodModel();
    List<AssessmentVariablesModel> assessmentVariables = [];

    try {
      assessmentPeriod = await _db!
          .collection(AssessmentPeriodModel.firebaseCollection)
          .doc(id)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        return AssessmentPeriodModel.fromFirebase(documentSnapshot.data() as Map<String, dynamic>);
      });

      assessmentVariables = await _db!
          .collection(AssessmentVariablesModel.firebaseCollection)
          .where(AssessmentVariablesModel.keyAssessmentPeriodId, isEqualTo: id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          assessmentVariables.add(AssessmentVariablesModel.fromFirebase(doc.data() as Map<String, dynamic>));
        });
        return assessmentVariables;
      });

      assessmentPeriod.addAllAssessmentVariables(assessmentVariables);
    } catch (e) {
      print("Exception in AssessmentRepo on getAssessmentPeriodById: $e");
    }

    return assessmentPeriod;
  }

  @override
  Future<AssessmentPeriodModel> addAssessmentPeriod(AssessmentPeriodModel assessmentPeriodModel) {
    // TODO: implement addAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<AssessmentPeriodModel> updateAssessmentPeriod(AssessmentPeriodModel assessmentPeriodModel) {
    // TODO: implement updateAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssessmentPeriod(String id) {
    // TODO: implement deleteAssessmentPeriod
    throw UnimplementedError();
  }

  @override
  Future<List<AssessmentVariablesModel>> getAllAssessmentVariables(String assessmentPeriodId) {
    // TODO: implement getAllAssessmentVariables
    throw UnimplementedError();
  }

  @override
  Future<AssessmentVariablesModel> addAssessmentVariable(AssessmentVariablesModel assessmentVariablesModel) {
    // TODO: implement addAssessmentVariable
    throw UnimplementedError();
  }

  @override
  Future<AssessmentVariablesModel> updateAssessmentVariable(AssessmentVariablesModel assessmentVariablesModel) {
    // TODO: implement updateAssessmentVariable
    throw UnimplementedError();
  }

  @override
  Future<void> deleteAssessmentVariable(String id) {
    // TODO: implement deleteAssessmentVariable
    throw UnimplementedError();
  }
}
