import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class DetailUserView extends StatefulWidget {
  const DetailUserView({Key? key, required this.userEmail}) : super(key: key);

  final String userEmail;

  @override
  State<DetailUserView> createState() => _DetailUserViewState();
}

class _DetailUserViewState extends State<DetailUserView> {
  late UserViewModel viewModel;
  late UserModel user;
  late String userEmail;

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    user = UserModel();
    userEmail = widget.userEmail;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserByEmail();
    });

    super.initState();
  }

  getUserByEmail() async {
    user = await viewModel.getUserByEmail(userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        getUserByEmail();
      },
      child: Consumer<UserViewModel>(
        builder: (_, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: user.name == Util.defaultStringIfNull
                  ? const Center(child: CircularProgressIndicator())
                  : Column(
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
                                        child: Image.asset(
                                            'assets/images/placeholder_person.png'),
                                      ),
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        user.name,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                          color: TsOneColor.onSurface,
                                          fontFamily: 'Poppins',
                                          decorationColor: TsOneColor.primary,
                                        ),
                                      ),
                                      Text(
                                        user.staffNo,
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0, left: 16.0),
                                          child: Text("Email",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 16.0),
                                        child: Text(user.email,
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0, left: 16.0),
                                          child: Text("Position",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 16.0),
                                        child: Text(user.position,
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0, left: 16.0),
                                          child: Text("Sub Position",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 16.0),
                                        child: Text(user.getSubPositionString(),
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0, left: 16.0),
                                          child: Text("License No",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 16.0),
                                        child: Text(user.licenseNo,
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0, left: 16.0),
                                          child: Text("License Expiry",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, right: 16.0),
                                        child: Text(
                                            Util.convertDateTimeDisplay(
                                                user.licenseExpiry.toString(),
                                                "dd MMMM yyyy"),
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Padding(
                                          padding: EdgeInsets.only(
                                              top: 16.0,
                                              bottom: 16.0,
                                              left: 16.0),
                                          child: Text("License Last Passed",
                                              style: TextStyle(
                                                color: TsOneColor.onPrimary,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'Poppins',
                                              ))),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 16.0, bottom: 16.0, right: 16.0),
                                        child: Text(
                                            Util.convertDateTimeDisplay(
                                                user.licenseLastPassed.toString(),
                                                "dd MMMM yyyy"),
                                            style: const TextStyle(
                                              color: TsOneColor.onPrimary,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              fontFamily: 'Poppins',
                                            )),
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
                        )),
                      ],
                    ),
            ),
            floatingActionButtonLocation: ExpandableFab.location,
            floatingActionButton: ExpandableFab(
              backgroundColor: TsOneColor.primary,
              children: [
                FloatingActionButton(
                  heroTag: "buttonEdit",
                  onPressed: () {
                    Navigator.pushNamed(
                        context, NamedRoute.updateUser,
                        arguments: user.email);
                  },
                  backgroundColor: TsOneColor.primary,
                  child: const Icon(Icons.edit),
                ),
                FloatingActionButton(
                  heroTag: "buttonDelete",
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Delete data of ${user.name}?"),
                          content: const Text(
                              "You will not be able to retrieve this data anymore. "
                              "Are you sure you want to delete this data?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await model.deleteUserByEmail(user.email);
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  backgroundColor: TsOneColor.primary,
                  child: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
