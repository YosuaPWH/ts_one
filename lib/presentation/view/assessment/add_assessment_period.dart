import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class AddAssessmentPeriodView extends StatefulWidget {
  const AddAssessmentPeriodView({Key? key}) : super(key: key);

  @override
  State<AddAssessmentPeriodView> createState() =>
      _AddAssessmentPeriodViewState();
}

class _AddAssessmentPeriodViewState extends State<AddAssessmentPeriodView> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod assessmentPeriod;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    assessmentPeriod = AssessmentPeriod();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(builder: (_, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("New Form Assessment"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
            ),
          )
          ),
        ),
      );
    },
    );
  }
}
