import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/routes.dart';
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
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
        ),
        body: Center(
          child: Column(
            children: [
              const Text("Profile Screen"),
              Text("Email: ${userPreferences.getEmail()}"),
              ElevatedButton(
                onPressed: () {
                  viewModel.logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, NamedRoute.login, (route) => false);
                },
                child: const Text("Logout"),
              ),
              /** TEMPORARY, DELETE AFTER DEBUGGING AllAssessmentPeriods **/
              ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, NamedRoute.allAssessmentPeriods);
                  },
                  child: const Text("All Assessment Periods")
              )
            ],
          ),
        ),
      );
    });
  }
}
