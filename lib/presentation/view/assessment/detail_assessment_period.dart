import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class DetailAssessmentPeriodView extends StatefulWidget {
  const DetailAssessmentPeriodView({Key? key, required this.assessmentPeriodId}) : super(key: key);

  final String assessmentPeriodId;

  @override
  State<DetailAssessmentPeriodView> createState() => _DetailAssessmentPeriodViewState();
}

class _DetailAssessmentPeriodViewState extends State<DetailAssessmentPeriodView> {
  late AssessmentViewModel viewModel;
  late UserPreferences userPreferences;
  late AssessmentPeriodModel assessmentPeriod;
  late String assessmentPeriodId;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    userPreferences = getItLocator<UserPreferences>();
    assessmentPeriod = AssessmentPeriodModel();
    assessmentPeriodId = widget.assessmentPeriodId;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Detail Assessment Period"),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text("Assessment Period: ${assessmentPeriod.id}"),
                    Text("Effective on: ${assessmentPeriod.period}"),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
