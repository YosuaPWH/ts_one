import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/dropdown_button_form_component.dart';
import 'package:ts_one/presentation/theme.dart';

import '../../../data/assessments/assessment_variables.dart';
import '../../../data/assessments/new_assessment.dart';
import '../../../util/util.dart';
import '../../view_model/assessment_viewmodel.dart';

class NewAssessmentVariables extends StatefulWidget {
  const NewAssessmentVariables(
      {Key? key, required this.dataAssessmentFlightDetails, required this.dataAssessmentCandidate})
      : super(key: key);

  final AssessmentFlightDetails dataAssessmentFlightDetails;
  final NewAssessment dataAssessmentCandidate;

  @override
  State<NewAssessmentVariables> createState() => _NewAssessmentVariablesState();
}

class _NewAssessmentVariablesState extends State<NewAssessmentVariables> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod dataAssessmentPeriod;
  late List<String> assessmentCategories;
  late Map<AssessmentVariables, bool> allAssessmentVariables;
  Map<AssessmentVariables, Map<String, String>> dataAssessmentVariablesFirst = {};

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    dataAssessmentPeriod = AssessmentPeriod();
    assessmentCategories = [];
    allAssessmentVariables = {};

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessment();
    });

    super.initState();
  }

  void getAllAssessment() async {
    dataAssessmentPeriod = await viewModel.getAllAssessmentVariablesFromLastPeriod();

    print("size: ${dataAssessmentPeriod.assessmentVariables.length}");

    for (var assessmentVariable in dataAssessmentPeriod.assessmentVariables) {
      if (!assessmentCategories.contains(assessmentVariable.category)) {
        assessmentCategories.add(assessmentVariable.category);
      }
      allAssessmentVariables.addAll({assessmentVariable: false});
    }
    print("object");
    print("jlh: ${allAssessmentVariables.length}");
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("data: ${widget.dataAssessmentFlightDetails.toString()}");

    return Consumer<AssessmentViewModel>(
      builder: (_, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              "New Assessment",
            ),
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
                            children: _expansionTilesForNewAssessmentVariables(),
                          ),
                        ),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      NamedRoute.newAssessmentVariablesSecond,
                      arguments: {
                        'dataAssessmentCandidate': widget.dataAssessmentCandidate,
                        'dataAssessmentFlightDetails': widget.dataAssessmentFlightDetails,
                        'dataAssessmentVariablesFirst': dataAssessmentVariablesFirst
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    backgroundColor: TsOneColor.primary,
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 48,
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Next",
                        style: TextStyle(color: TsOneColor.secondary),
                      ),
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

  List<Widget> _expansionTilesForNewAssessmentVariables() {
    List<Widget> expansionTilesVariables = [];

    // print("dadas: $assessmentVariables");
    print("JUMLAH: ${allAssessmentVariables.length}");
    for (var assessmentCategory in assessmentCategories) {
      expansionTilesVariables.add(
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
                    for (var data in allAssessmentVariables.keys)
                      if (data.category == assessmentCategory)
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                data.name,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  flex: 3,
                                  child: ListTileTheme(
                                    horizontalTitleGap: 0.0,
                                    contentPadding: EdgeInsets.zero,
                                    child: CheckboxListTile(
                                      value: allAssessmentVariables[data],
                                      contentPadding: const EdgeInsets.only(bottom: 10),
                                      dense: true,
                                      onChanged: (newValue) {
                                        setState(() {
                                          allAssessmentVariables[data] = newValue!;

                                          if (newValue) {
                                            if (!dataAssessmentVariablesFirst.containsKey(data)) {
                                              if (data.typeOfAssessment == "Satisfactory") {
                                                dataAssessmentVariablesFirst.addAll({
                                                  data: {
                                                    "Assessment": "N/A",
                                                    "Markers": "N/A",
                                                    "Empty": "true"
                                                  }
                                                });
                                              } else {
                                                dataAssessmentVariablesFirst.addAll({
                                                  data: {"PF": "N/A", "PM": "N/A", "Empty": "true"}
                                                });
                                              }
                                            } else {
                                              dataAssessmentVariablesFirst[data]?["Empty"] = "true";
                                            }
                                          } else {
                                            dataAssessmentVariablesFirst[data]?["Empty"] = "false";
                                          }
                                        });
                                      },
                                      title: const Text("N/A"),
                                      controlAffinity: ListTileControlAffinity.leading,
                                    ),
                                  ),
                                ),
                                if (data.typeOfAssessment == "Satisfactory")
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 5,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                                            child: DropdownButtonFormField(
                                              value: dataAssessmentVariablesFirst[data]?["Assessment"] == "N/A"
                                                  ? null
                                                  : dataAssessmentVariablesFirst[data]?["Assessment"],
                                              padding: const EdgeInsets.all(0),
                                              isExpanded: false,
                                              isDense: true,
                                              onChanged: allAssessmentVariables[data]!
                                                  ? null
                                                  : (newValue) {
                                                      setState(() {
                                                        if (!dataAssessmentVariablesFirst.containsKey(data)) {
                                                          dataAssessmentVariablesFirst.addAll({
                                                            data: {
                                                              "Assessment": newValue as String,
                                                              "Markers": "N/A",
                                                              "Empty": "false"
                                                            }
                                                          });
                                                        } else {
                                                          dataAssessmentVariablesFirst[data]?["Assessment"] =
                                                              newValue as String;
                                                        }
                                                      });
                                                    },
                                              decoration: const InputDecoration(
                                                border: OutlineInputBorder(),
                                                label: Text(
                                                  "Assessment",
                                                  style: TextStyle(fontSize: 12),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              items: const [
                                                DropdownMenuItem(
                                                  value: "Satisfactory",
                                                  child: Text(
                                                    "Satisfactory",
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                ),
                                                DropdownMenuItem(
                                                  value: "Unsatisfactory",
                                                  child: Text(
                                                    "Unsatisfactory",
                                                    style: TextStyle(fontSize: 12),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 3,
                                        ),
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                                            child: DropdownButtonFormComponent(
                                              value: dataAssessmentVariablesFirst[data]?["Markers"] == "N/A"
                                                  ? null
                                                  : dataAssessmentVariablesFirst[data]?["Markers"],
                                              label: "Markers",
                                              isDisabled: allAssessmentVariables[data]!,
                                              onValueChanged: (newValue) {
                                                if (!dataAssessmentVariablesFirst.containsKey(data)) {
                                                  dataAssessmentVariablesFirst.addAll({
                                                    data: {
                                                      "Assessment": "N/A",
                                                      "Markers": newValue,
                                                      "Empty": "false"
                                                    }
                                                  });
                                                } else {
                                                  dataAssessmentVariablesFirst[data]?["Markers"] = newValue;
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                else
                                  Flexible(
                                    flex: 7,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: 3,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 15),
                                            child: DropdownButtonFormComponent(
                                              value: dataAssessmentVariablesFirst[data]?["PF"] == "N/A"
                                                  ? null
                                                  : dataAssessmentVariablesFirst[data]?["PF"],
                                              label: "PF",
                                              isDisabled: allAssessmentVariables[data]!,
                                              onValueChanged: (newValue) {
                                                setState(() {
                                                  if (!dataAssessmentVariablesFirst.containsKey(data)) {
                                                    dataAssessmentVariablesFirst.addAll({
                                                      data: {
                                                        "PF": newValue,
                                                        "PM": "N/A",
                                                        "Empty": "false"
                                                      }
                                                    });
                                                  } else {
                                                    dataAssessmentVariablesFirst[data]?["PF"] = newValue;
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
                                              value: dataAssessmentVariablesFirst[data]?["PM"] == "N/A"
                                                  ? null
                                                  : dataAssessmentVariablesFirst[data]?["PM"],
                                              label: "PM",
                                              isDisabled: allAssessmentVariables[data]!,
                                              onValueChanged: (newValue) {
                                                setState(() {
                                                  if (!dataAssessmentVariablesFirst.containsKey(data)) {
                                                    dataAssessmentVariablesFirst.addAll({
                                                      data: {
                                                        "PF": "N/A",
                                                        "PM": newValue,
                                                        "Empty": "false"
                                                      }
                                                    });
                                                  } else {
                                                    dataAssessmentVariablesFirst[data]?["PM"] = newValue;
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                              ],
                            ),
                          ],
                        ),
                  ],
                ),
              ),
            )
          ],
        ),
      );
      expansionTilesVariables.add(const SizedBox(
        height: 15,
      ));
    }

    return expansionTilesVariables;
  }
}
