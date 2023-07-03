import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/di/locator.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: TsOneColor.surface,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: TsOneColor.secondaryContainer,
                              blurRadius: 10,
                              spreadRadius: -5,
                              offset: Offset(1, 1),
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                        ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              // Image border
                              child: SizedBox(
                                height: 200.0,
                                child: Image.network(userPreferences.getPhotoURL()),
                              ),
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                userPreferences.getName(),
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: TsOneColor.onSurface,
                                  fontFamily: 'Poppins',
                                  decorationColor: TsOneColor.primary,
                                ),
                              ),
                              Text(
                                userPreferences.getPosition(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: TsOneColor.onSurface,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                              Text(
                                userPreferences.getStaffNo(),
                                style: const TextStyle(
                                  color: TsOneColor.onSurface,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: TsOneColor.primary,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: TsOneColor.primary,
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: TsOneColor.secondaryContainer,
                            blurRadius: 15,
                            spreadRadius: -5,
                            offset: Offset(-2, 1),
                            blurStyle: BlurStyle.normal,
                          ),
                        ],
                      ),
                      child: Column(
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 16.0, left: 16.0),
                                  child: Text(
                                      "License No.",
                                      style: TextStyle(
                                        color: TsOneColor.onPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Poppins',
                                      )
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                                  child: Text(
                                    userPreferences.getLicenseNo(),
                                    style: const TextStyle(
                                      color: TsOneColor.onPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: 'Poppins',
                                    )
                                  ),
                                ),
                              ],
                           ),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 16.0),
                                    child: Text(
                                        "License Expiry",
                                        style: TextStyle(
                                          color: TsOneColor.onPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'Poppins',
                                        )
                                    )
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0, right: 16.0),
                                    child: Text(
                                      Util.convertDateTimeDisplay(userPreferences.getLicenseExpiry().toString(), "dd MMMM yyyy"),
                                      style: const TextStyle(
                                        color: TsOneColor.onPrimary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: 'Poppins',
                                      )
                                    ),
                                  ),
                                ],
                           ),
                         ],
                      ),
                    ),
                  ),
                ),
                const Expanded(
                  // flex: 0,
                    child: SizedBox(
                      height: 16,
                    )
                ),
                ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tsOneColorScheme.secondary,
                      foregroundColor: tsOneColorScheme.secondaryContainer,
                      surfaceTintColor: tsOneColorScheme.secondary,
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text("Manage User"),
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
              ],
            ),
          ),
        ),
      );
    });
  }
}
