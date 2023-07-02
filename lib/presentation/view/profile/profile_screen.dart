import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserViewModel viewModel;
  late UserPreferences userPreferences;

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    userPreferences = getItLocator<UserPreferences>();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(builder: (_, model, child) {
      return SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(
              16.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          // Image border
                          child: SizedBox.fromSize(
                            size: const Size.fromRadius(48), // Image radius
                            child:
                            Image.network(userPreferences.getPhotoURL()),
                          ),
                        ),
                      )),
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userPreferences.getName(),
                            style: tsOneTextTheme.headlineLarge,
                          ),
                          Text(
                            userPreferences.getPosition(),
                            style: tsOneTextTheme.labelMedium,
                          ),
                          Text(userPreferences.getStaffNo()),
                        ],
                      ))
                ]),
                const Expanded(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    viewModel.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, NamedRoute.login, (route) => false);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tsOneColorScheme.secondary,
                    foregroundColor: tsOneColorScheme.secondaryContainer,
                    surfaceTintColor: tsOneColorScheme.secondary,
                    minimumSize: const Size.fromHeight(40),
                  ),
                  child: const Text("Logout"),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, NamedRoute.allAssessmentPeriods);
                    },
                    child: const Text("All Assessment Periods")
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
