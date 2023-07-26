import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/assessments/assessment_variable_results.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/domain/assessment_results_repo.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/card_user.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _filterDateTimeStart;
  DateTime? _filterDateTimeEnd;
  late UserPreferences userPreferences;
  late String rankUser;
  String _sortBy = "";
  late AssessmentResultsViewModel viewModel;

  final int _limit = 10;

  late bool isSearching;
  late List<AssessmentResults> searchedAssessment;
  int searchLimit = 10;

  late List<AssessmentResults> allAssessment;
  late ScrollController _scrollController;

  @override
  void initState() {
    userPreferences = getItLocator<UserPreferences>();
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);

    switch (userPreferences.getIDNo()) {
      case 1000854:
        rankUser = 'CPTS';
        break;
      default:
        rankUser = 'Pilot';
        break;
    }

    isSearching = false;
    searchedAssessment = [];
    allAssessment = [];
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      getAllAssessments();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void sortAssessmentBy() async {
    switch (_sortBy) {
      case AssessmentResults.keyNameExaminee:
        allAssessment.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        searchedAssessment.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        break;
      case AssessmentResults.keyRankExaminee:
        allAssessment.sort((a, b) => a.examineeRank.compareTo(b.examineeRank));
        searchedAssessment.sort((a, b) => a.examineeRank.compareTo(b.examineeRank));
      case AssessmentResults.keyDate:
        allAssessment.sort((a, b) => b.date.compareTo(a.date));
        searchedAssessment.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void filterByDate() async {
    if (_filterDateTimeStart != null && _filterDateTimeEnd != null) {
      log("JALAN GAK SIH");
      allAssessment = await viewModel.getAllAssessmentResultsPaginated(_limit, _filterDateTimeStart, _filterDateTimeEnd);
      _filterDateTimeStart = null;
      _filterDateTimeEnd = null;
      log("GAK TAHU GAK SIH");
      // searchedAssessment = await viewModel.filterAssessmentResultsByDate(_filterDateTime!);
    }
  }

  void getAllAssessments() async {
    allAssessment = await viewModel.getAllAssessmentResultsPaginated(_limit, null, null);
  }

  void searchAssessmentBasedOnName(String searchName) async {
    searchedAssessment = await viewModel.searchAssessmentResultsBasedOnName(searchName, searchLimit);
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        getAllAssessments();
      },
      child: Consumer<AssessmentResultsViewModel>(
        builder: (_, model, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Assessment History", style: tsOneTextTheme.headlineLarge),
                      userPreferences.getPrivileges().contains(UserModel.keyPrivilegeManageFormAssessment)
                          ? Row(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, NamedRoute.allAssessmentPeriods);
                                    },
                                    icon: const Icon(
                                      Icons.feed,
                                      size: 32.0,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, NamedRoute.template);
                                    },
                                    icon: const Icon(
                                      Icons.download,
                                      size: 32.0,
                                    ))
                              ],
                            )
                          : Container()
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: TextField(
                            onTapOutside: (event) {
                              setState(() {
                                isSearching = false;
                              });
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                value = value.toTitleCase();

                                setState(() {
                                  isSearching = true;
                                });
                                log("searching for $value");
                                searchAssessmentBasedOnName(value);
                              } else {
                                getAllAssessments();
                                log("EMMTPY");
                                setState(() {
                                  isSearching = false;
                                });
                              }
                            },
                            cursorColor: TsOneColor.primary,
                            decoration: InputDecoration(
                                fillColor: TsOneColor.onPrimary,
                                filled: true,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  borderSide: const BorderSide(color: TsOneColor.primary),
                                ),
                                hintText: 'Search...',
                                hintStyle: const TextStyle(
                                  color: TsOneColor.onSecondary,
                                ),
                                prefixIcon: Container(
                                  padding: const EdgeInsets.all(16),
                                  width: 32,
                                  child: const Icon(Icons.search),
                                )),
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ListTile(
                                          trailing: const Icon(Icons.sort),
                                          title: const Text('Sort by'),
                                          onTap: () {
                                            Navigator.pop(context);
                                            _openSortByModalBottomSheet(context);
                                          },
                                        ),
                                        ListTile(
                                          trailing: const Icon(Icons.date_range),
                                          title: const Text('Filter by date'),
                                          onTap: () {
                                            Navigator.pop(context);

                                            showDateRangePicker(
                                              context: context,
                                              firstDate: DateTime(2010),
                                              lastDate: DateTime(2100),
                                              saveText: 'OK',
                                            ).then(
                                              (value) => {
                                                if (value != null)
                                                  {
                                                    log("date range: ${value.start} - ${value.end}"),
                                                    setState(() {
                                                      _filterDateTimeStart = value.start;
                                                      _filterDateTimeEnd = value.end;
                                                    }),
                                                    filterByDate()
                                                  }
                                              },
                                            );
                                          },
                                        ),
                                        ListTile(
                                          titleAlignment: ListTileTitleAlignment.center,
                                          title: const Align(
                                            alignment: Alignment.center,
                                            child: Text('Clear filter'),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              _sortBy = AssessmentResults.keyDate;
                                            });
                                            sortAssessmentBy();
                                            Navigator.pop(context);
                                          },
                                        )
                                      ],
                                    ),
                                  );
                                });
                          },
                          icon: const Icon(
                            Icons.filter_alt,
                            size: 32.0,
                          ))
                    ],
                  ),
                  !isSearching
                      ? Expanded(
                          child: allAssessment.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  controller: _scrollController,
                                  itemCount: allAssessment.length,
                                  itemBuilder: (context, index) {
                                    if (index == allAssessment.length - 1 && !viewModel.isAllAssessmentLoaded) {
                                      return const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      );
                                    }
                                    return Card(
                                      surfaceTintColor: TsOneColor.surface,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables, arguments: allAssessment[index]);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              CircleAvatar(
                                                radius: 30,
                                                backgroundColor: Colors.white,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(50),
                                                  child: Image.asset("assets/images/placeholder_person.png"),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        allAssessment[index].examineeName.toString(),
                                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                                      ),
                                                      Text(
                                                        allAssessment[index].examinerStaffIDNo.toString(),
                                                        style: const TextStyle(fontWeight: FontWeight.normal),
                                                      ),
                                                      Text(
                                                        allAssessment[index].examineeRank.toString(),
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.normal,
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Text(Util.convertDateTimeDisplay(allAssessment[index].date.toString())),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  })
                              : viewModel.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : const Center(
                                      child: Text('No assessment found'),
                                    ),
                        )
                      : Expanded(
                          child: !viewModel.isLoading
                              ? searchedAssessment.isNotEmpty
                                  ? ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: searchedAssessment.length,
                                      itemBuilder: (context, index) {
                                        return Card(
                                          surfaceTintColor: TsOneColor.surface,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables, arguments: searchedAssessment[index]);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: <Widget>[
                                                  CircleAvatar(
                                                    radius: 30,
                                                    backgroundColor: Colors.white,
                                                    child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(50),
                                                      child: Image.asset("assets/images/placeholder_person.png"),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Padding(
                                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text(
                                                            searchedAssessment[index].examineeName.toString(),
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          ),
                                                          Text(
                                                            searchedAssessment[index].examinerStaffIDNo.toString(),
                                                            style: const TextStyle(fontWeight: FontWeight.normal),
                                                          ),
                                                          Text(
                                                            searchedAssessment[index].examineeRank.toString(),
                                                            style: const TextStyle(
                                                              fontWeight: FontWeight.normal,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Text(Util.convertDateTimeDisplay(searchedAssessment[index].date.toString())),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      })
                                  : const Center(child: Text("No assessment found"))
                              : const Center(child: CircularProgressIndicator()),
                        )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _openSortByModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Text("Sort by", style: tsOneTextTheme.headlineLarge),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 5.0),
                child: Divider(
                  color: TsOneColor.secondaryContainer,
                ),
              ),
              ListTile(
                title: const Text('Name'),
                onTap: () {
                  setState(() {
                    _sortBy = AssessmentResults.keyNameExaminee;
                  });
                  sortAssessmentBy();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Rank'),
                onTap: () {
                  setState(() {
                    _sortBy = AssessmentResults.keyRankExaminee;
                  });
                  sortAssessmentBy();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Markers'),
                onTap: () {
                  setState(() {
                    _sortBy = "Markers";
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
