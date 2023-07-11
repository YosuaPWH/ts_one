import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/presentation/shared_components/dropdown_button_form_component.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';

class NewAssessmentHumanFactor extends StatefulWidget {
  const NewAssessmentHumanFactor({super.key});

  @override
  State<NewAssessmentHumanFactor> createState() => _NewAssessmentHumanFactorState();
}

class _NewAssessmentHumanFactorState extends State<NewAssessmentHumanFactor> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod dataAssessmentPeriod;
  late List<String> assessmentCategories;
  late Map<AssessmentVariables, bool> allAssessmentVariablesFirstCrew;
  late Map<AssessmentVariables, bool> allAssessmentVariablesSecondCrew;
  Map<AssessmentVariables, Map<String, String>> dataAssessmentHumanFactorFirstCrew = {};
  Map<AssessmentVariables, Map<String, String>> dataAssessmentHumanFactorSecondCrew = {};

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    dataAssessmentPeriod = AssessmentPeriod();
    assessmentCategories = [];
    allAssessmentVariablesFirstCrew = {};
    allAssessmentVariablesSecondCrew = {};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessment();
    });

    super.initState();
  }

  void getAllAssessment() async {
    dataAssessmentPeriod = await viewModel.getAllHumanFactorAssessmentVariablesFromLastPeriod();
    log("data ${dataAssessmentPeriod.toString()}");

    for (var assessmentVariable in dataAssessmentPeriod.assessmentVariables) {
      if (!assessmentCategories.contains(assessmentVariable.category)) {
        assessmentCategories.add(assessmentVariable.category);
      }
      allAssessmentVariablesFirstCrew.addAll({assessmentVariable: false});
      allAssessmentVariablesSecondCrew.addAll({assessmentVariable: false});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Human Factor"),
          ),
          body: Column(
            children: [
              Expanded(
                child: model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: _expansionTilesForNewAssessmentHumanFactorVariables(),
                          ),
                        ),
                      ),
              )
            ],
          ),
        );
      },
    );
  }

  List<Widget> _expansionTilesForNewAssessmentHumanFactorVariables() {
    List<Widget> expansionTilesHumanFactorVariables = [];

    for (var assessmentCategory in assessmentCategories) {
      expansionTilesHumanFactorVariables.add(
        ExpansionTile(
          title: Text(assessmentCategory),
          backgroundColor: TsOneColor.primary,
          collapsedBackgroundColor: TsOneColor.surface,
          textColor: TsOneColor.onPrimary,
          collapsedTextColor: TsOneColor.onSecondary,
          iconColor: TsOneColor.onPrimary,
          collapsedIconColor: TsOneColor.onSecondary,
          collapsedShape: RoundedRectangleBorder(
            side: BorderSide(color: TsOneColor.primary.withOpacity(0.15)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: TsOneColor.primary.withOpacity(0.5)),
            borderRadius: BorderRadius.circular(5.0),
          ),
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(5.0),
                ),
                color: TsOneColor.secondary,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  children: [
                    for (var data in allAssessmentVariablesFirstCrew.keys)
                      if (data.category == assessmentCategory)
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            for (int i = 1; i <= 2; i++)
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Crew $i"),
                                  ),
                                  fieldForEveryCrew(
                                    data,
                                    i == 1 ? dataAssessmentHumanFactorFirstCrew : dataAssessmentHumanFactorSecondCrew,
                                    i == 1 ? allAssessmentVariablesFirstCrew : allAssessmentVariablesSecondCrew,
                                  ),
                                ],
                              ),
                            const Divider(
                              color: TsOneColor.secondaryContainer,
                            ),
                          ],
                        )
                  ],
                ),
              ),
            )
          ],
        ),
      );
      expansionTilesHumanFactorVariables.add(const SizedBox(
        height: 15,
      ));
    }

    return expansionTilesHumanFactorVariables;
  }

  Widget fieldForEveryCrew(AssessmentVariables data, Map<AssessmentVariables, Map<String, String>> dataCrew,
      Map<AssessmentVariables, bool> allVariableCrew) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Flexible(
          flex: 3,
          child: ListTileTheme(
            horizontalTitleGap: 0.0,
            contentPadding: EdgeInsets.zero,
            child: CheckboxListTile(
              title: const Text("N/A"),
              controlAffinity: ListTileControlAffinity.leading,
              value: allVariableCrew[data],
              contentPadding: const EdgeInsets.only(bottom: 10),
              dense: true,
              onChanged: (newValue) {
                setState(() {
                  allVariableCrew[data] = newValue!;

                  if (newValue) {
                    if (!dataCrew.containsKey(data)) {
                      dataCrew.addAll({
                        data: {"PF": "N/A", "PM": "N/A", "Empty": "true"}
                      });
                    } else {
                      dataCrew[data]?["Empty"] = "true";
                    }
                  } else {
                    dataCrew[data]?["Empty"] = "false";
                  }
                });
              },
            ),
          ),
        ),
        Flexible(
          flex: 7,
          child: Row(
            children: [
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
                  child: DropdownButtonFormComponent(
                    value: dataCrew[data]?["PF"] == "N/A" ? null : dataCrew[data]?["PF"],
                    label: "PF",
                    isDisabled: allVariableCrew[data]!,
                    onValueChanged: (newValue) {
                      setState(() {
                        if (!dataCrew.containsKey(data)) {
                          dataCrew.addAll({
                            data: {"PF": newValue, "PM": "N/A", "Empty": "false"}
                          });
                        } else {
                          dataCrew[data]?["PF"] = newValue;
                        }
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 15),
                  child: DropdownButtonFormComponent(
                    value: dataCrew[data]?["PM"] == "N/A" ? null : dataCrew[data]?["PM"],
                    label: "PM",
                    isDisabled: allVariableCrew[data]!,
                    onValueChanged: (newValue) {
                      setState(() {
                        if (!dataCrew.containsKey(data)) {
                          dataCrew.addAll({
                            data: {"PF": "N/A", "PM": newValue, "Empty": "false"}
                          });
                        } else {
                          dataCrew[data]?["PM"] = newValue;
                        }
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
