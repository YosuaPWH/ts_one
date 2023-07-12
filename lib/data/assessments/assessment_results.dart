import 'package:ts_one/util/util.dart';

class AssessmentResults{
  AssessmentResults({
    this.id = Util.defaultStringIfNull,
    this.overallPerformance = Util.defaultIntIfNull,
    this.notes = Util.defaultStringIfNull,
  });

  static const String keyId = "id";
  static const String keyOverallPerformance = "overall-performance";
  static const String keyNotes = "notes";

  String id = Util.defaultStringIfNull;
  int overallPerformance = Util.defaultIntIfNull;
  String notes = Util.defaultStringIfNull;
}
