import 'package:flutter/material.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/shared_components/card_user.dart';
import 'package:ts_one/presentation/shared_components/search_component.dart';
import 'package:ts_one/presentation/theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime? _filterDateTime;
  late UserPreferences userPreferences;

  @override
  void initState() {
    userPreferences = getItLocator<UserPreferences>();
    super.initState();
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
                Text(
                  "Assessment History",
                  style: tsOneTextTheme.headlineLarge
                ),
                userPreferences.getPrivileges().contains(UserModel.keyPrivilegeManageFormAssessment) ?
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, NamedRoute.allAssessmentPeriods);
                        },
                        icon: const Icon(Icons.feed, size: 32.0,)
                    ),
                    IconButton(
                        onPressed: () {

                        },
                        icon: const Icon(Icons.download, size: 32.0,)
                    )
                  ],
                )
                    :
                Container()
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
                      showDateRangePicker(
                          locale: const Locale('en'),
                          cancelText: 'Cancel',
                          context: context,
                          currentDate: DateTime.now(),
                          firstDate: DateTime(2010),
                          lastDate: DateTime(2100),
                          saveText: 'OK')
                          .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                            Text("${value!.start} dan ${value.end}"),
                          ),
                        ),
                      });
                    },
                    icon: const Icon(Icons.filter_alt, size: 32.0,)
                )
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return const CardUser();
                },
                itemCount: 10,
              ),
            )
          ],
        ),
      ),
    );
  }
}
