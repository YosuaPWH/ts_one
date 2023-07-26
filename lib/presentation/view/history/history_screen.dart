import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/domain/assessment_results_repo.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/card_user.dart';
import 'package:ts_one/presentation/shared_components/search_component.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _filterDateTime;
  late UserPreferences userPreferences;
  late String rankUser;
  String _sortBy = "initial";
  late AssessmentResultsViewModel viewModel;

  final int _limit = 10;

  final PagingController<int, AssessmentResults> _pagingController = PagingController(firstPageKey: 0);

  @override
  void initState() {
    userPreferences = getItLocator<UserPreferences>();
    _pagingController.addPageRequestListener((pageKey) {
      _fetchData(pageKey, _limit);
    });

    // This is to reset the lastDocument on AssessmentResultsRepoImpl so reset data sorting
    AssessmentResultsRepoImpl.lastDocument = null;

    switch (userPreferences.getIDNo()) {
      case 1000854:
        rankUser = 'CPTS';
        break;
      default:
        rankUser = 'Pilot';
        break;
    }

    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);

    super.initState();
  }

  Future<void> _fetchData(int startAt, int limit) async {
    try {
      final List<AssessmentResults> newItems = await viewModel.getAllAssessmentResultsPaging(startAt, _sortBy);
      for (var element in newItems) {
        element.isFromHistory = true;
      }

      final isLastPage = newItems.length < limit;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = startAt + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Assessment History", style: tsOneTextTheme.headlineLarge),
                userPreferences.getPrivileges().contains(UserModel.keyPrivilegeViewAllAssessments)
                    ? Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pushNamed(context, NamedRoute.allAssessmentPeriods);
                              },
                              icon: const Icon(
                                Icons.feed,
                                size: 32.0,
                                // color: TsOneColor.primary,
                              )),
                          /*
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.download,
                                size: 32.0,
                              ))
                          */
                        ],
                      )
                    : Container()
              ],
            ),
            Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: SearchComponent(),
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
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text("${value!.start} dan ${value.end}"),
                                            ),
                                          ),
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
            Expanded(
              child: PagedListView<int, AssessmentResults>(
                pagingController: _pagingController,
                builderDelegate: PagedChildBuilderDelegate<AssessmentResults>(
                  itemBuilder: (context, item, index) => CardUser(
                    assessmentResults: item,
                  ),
                ),
              ),
            ),
          ],
        ),
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
                  _pagingController.refresh();
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Rank'),
                onTap: () {
                  setState(() {
                    _sortBy = AssessmentResults.keyRankExaminee;
                  });
                  _pagingController.refresh();
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
