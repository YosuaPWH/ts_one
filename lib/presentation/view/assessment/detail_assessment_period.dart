import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class DetailAssessmentPeriodView extends StatefulWidget {
  const DetailAssessmentPeriodView({Key? key, required this.assessmentPeriodId}) : super(key: key);

  final String assessmentPeriodId;

  @override
  State<DetailAssessmentPeriodView> createState() => _DetailAssessmentPeriodViewState();
}

class _DetailAssessmentPeriodViewState extends State<DetailAssessmentPeriodView> {
  late AssessmentViewModel viewModel;
  late UserPreferences userPreferences;
  late AssessmentPeriod assessmentPeriod;
  late String assessmentPeriodId;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    userPreferences = getItLocator<UserPreferences>();
    assessmentPeriodId = widget.assessmentPeriodId;
    assessmentPeriod = AssessmentPeriod();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAssessmentPeriodById();
    });

    super.initState();
  }

  void getAssessmentPeriodById() async {
    assessmentPeriod = await viewModel.getAssessmentPeriodById(assessmentPeriodId);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Assessment Period $assessmentPeriodId"),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    if (assessmentPeriod.period == Util.defaultDateIfNull)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    if (assessmentPeriod.period != Util.defaultDateIfNull)
                      Column(
                        children: [
                          Text("Period: ${assessmentPeriod.period}"),
                          Text("Status: ${assessmentPeriod.assessmentVariables}"),
                        ],
                      ),
                  ],
                ),
              ),
          );
        });
  }
}
