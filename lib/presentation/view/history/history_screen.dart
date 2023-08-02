import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/routes.dart';
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
  late AssessmentResultsViewModel viewModel;

  final int _limit = 10;

  int searchLimit = 10;

  String _allSortBy = "";
  late bool isSearchingAll;
  late List<AssessmentResults> allAssessment;
  late ScrollController _allScrollController;
  late List<AssessmentResults> searchedAssessment;

  late List<AssessmentResults> selfAssessment;

  String _mySortBy = "";
  late bool isSearchingMy;
  late List<AssessmentResults> myAssessment;
  late List<AssessmentResults> myAssessmentSearched;
  late ScrollController _myScrollController;

  int selectedTabHistoryIndex = 0;

  late bool _isCPTS;
  late bool _isInstructor;

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

    isSearchingAll = false;
    searchedAssessment = [];
    allAssessment = [];
    _allScrollController = ScrollController();
    _allScrollController.addListener(_scrollListener);

    selfAssessment = [];

    isSearchingMy = false;
    myAssessment = [];
    myAssessmentSearched = [];
    _myScrollController = ScrollController();
    _myScrollController.addListener(_scrollListenerMy);

    _isCPTS = false;
    _isInstructor = false;

    checkCPTS();
    checkInstructor();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //
    // });

    super.initState();
  }

  void _scrollListener() {
    if (_allScrollController.position.pixels == _allScrollController.position.maxScrollExtent) {
      getAllAssessments();
    }
  }

  void _scrollListenerMy() {
    if (_myScrollController.position.pixels == _myScrollController.position.maxScrollExtent) {
      getMyAssessment();
    }
  }

  @override
  void dispose() {
    _allScrollController.removeListener(_scrollListener);
    _allScrollController.dispose();
    _myScrollController.removeListener(_scrollListenerMy);
    _myScrollController.dispose();
    super.dispose();
  }

  void allSortAssessmentBy() async {
    switch (_allSortBy) {
      case AssessmentResults.keyNameExaminee:
        allAssessment.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        searchedAssessment.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        break;
      case AssessmentResults.keyRank:
        allAssessment.sort((a, b) => a.rank.compareTo(b.rank));
        searchedAssessment.sort((a, b) => a.rank.compareTo(b.rank));
      case AssessmentResults.keyDate:
        allAssessment.sort((a, b) => b.date.compareTo(a.date));
        searchedAssessment.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void mySortAssessmentBy() async {
    switch (_mySortBy) {
      case AssessmentResults.keyNameExaminee:
        myAssessment.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        myAssessmentSearched.sort((a, b) => a.examineeName.compareTo(b.examineeName));
        break;
      case AssessmentResults.keyRank:
        myAssessment.sort((a, b) => a.rank.compareTo(b.rank));
        myAssessmentSearched.sort((a, b) => a.rank.compareTo(b.rank));
      case AssessmentResults.keyDate:
        myAssessment.sort((a, b) => b.date.compareTo(a.date));
        myAssessmentSearched.sort((a, b) => b.date.compareTo(a.date));
    }
  }

  void filterByDate() async {
    if (_filterDateTimeStart != null && _filterDateTimeEnd != null) {
      log("JALAN GAK SIH");
      allAssessment = await viewModel.getAllAssessmentResultsPaginated(_limit, _filterDateTimeStart, _filterDateTimeEnd);
      // _filterDateTimeStart = null;
      // _filterDateTimeEnd = null;
      log("GAK TAHU GAK SIH");
      // searchedAssessment = await viewModel.filterAssessmentResultsByDate(_filterDateTime!);
    }
  }

  // ================================================================================================================
  void getAllAssessments() async {
    log("${_filterDateTimeStart.toString()} - ${_filterDateTimeEnd.toString()}");
    allAssessment = await viewModel.getAllAssessmentResultsPaginated(_limit, _filterDateTimeStart, _filterDateTimeEnd);
    log("allAssessment 159: ${allAssessment.length}");
  }

  void searchAssessmentBasedOnName(String searchName) async {
    searchedAssessment = await viewModel.searchAssessmentResultsBasedOnName(searchName, searchLimit);
  }

  // ====================================================================================================
  void getSelfAssessment() async {
    selfAssessment = await viewModel.getSelfAssessmentResultsPaginated();
  }

  // ================================================================================================
  void getMyAssessment() async {
    myAssessment = await viewModel.getMyAssessmentResultsPaginated();
    log("myAssessment: ${myAssessment.length}");
  }

  void searchMyAssessmentBasedOnName(String searchName) async {
    myAssessmentSearched = await viewModel.searchAssessmentResultsBasedOnName(searchName, searchLimit);
  }

  void checkCPTS() async {
    if (userPreferences.getPrivileges().contains(UserModel.keyPrivilegeViewAllAssessments) &&
        userPreferences.getInstructor().contains(UserModel.keyCPTS)) {
      _isCPTS = true;
    }
  }

  void checkInstructor() async {
    if (userPreferences.getPrivileges().contains(UserModel.keyPrivilegeCreateAssessment)) {
      _isInstructor = true;
    }
  }

  List<Widget> menuCPTS() {
    return [
      tabViewAll(),
      tabViewSelf(),
    ];
  }

  List<Widget> menuInstructor() {
    return [
      tabMyAssessment(),
      tabViewSelf(),
    ];
  }

  List<Widget> menuGod() {
    return [
      tabViewAll(),
      tabMyAssessment(),
      tabViewSelf(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (_isCPTS && _isInstructor) {
          getAllAssessments();
          getMyAssessment();
        } else if (_isInstructor) {
          getMyAssessment();
        } else if (_isCPTS) {
          getAllAssessments();
        }
        getSelfAssessment();
      },
      child: Consumer<AssessmentResultsViewModel>(
        builder: (_, model, child) {
          return SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: DefaultTabController(
                    length: _isCPTS && _isInstructor ? 3 : _isCPTS || _isInstructor ? 2 : 1,
                    child: Scaffold(
                      appBar: AppBar(
                        systemOverlayStyle: const SystemUiOverlayStyle(
                            statusBarColor: TsOneColor.primary
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Assessment History",
                              style: TextStyle(color: TsOneColor.secondary),
                            ),
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
                                      color: TsOneColor.secondary,
                                    )),
                              ],
                            )
                                : Container()
                          ],
                        ),
                        backgroundColor: TsOneColor.primary,
                        elevation: 0,
                        bottom: TabBar(
                          labelColor: TsOneColor.primary,
                          unselectedLabelColor: TsOneColor.secondary,
                          indicator: const BoxDecoration(
                            borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                            color: TsOneColor.secondary,
                          ),
                          tabs: [
                            if (_isCPTS)
                              const Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text("All"),
                                ),
                              ),
                            if (_isInstructor)
                              const Tab(
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    "My Assessment",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            const Tab(
                              child: Align(
                                alignment: Alignment.center,
                                child: Text("Self"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      body: TabBarView(
                        children: _isCPTS && _isInstructor
                            ? menuGod()
                            : _isCPTS
                              ? menuCPTS()
                              : _isInstructor
                                ? menuInstructor()
                                : [tabViewSelf()],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================================================ ALL ASSESSMENT ================================================================
  Widget tabViewAll() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onTapOutside: (event) {
                      setState(() {
                        isSearchingAll = false;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        value = value.toTitleCase();

                        setState(() {
                          isSearchingAll = true;
                        });
                        log("searching for $value");
                        searchAssessmentBasedOnName(value);
                      } else {
                        getAllAssessments();
                        log("EMMTPY");
                        setState(() {
                          isSearchingAll = false;
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
                                    _openSortByModalBottomSheet(context, true);
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
                                          (value) =>
                                      {
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
                                      _allSortBy = AssessmentResults.keyDate;
                                      _filterDateTimeStart = null;
                                      _filterDateTimeEnd = null;
                                    });

                                    viewModel.allAssessmentResults = [];
                                    viewModel.isAllAssessmentLoaded = false;
                                    viewModel.lastAssessment = null;

                                    getAllAssessments();
                                    getMyAssessment();

                                    allSortAssessmentBy();
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
          !isSearchingAll
              ? Expanded(
            child: allAssessment.isNotEmpty
                ? ListView.builder(
                shrinkWrap: true,
                controller: _allScrollController,
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
                        Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables,
                            arguments: allAssessment[index]);
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
                                      allAssessment[index].examineeStaffIDNo.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      allAssessment[index].rank.toString(),
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
              child: Text('No assessment founded'),
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
                        Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables,
                            arguments: searchedAssessment[index]);
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
                                      searchedAssessment[index].examineeStaffIDNo.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      searchedAssessment[index].rank.toString(),
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
    );
  }

  // ================================================ SELF ASSESSMENT ================================================================
  Widget tabViewSelf() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: viewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : selfAssessment.isNotEmpty
          ? ListView.builder(
        shrinkWrap: true,
        itemCount: selfAssessment.length,
        itemBuilder: (context, index) {
          return Card(
            surfaceTintColor: TsOneColor.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables,
                    arguments: selfAssessment[index]);
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
                              selfAssessment[index].examineeName.toString(),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              selfAssessment[index].examineeStaffIDNo.toString(),
                              style: const TextStyle(fontWeight: FontWeight.normal),
                            ),
                            Text(
                              selfAssessment[index].rank.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(Util.convertDateTimeDisplay(selfAssessment[index].date.toString())),
                  ],
                ),
              ),
            ),
          );
        },
      )
          : const Center(child: Text("No assessment found")),
    );
  }

  // ================================================ MY ASSESSMENT ================================================================
  Widget tabMyAssessment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: TextField(
                    onTapOutside: (event) {
                      setState(() {
                        isSearchingMy = false;
                      });
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        value = value.toTitleCase();

                        // setState(() {
                        //   isSearchingMy = true;
                        // });
                        log("searching for $value");
                        // searchAssessmentBasedOnName(value);
                      } else {
                        // getAllAssessments();
                        log("EMMTPY");
                        // setState(() {
                        //   isSearchingMy = false;
                        // });
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
                                    _openSortByModalBottomSheet(context, false);
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
                                          (value) =>
                                      {
                                        if (value != null)
                                          {
                                            log("date range: ${value.start} - ${value.end}"),
                                            // setState(() {
                                            //   _filterDateTimeStart = value.start;
                                            //   _filterDateTimeEnd = value.end;
                                            // }),
                                            // filterByDate()
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
                                      _mySortBy = AssessmentResults.keyDate;
                                      _filterDateTimeStart = null;
                                      _filterDateTimeEnd = null;
                                    });

                                    viewModel.allAssessmentResults = [];
                                    viewModel.isAllAssessmentLoaded = false;
                                    viewModel.lastAssessment = null;

                                    getMyAssessment();

                                    mySortAssessmentBy();
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
          !isSearchingMy
              ? Expanded(
            child: myAssessment.isNotEmpty
                ? ListView.builder(
                shrinkWrap: true,
                controller: _myScrollController,
                itemCount: myAssessment.length,
                itemBuilder: (context, index) {
                  if (index == myAssessment.length - 1 && !viewModel.isAllAssessmentLoaded) {
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
                        Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables,
                            arguments: myAssessment[index]);
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
                                      myAssessment[index].examineeName.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      myAssessment[index].examineeStaffIDNo.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      myAssessment[index].rank.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(Util.convertDateTimeDisplay(myAssessment[index].date.toString())),
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
                ? myAssessmentSearched.isNotEmpty
                ? ListView.builder(
                shrinkWrap: true,
                itemCount: myAssessmentSearched.length,
                itemBuilder: (context, index) {
                  return Card(
                    surfaceTintColor: TsOneColor.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables,
                            arguments: myAssessmentSearched[index]);
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
                                      myAssessmentSearched[index].examineeName.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      myAssessmentSearched[index].examineeStaffIDNo.toString(),
                                      style: const TextStyle(fontWeight: FontWeight.normal),
                                    ),
                                    Text(
                                      myAssessmentSearched[index].rank.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Text(
                                Util.convertDateTimeDisplay(myAssessmentSearched[index].date.toString())),
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
    );
  }

  void _openSortByModalBottomSheet(BuildContext context, bool isFromAll) {
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
                  if (isFromAll) {
                    setState(() {
                      _allSortBy = AssessmentResults.keyNameExaminee;
                    });
                  } else {
                    setState(() {
                      _mySortBy = AssessmentResults.keyNameExaminee;
                    });
                  }

                  if (isFromAll) {
                    allSortAssessmentBy();
                  } else {
                    mySortAssessmentBy();
                  }

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Rank'),
                onTap: () {
                  if (isFromAll) {
                    setState(() {
                      _allSortBy = AssessmentResults.keyRank;
                    });
                  } else {
                    setState(() {
                      _mySortBy = AssessmentResults.keyRank;
                    });
                  }

                  if (isFromAll) {
                    allSortAssessmentBy();
                  } else {
                    mySortAssessmentBy();
                  }

                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Markers'),
                onTap: () {
                  if (isFromAll) {
                    setState(() {
                      _allSortBy = AssessmentResults.keyRank;
                    });
                  } else {
                    setState(() {
                      _mySortBy = AssessmentResults.keyRank;
                    });
                  }
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
