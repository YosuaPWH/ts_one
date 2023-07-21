import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/data/users/users.dart';
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
  late String rank;
  static List<String> rankList = ['All', UserModel.keyPositionCaptain, UserModel.keyPositionFirstOfficer];

  late List<AssessmentResults> assessmentResults;
  late List<AssessmentResults> assessmentResultsFilteredByRank;
  late List<AssessmentResults> assessmentResultsFilteredByDate;

  late List<AssessmentVariables> assessmentVariables;
  late List<AssessmentVariables> humanFactorAssessmentVariables;
  late List<Map<String, dynamic>> mapOfAssessmentVariableResultsCount;
  late List<Map<String, dynamic>> mapOfHumanFactorAssessmentVariableResultsCount;

  late bool chartLoading;
  late bool isChartInitialized;
  late Widget barChartMainAssessment;
  late Widget barChartHumanFactorPFAssessment;
  late Widget barChartHumanFactorPMAssessment;

  @override
  void initState() {
    assessmentResultsviewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    assessmentViewModel = Provider.of<AssessmentViewModel>(context, listen: false);

    nowWithoutTime = Util.getCurrentDateWithoutTime();
    startDate = Util.defaultDateIfNull;
    endDate = nowWithoutTime;
    rank = rankList[0];

    assessmentResults = [];
    assessmentResultsFilteredByRank = [];
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
    filterAssessmentResults();
  }

  // filtered by date and/or rank
  void filterAssessmentResults() {
    assessmentResultsFilteredByRank.clear();
    assessmentResultsFilteredByDate.clear();

    // filtering by rank first
    if(rank == rankList[1]) {
      for (AssessmentResults assessmentResult in assessmentResults) {
        if (assessmentResult.rank == rankList[1]) {
          assessmentResultsFilteredByRank.add(assessmentResult);
        }
      }
    } else if(rank == rankList[2]) {
      for (AssessmentResults assessmentResult in assessmentResults) {
        if (assessmentResult.rank == rankList[2]) {
          assessmentResultsFilteredByRank.add(assessmentResult);
        }
      }
    } else {
      assessmentResultsFilteredByRank.addAll(assessmentResults);
    }

    // after filtering by rank, filter by date
    for (AssessmentResults assessmentResult in assessmentResultsFilteredByRank) {
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
    // get all assessment variables from the latest assessment period
    // if the chart is not initialized yet
    // if the chart is already initialized, no need to get the assessment variables again
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
        AssessmentVariables.keyCategory: assessmentVariable.category,
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
        AssessmentVariables.keyCategory: humanfactorAssessmentVariable.category,
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

        for(int j = 0; j < mapOfHumanFactorAssessmentVariableResultsCount.length; j++) {

          if(assessmentResult.variableResults[i].assessmentVariableId == mapOfHumanFactorAssessmentVariableResultsCount[j][AssessmentVariables.keyId]) {
            if(assessmentResult.variableResults[i].assessmentType == AssessmentVariables.keySatisfactory) {
              switch(assessmentResult.variableResults[i].assessmentMarkers){
                case 1:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['Markers 1']++;
                  break;
                case 2:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['Markers 2']++;
                  break;
                case 3:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['Markers 3']++;
                  break;
                case 4:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['Markers 4']++;
                  break;
                case 5:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['Markers 5']++;
                  break;
                default:
                  break;
              }
            }
            else {
              switch(assessmentResult.variableResults[i].pilotFlyingMarkers) {
                case 1:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PF Markers 1']++;
                  break;
                case 2:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PF Markers 2']++;
                  break;
                case 3:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PF Markers 3']++;
                  break;
                case 4:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PF Markers 4']++;
                  break;
                case 5:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PF Markers 5']++;
                  break;
                default:
                  break;
              }

              switch(assessmentResult.variableResults[i].pilotMonitoringMarkers) {
                case 1:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PM Markers 1']++;
                  break;
                case 2:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PM Markers 2']++;
                  break;
                case 3:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PM Markers 3']++;
                  break;
                case 4:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PM Markers 4']++;
                  break;
                case 5:
                  mapOfHumanFactorAssessmentVariableResultsCount[j]['PM Markers 5']++;
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
      mapOfHumanFactorAssessmentVariableResultsCount = mapOfHumanFactorAssessmentVariableResultsCount;
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
      filterAssessmentResults();
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
      filterAssessmentResults();
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
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        "Analytics",
                        style: tsOneTextTheme.headlineLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
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
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Text(
                                "- to -",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextField(
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: DropdownButtonFormField(
                        value: rank,
                        items: rankList.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            rank = newValue.toString();
                          });
                          filterAssessmentResults();
                        },
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Rank',
                          focusColor: TsOneColor.primary,
                        ),
                      ),
                    ),
                    model.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        children: [
                          Text("Currently showing analytics of ${assessmentResultsFilteredByDate.length} assessment results for "
                              "${rank == rankList[0] ? "all ranks" : "the rank of $rank"} "
                              "from ${Util.convertDateTimeDisplay(startDate.toString(), "dd MMM yyyy")} "
                              "to ${Util.convertDateTimeDisplay(endDate.toString(), "dd MMM yyyy")}."),
                          chartLoading? const Padding(
                            padding: EdgeInsets.only(top: 16.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ) : Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Main Assessment',
                                  style: tsOneTextTheme.headlineMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                                  child: LegendsListWidget(
                                    legends: [
                                      Legend('Markers 1', Colors.red),
                                      Legend('Markers 2', Colors.yellow),
                                      Legend('Markers 3', Colors.green),
                                      Legend('Markers 4', Colors.blue),
                                      Legend('Markers 5', Colors.purple),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 4800,
                                    height: 600,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0, bottom: 45.0, left: 0.0),
                                      child: barChartMainAssessment,
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  'Human Factor Assessment - Pilot Flying',
                                  style: tsOneTextTheme.headlineMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                                  child: LegendsListWidget(
                                    legends: [
                                      Legend('Markers 1', Colors.red),
                                      Legend('Markers 2', Colors.yellow),
                                      Legend('Markers 3', Colors.green),
                                      Legend('Markers 4', Colors.blue),
                                      Legend('Markers 5', Colors.purple),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 2000,
                                    height: 600,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0, bottom: 45.0, left: 0.0),
                                      child: barChartHumanFactorPFAssessment,
                                    ),
                                  ),
                                ),

                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 32.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Divider(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Text(
                                  'Human Factor Assessment - Pilot Monitoring',
                                  style: tsOneTextTheme.headlineMedium,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, right: 16.0, left: 16.0),
                                  child: LegendsListWidget(
                                    legends: [
                                      Legend('Markers 1', Colors.red),
                                      Legend('Markers 2', Colors.yellow),
                                      Legend('Markers 3', Colors.green),
                                      Legend('Markers 4', Colors.blue),
                                      Legend('Markers 5', Colors.purple),
                                    ],
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: SizedBox(
                                    width: 2000,
                                    height: 600,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 30.0, bottom: 45.0, left: 0.0),
                                      child: barChartHumanFactorPMAssessment,
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
                        offset: const Offset(-40, 10),
                        child: Transform.rotate(
                          angle: -3.14 / 4,
                          child: SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  mapOfAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyCategory],
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  )
                                ),
                                Text(
                                  mapOfAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyName],
                                )
                              ],
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
        groupsSpace: 52,
        barGroups: [
          for (var i = 0; i < mapOfAssessmentVariableResultsCount.length; i++)
            BarChartGroupData(
              // showingTooltipIndicators: mapOfAssessmentVariableResultsCount[i]['Name'],
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
            direction: TooltipDirection.bottom,
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
                "$variableName\n$markerName: ${mapOfAssessmentVariableResultsCount[group.x.toInt()][markerName]}",
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      )
    );
    barChartHumanFactorPFAssessment = BarChart(
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
                        offset: const Offset(-40, 10),
                        child: Transform.rotate(
                          angle: -3.14 / 4,
                          child: SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    mapOfHumanFactorAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyCategory],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Text(
                                  mapOfHumanFactorAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyName],
                                )
                              ],
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
          groupsSpace: 52,
          barGroups: [
            for (var i = 0; i < mapOfHumanFactorAssessmentVariableResultsCount.length; i++)
              BarChartGroupData(
                // showingTooltipIndicators: mapOfHumanFactorAssessmentVariableResultsCount[i]['Name'],
                x: i,
                groupVertically: true,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble(),
                    color: Colors.red,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble(),
                    color: Colors.yellow,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 3'].toDouble(),
                    color: Colors.green,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 3'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 4'].toDouble(),
                    color: Colors.blue,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 4'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 4'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PF Markers 5'].toDouble(),
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
              direction: TooltipDirection.bottom,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String variableName = mapOfHumanFactorAssessmentVariableResultsCount[group.x.toInt()][AssessmentVariables.keyName];
                String markerName = "";
                if (rodIndex == 0) {
                  markerName = "PF Markers 1";
                } else if (rodIndex == 1) {
                  markerName = "PF Markers 2";
                } else if (rodIndex == 2) {
                  markerName = "PF Markers 3";
                } else if (rodIndex == 3) {
                  markerName = "PF Markers 4";
                } else if (rodIndex == 4) {
                  markerName = "PF Markers 5";
                }
                return BarTooltipItem(
                  "$variableName\n$markerName: ${mapOfHumanFactorAssessmentVariableResultsCount[group.x.toInt()][markerName]}",
                  const TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        )
    );
    barChartHumanFactorPMAssessment = BarChart(
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
                        offset: const Offset(-40, 10),
                        child: Transform.rotate(
                          angle: -3.14 / 4,
                          child: SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                    mapOfHumanFactorAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyCategory],
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    )
                                ),
                                Text(
                                  mapOfHumanFactorAssessmentVariableResultsCount[value.toInt()][AssessmentVariables.keyName],
                                )
                              ],
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
          groupsSpace: 52,
          barGroups: [
            for (var i = 0; i < mapOfHumanFactorAssessmentVariableResultsCount.length; i++)
              BarChartGroupData(
                // showingTooltipIndicators: mapOfHumanFactorAssessmentVariableResultsCount[i]['Name'],
                x: i,
                groupVertically: true,
                barRods: [
                  BarChartRodData(
                    fromY: 0,
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble(),
                    color: Colors.red,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble(),
                    color: Colors.yellow,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 3'].toDouble(),
                    color: Colors.green,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 3'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 4'].toDouble(),
                    color: Colors.blue,
                    width: barWidth,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(6),
                      topRight: Radius.circular(6),
                    ),
                  ),
                  BarChartRodData(
                    fromY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 4'].toDouble(),
                    toY: mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 1'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 2'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 3'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 4'].toDouble()
                        + mapOfHumanFactorAssessmentVariableResultsCount[i]['PM Markers 5'].toDouble(),
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
              direction: TooltipDirection.bottom,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                String variableName = mapOfHumanFactorAssessmentVariableResultsCount[group.x.toInt()][AssessmentVariables.keyName];
                String markerName = "";
                if (rodIndex == 0) {
                  markerName = "PM Markers 1";
                } else if (rodIndex == 1) {
                  markerName = "PM Markers 2";
                } else if (rodIndex == 2) {
                  markerName = "PM Markers 3";
                } else if (rodIndex == 3) {
                  markerName = "PM Markers 4";
                } else if (rodIndex == 4) {
                  markerName = "PM Markers 5";
                }
                return BarTooltipItem(
                  "$variableName\n$markerName: ${mapOfHumanFactorAssessmentVariableResultsCount[group.x.toInt()][markerName]}",
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
