import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/presentation/shared_components/legend_widget.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  late AssessmentResultsViewModel assessmentResultsviewModel;
  late AssessmentViewModel assessmentViewModel;

  late DateTime nowWithoutTime;
  late DateTime startDate;
  late DateTime endDate;

  late List<AssessmentResults> assessmentResults;
  late List<AssessmentResults> assessmentResultsFilteredByDate;

  late List<AssessmentVariables> assessmentVariables;
  late List<AssessmentVariables> humanFactorAssessmentVariables;
  late List<Map<String, dynamic>> mapOfAssessmentVariableResultsCount;
  late List<Map<String, dynamic>> mapOfHumanFactorAssessmentVariableResultsCount;

  late bool chartLoading;
  late bool isChartInitialized;
  late Widget barChartMainAssessment;

  @override
  void initState() {
    assessmentResultsviewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    assessmentViewModel = Provider.of<AssessmentViewModel>(context, listen: false);

    nowWithoutTime = Util.getCurrentDateWithoutTime();
    startDate = Util.defaultDateIfNull;
    endDate = nowWithoutTime;

    assessmentResults = [];
    assessmentResultsFilteredByDate = [];

    assessmentVariables = [];
    humanFactorAssessmentVariables = [];
    mapOfAssessmentVariableResultsCount = [];
    mapOfHumanFactorAssessmentVariableResultsCount = [];

    chartLoading = true;
    isChartInitialized = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getAllAssessmentResultsFromRemote();
    });

    super.initState();
  }

  void getAllAssessmentResultsFromRemote() async {
    assessmentResults = await assessmentResultsviewModel.getAllAssessmentResults();
    filterAssessmentResultsByDate();
  }

  void filterAssessmentResultsByDate() {
    assessmentResultsFilteredByDate.clear();
    for (AssessmentResults assessmentResult in assessmentResults) {
      if (assessmentResult.date.isAfter(startDate) &&
          assessmentResult.date.isBefore(endDate) ||
          assessmentResult.date.isAtSameMomentAs(startDate) ||
          assessmentResult.date.isAtSameMomentAs(endDate)
      ) {
        assessmentResultsFilteredByDate.add(assessmentResult);
      }
    }
    setState(() {
      assessmentResultsFilteredByDate = assessmentResultsFilteredByDate;
    });
    getAllAssessmentVariablesFromTheLatestAssessmentPeriod();
  }

  void getAllAssessmentVariablesFromTheLatestAssessmentPeriod() async {
    if (!isChartInitialized){
      assessmentVariables = await assessmentViewModel
            .getAllFlightAssessmentVariablesFromLatestPeriod();
      humanFactorAssessmentVariables = await assessmentViewModel
          .getAllHumanFactorAssessmentVariablesFromLatestPeriod();
    }

    mapOfAssessmentVariableResultsCount.clear();
    mapOfHumanFactorAssessmentVariableResultsCount.clear();

    for(AssessmentVariables assessmentVariable in assessmentVariables) {
      mapOfAssessmentVariableResultsCount.add({
        AssessmentVariables.keyId: assessmentVariable.id,
        AssessmentVariables.keyName: assessmentVariable.name,
        AssessmentVariables.keyTypeOfAssessment: assessmentVariable.typeOfAssessment,
        'Markers 1': 0,
        'Markers 2': 0,
        'Markers 3': 0,
        'Markers 4': 0,
        'Markers 5': 0,
      });
    }

    for(AssessmentVariables humanfactorAssessmentVariable in humanFactorAssessmentVariables) {
      mapOfHumanFactorAssessmentVariableResultsCount.add({
        AssessmentVariables.keyId: humanfactorAssessmentVariable.id,
        AssessmentVariables.keyName: humanfactorAssessmentVariable.name,
        AssessmentVariables.keyTypeOfAssessment: humanfactorAssessmentVariable.typeOfAssessment,
        'PF Markers 1': 0,
        'PF Markers 2': 0,
        'PF Markers 3': 0,
        'PF Markers 4': 0,
        'PF Markers 5': 0,

        'PM Markers 1': 0,
        'PM Markers 2': 0,
        'PM Markers 3': 0,
        'PM Markers 4': 0,
        'PM Markers 5': 0,
      });
    }

    getCountOfEachAssessmentVariableResultsPerMarker();
  }

  void getCountOfEachAssessmentVariableResultsPerMarker() async {
    for(AssessmentResults assessmentResult in assessmentResultsFilteredByDate) {
      for(int i = 0; i < assessmentResult.variableResults.length; i++) {
        for(int j = 0; j < mapOfAssessmentVariableResultsCount.length; j++) {

          if(assessmentResult.variableResults[i].assessmentVariableId == mapOfAssessmentVariableResultsCount[j][AssessmentVariables.keyId]) {
            if(assessmentResult.variableResults[i].assessmentType == AssessmentVariables.keySatisfactory) {
              switch(assessmentResult.variableResults[i].assessmentMarkers){
                case 1:
                  mapOfAssessmentVariableResultsCount[j]['Markers 1']++;
                  break;
                case 2:
                  mapOfAssessmentVariableResultsCount[j]['Markers 2']++;
                  break;
                case 3:
                  mapOfAssessmentVariableResultsCount[j]['Markers 3']++;
                  break;
                case 4:
                  mapOfAssessmentVariableResultsCount[j]['Markers 4']++;
                  break;
                case 5:
                  mapOfAssessmentVariableResultsCount[j]['Markers 5']++;
                  break;
                default:
                  break;
              }
            }
            else {
              switch(assessmentResult.variableResults[i].pilotFlyingMarkers) {
                case 1:
                  mapOfAssessmentVariableResultsCount[j]['Markers 1']++;
                  break;
                case 2:
                  mapOfAssessmentVariableResultsCount[j]['Markers 2']++;
                  break;
                case 3:
                  mapOfAssessmentVariableResultsCount[j]['Markers 3']++;
                  break;
                case 4:
                  mapOfAssessmentVariableResultsCount[j]['Markers 4']++;
                  break;
                case 5:
                  mapOfAssessmentVariableResultsCount[j]['Markers 5']++;
                  break;
                default:
                  break;
              }

              switch(assessmentResult.variableResults[i].pilotMonitoringMarkers) {
                case 1:
                  mapOfAssessmentVariableResultsCount[j]['Markers 1']++;
                  break;
                case 2:
                  mapOfAssessmentVariableResultsCount[j]['Markers 2']++;
                  break;
                case 3:
                  mapOfAssessmentVariableResultsCount[j]['Markers 3']++;
                  break;
                case 4:
                  mapOfAssessmentVariableResultsCount[j]['Markers 4']++;
                  break;
                case 5:
                  mapOfAssessmentVariableResultsCount[j]['Markers 5']++;
                  break;
                default:
                  break;
              }
            }
          }

        }
      }
    }
    setState(() {
      mapOfAssessmentVariableResultsCount = mapOfAssessmentVariableResultsCount;
    });
    buildChart();
    isChartInitialized = true;
  }

  void _selectStartingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate == Util.defaultDateIfNull ? nowWithoutTime : startDate,
      firstDate: DateTime(1999),
      lastDate: nowWithoutTime,
      helpText: "Select first date",
    );
    if (picked != null && picked != startDate) {
      setState(() {
        startDate = picked;
      });
      filterAssessmentResultsByDate();
    }
  }

  void _selectEndingDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate,
      firstDate: DateTime(1999),
      lastDate: nowWithoutTime,
      helpText: "Select last date",
    );
    if (picked != null && picked != endDate) {
      setState(() {
        endDate = picked;
      });
      filterAssessmentResultsByDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentResultsViewModel>(
      builder: (_, model, child) {
        return SafeArea(
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        "Analytics",
                        style: tsOneTextTheme.headlineLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Start Date',
                                focusColor: TsOneColor.primary,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text: Util.convertDateTimeDisplay(startDate.toString(), "dd MMM yyyy"),
                              ),
                              onTap: () {
                                _selectStartingDate(context);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          const Expanded(
                            flex: 4,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "- to -",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 4,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                labelText: 'End Date',
                                focusColor: TsOneColor.primary,
                              ),
                              readOnly: true,
                              controller: TextEditingController(
                                text: Util.convertDateTimeDisplay(endDate.toString(), "dd MMM yyyy"),
                              ),
                              onTap: () {
                                _selectEndingDate(context);
                                FocusScope.of(context).unfocus();
                              },
                            ),
                          ),
                          /*
                          Expanded(
                            flex: 2,
                            child: IconButton(
                                onPressed: () {
                                  getAllAssessmentResults();
                                },
                                icon: const Icon(Icons.search)
                            ),
                          )
                           */
                        ],
                      ),
                    ),
                    model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Text("Currently showing analytics of ${assessmentResultsFilteredByDate.length} assessment results from "
                              "${Util.convertDateTimeDisplay(startDate.toString(), "dd MMM yyyy")} to "
                              "${Util.convertDateTimeDisplay(endDate.toString(), "dd MMM yyyy")}."),
                          chartLoading? const Center(
                            child: CircularProgressIndicator(),
                          ) : Padding(
                            padding: const EdgeInsets.only(top: 32.0),
                            child: Column(
                              children: [
                                LegendsListWidget(
                                  legends: [
                                    Legend('Markers 1', Colors.red),
                                    Legend('Markers 2', Colors.yellow),
                                    Legend('Markers 3', Colors.green),
                                    Legend('Markers 4', Colors.blue),
                                    Legend('Markers 5', Colors.purple),
                                  ],
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 3200,
                                    height: 1000,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 120.0, bottom: 96.0),
                                      child: barChartMainAssessment,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ],
                ),
              ]),
            ),
          ),
        ));
      },
    );
  }

  void buildChart() {
    double betweenSpace = 0.2;
    double barWidth = 48;
    // building stacked bar chart using fl_chart for each variable saved in mapOfAssessmentVariableResultsCount
    chartLoading = true;
    barChartMainAssessment = BarChart(
      BarChartData(
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 160,
                  getTitlesWidget: (value, meta) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 48.0),
                      child: Transform.translate(
                        offset: const Offset(40, 20),
                        child: Transform.rotate(
                          angle: -3.14 / 2,
                          child: SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(
                              mapOfAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyName],
                              softWrap: true,
                            ),
                          ),
                        )
                      ),
                    );
                  },
              ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
        ),
        alignment: BarChartAlignment.center,
        groupsSpace: 20,
        barGroups: [
          for (var i = 0; i < mapOfAssessmentVariableResultsCount.length; i++)
            BarChartGroupData(
              showingTooltipIndicators: mapOfAssessmentVariableResultsCount[i]['Name'],
              x: i,
              groupVertically: true,
              barRods: [
                BarChartRodData(
                  fromY: 0,
                  toY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble(),
                  color: Colors.red,
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  fromY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble(),
                  toY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble(),
                  color: Colors.yellow,
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  fromY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                    + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble(),
                  toY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                    + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble()
                    + mapOfAssessmentVariableResultsCount[i]['Markers 3'].toDouble(),
                  color: Colors.green,
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  fromY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 3'].toDouble(),
                  toY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 3'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 4'].toDouble(),
                  color: Colors.blue,
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                BarChartRodData(
                  fromY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 3'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 4'].toDouble(),
                  toY: mapOfAssessmentVariableResultsCount[i]['Markers 1'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 2'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 3'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 4'].toDouble()
                      + mapOfAssessmentVariableResultsCount[i]['Markers 5'].toDouble(),
                  color: Colors.purple,
                  width: barWidth,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
              ],
              // showingTooltipIndicators: [0],
            ),
        ],
        barTouchData: BarTouchData(
          enabled: true,
          touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              String variableName = mapOfAssessmentVariableResultsCount[group.x.toInt()][AssessmentVariables.keyName];
              String markerName = "";
              if (rodIndex == 0) {
                markerName = "Markers 1";
              } else if (rodIndex == 1) {
                markerName = "Markers 2";
              } else if (rodIndex == 2) {
                markerName = "Markers 3";
              } else if (rodIndex == 3) {
                markerName = "Markers 4";
              } else if (rodIndex == 4) {
                markerName = "Markers 5";
              }
              return BarTooltipItem(
                "$variableName\nTotal of $markerName: ${mapOfAssessmentVariableResultsCount[group.x.toInt()][markerName]}",
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      )
    );
    chartLoading = false;
  }
}
