import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/dropdown_button_form_component.dart';
import 'package:ts_one/presentation/theme.dart';

import '../../../data/assessments/assessment_variables.dart';
import '../../../data/assessments/new_assessment.dart';
import '../../view_model/assessment_viewmodel.dart';

class NewAssessmentVariables extends StatefulWidget {
  const NewAssessmentVariables({Key? key, required this.dataCandidate}) : super(key: key);

  final NewAssessment dataCandidate;

  @override
  State<NewAssessmentVariables> createState() => _NewAssessmentVariablesState();
}

class _NewAssessmentVariablesState extends State<NewAssessmentVariables> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod dataAssessmentPeriod;
  late NewAssessment _newAssessment;
  late bool _flightCrew2Enabled;
  late List<String> assessmentCategories;
  late List<String> manualAssessmentCategories;
  late List<AssessmentVariables> allAssessmentVariables;
  late Map<AssessmentVariables, bool> allAssessmentVariablesFirstCrew;
  late Map<AssessmentVariables, bool> allAssessmentVariablesSecondCrew;
  Map<AssessmentVariables, Map<String, String>> dataAssessmentFlightFirstCrew = {};
  Map<AssessmentVariables, Map<String, String>> dataAssessmentFlightSecondCrew = {};


  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    _newAssessment = widget.dataCandidate;
    // _newAssessment.assessmentVariablesFlights1 = [];
    // _newAssessment.assessmentVariablesFlights2 = [];
    dataAssessmentPeriod = AssessmentPeriod();
    assessmentCategories = [];
    allAssessmentVariables = [];
    allAssessmentVariablesFirstCrew = {};
    allAssessmentVariablesSecondCrew = {};
    manualAssessmentCategories = ["Aircraft System/Procedures", "Abnormal/Emer.Proc"];

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessment();
    });

    if(_newAssessment.typeOfAssessment == NewAssessment.keyTypeOfAssessmentSimulator) {
      _flightCrew2Enabled = true;
    } else {
      _flightCrew2Enabled = false;
    }

    super.initState();
  }

  void getAllAssessment() async {
    dataAssessmentPeriod = await viewModel.getAllFlightAssessmentVariablesFromLastPeriod();

    // print("size: ${dataAssessmentPeriod.assessmentVariables.length}");

    for (var assessmentVariable in dataAssessmentPeriod.assessmentVariables) {
      if (!assessmentCategories.contains(assessmentVariable.category)) {
        assessmentCategories.add(assessmentVariable.category);
      }

      allAssessmentVariables.add(assessmentVariable);
      allAssessmentVariablesFirstCrew.addAll({assessmentVariable: false});
      allAssessmentVariablesSecondCrew.addAll({assessmentVariable: false});

      _newAssessment.assessmentVariablesFlights1.add(AssessmentVariableResults(
        assessmentVariableId: assessmentVariable.id,
        assessmentVariableName: assessmentVariable.name,
      ));
      _newAssessment.assessmentVariablesFlights2.add(AssessmentVariableResults(
        assessmentVariableId: assessmentVariable.id,
        assessmentVariableName: assessmentVariable.name,
      ));
    }
    // print("jlh: ${allAssessmentVariablesFirstCrew.length}");
  }

  @override
  Widget build(BuildContext context) {
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
                              children:
                                  _expansionTilesForNewAssessmentVariables(),
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
                      NamedRoute.newAssessmentHumanFactorVariables,
                      arguments: _newAssessment,
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
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _expansionTilesForNewAssessmentVariables() {
    List<Widget> expansionTilesVariables = [];

    // print("dadas: $assessmentVariables");
    // print("JUMLAH: ${allAssessmentVariablesFirstCrew.length}");
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
                  color: TsOneColor.secondary),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Column(
                  children: [
                    for (var index = 0; index < allAssessmentVariables.length; index++)
                      // Text(data.toString()),
                      if (allAssessmentVariables[index].category == assessmentCategory)
                        Column(
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                allAssessmentVariables[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            for (int flightCrewNo = 1; flightCrewNo <= 2; flightCrewNo++)
                              Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text("Crew $flightCrewNo"),
                                  ),
                                  fieldForEveryCrew(
                                    allAssessmentVariables[index],
                                    index,
                                    flightCrewNo,
                                    flightCrewNo == 1 ? dataAssessmentFlightFirstCrew : dataAssessmentFlightSecondCrew,
                                    flightCrewNo == 1 ? allAssessmentVariablesFirstCrew : allAssessmentVariablesSecondCrew,
                                  ),
                                ],
                              ),
                            const Divider(
                              color: TsOneColor.secondaryContainer,
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

    for (var category in manualAssessmentCategories) {
      expansionTilesVariables.add(
        ExpansionTile(
          title: Text(category),
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
          shape: RoundedRectangleBorder(side: BorderSide(color: TsOneColor.primary.withOpacity(0.15)), borderRadius: BorderRadius.circular(5.0)),
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
                    Column(
                      children: [
                        TextField(
                          onChanged: (value) {},
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'New Assessment',
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                                flex: 1,
                                child: DropdownButtonFormComponent(
                                  label: "PF",
                                  isDisabled: false,
                                  value: null,
                                  onValueChanged: (newValue) {},
                                )),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              flex: 1,
                              child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: DropdownButtonFormComponent(
                                    label: "PM",
                                    isDisabled: false,
                                    value: null,
                                    onValueChanged: (newValue) {},
                                  )),
                            )
                          ],
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child: const Center(
                            child: Icon(Icons.add),
                          ),
                        )
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

  Widget fieldForEveryCrew(
      AssessmentVariables data,
      int currentIndexInListOfAssessmentVariables,
      int flightCrewNo,
      Map<AssessmentVariables, Map<String, String>> dataCrew,
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
              value: allVariableCrew[data],
              contentPadding: const EdgeInsets.only(bottom: 10),
              dense: true,
              onChanged: (newValue) {
                setState(() {
                  allVariableCrew[data] = newValue!;

                  if (newValue) {
                    if (!dataCrew.containsKey(data)) {
                      if (data.typeOfAssessment == "Satisfactory") {
                        dataCrew.addAll({
                          data: {"Assessment": "N/A", "Markers": "N/A", "Empty": "true"}
                        });
                      } else {
                        dataCrew.addAll({
                          data: {"PF": "N/A", "PM": "N/A", "Empty": "true"}
                        });
                      }
                    } else {
                      dataCrew[data]?["Empty"] = "true";
                      dataCrew[data]?["Assessment"] = "N/A";
                      dataCrew[data]?["Markers"] = "N/A";
                      dataCrew[data]?["PF"] = "N/A";
                      dataCrew[data]?["PM"] = "N/A";
                    }
                  } else {
                    dataCrew[data]?["Empty"] = "false";
                  }

                  switch(flightCrewNo) {
                    case 1:
                      _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].isNotApplicable = newValue;
                      _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].reset();
                      break;
                    case 2:
                      _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].isNotApplicable = newValue;
                      _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].reset();
                      break;
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
                      value: dataCrew[data]?["Assessment"] == "N/A" ? null : dataCrew[data]?["Assessment"],
                      padding: const EdgeInsets.all(0),
                      isExpanded: false,
                      isDense: true,
                      onChanged: allVariableCrew[data]!
                          ? null
                          : (newValue) {
                              setState(() {
                                if (!dataCrew.containsKey(data)) {
                                  dataCrew.addAll({
                                    data: {
                                      "Assessment": newValue as String,
                                      "Markers": "N/A",
                                      "Empty": "false"
                                    }
                                  });
                                } else {
                                  dataCrew[data]?["Assessment"] = newValue as String;
                                }

                                switch(flightCrewNo){
                                  case 1:
                                    _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].assessmentSatisfactory = newValue as String;
                                    break;
                                  case 2:
                                    _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].assessmentSatisfactory = newValue as String;
                                    break;
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
                      value: dataCrew[data]?["Markers"] == "N/A" ? null : dataCrew[data]?["Markers"],
                      label: "Markers",
                      isDisabled: allVariableCrew[data]!,
                      onValueChanged: (newValue) {
                        if (!dataCrew.containsKey(data)) {
                          dataCrew.addAll({
                            data: {
                              "Assessment": "N/A",
                              "Markers": newValue,
                              "Empty": "false"
                            }
                          });
                        } else {
                          dataCrew[data]?["Markers"] = newValue;
                        }

                        switch(flightCrewNo){
                          case 1:
                            _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].assessmentMarkers = int.parse(newValue);
                            break;
                          case 2:
                            _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].assessmentMarkers = int.parse(newValue);
                            break;
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
                      value: dataCrew[data]?["PF"] == "N/A" ? null : dataCrew[data]?["PF"],
                      label: "PF",
                      isDisabled: allVariableCrew[data]!,
                      onValueChanged: (newValue) {
                        setState(() {
                          if (!dataCrew.containsKey(data)) {
                            dataCrew.addAll({
                              data: {
                                "PF": newValue,
                                "PM": "N/A",
                                "Empty": "false"
                              }
                            });
                          } else {
                            dataCrew[data]?["PF"] = newValue;
                          }
                          switch(flightCrewNo){
                            case 1:
                              _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].pilotFlyingMarkers = int.parse(newValue);
                              break;
                            case 2:
                              _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].pilotFlyingMarkers = int.parse(newValue);
                              break;
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
                              data: {
                                "PF": "N/A",
                                "PM": newValue,
                                "Empty": "false"
                              }
                            });
                          } else {
                            dataCrew[data]?["PM"] = newValue;
                          }
                          switch(flightCrewNo){
                            case 1:
                              _newAssessment.assessmentVariablesFlights1[currentIndexInListOfAssessmentVariables].pilotMonitoringMarkers = int.parse(newValue);
                              break;
                            case 2:
                              _newAssessment.assessmentVariablesFlights2[currentIndexInListOfAssessmentVariables].pilotMonitoringMarkers = int.parse(newValue);
                              break;
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
    );
  }
}
