import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:googleapis/transcoder/v1.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class NewAssessmentCandidate extends StatefulWidget {
  const NewAssessmentCandidate({super.key});

  @override
  State<NewAssessmentCandidate> createState() => _NewAssessmentCandidateState();
}

class _NewAssessmentCandidateState extends State<NewAssessmentCandidate> {
  late NewAssessment _newAssessment;
  late UserViewModel _userViewModel;
  late List<UserModel> _usersSearched;

  late TextEditingController nameTextController;
  late TextEditingController staffNoTextController;
  late TextEditingController licenseNoTextController;
  late TextEditingController licenseExpiryTextController;
  late TextEditingController otherCrewMemberNameTextController;
  late TextEditingController otherCrewMemberStaffNoTextController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _newAssessment = NewAssessment();
    _userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _usersSearched = [];

    nameTextController = TextEditingController(text: _newAssessment.name);
    staffNoTextController = TextEditingController(text: _newAssessment.staffNo);
    licenseNoTextController = TextEditingController();
    licenseExpiryTextController = TextEditingController();
    otherCrewMemberNameTextController = TextEditingController();
    otherCrewMemberStaffNoTextController = TextEditingController(text: _newAssessment.otherCrewMemberStaffNo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Assessment"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
                      child: TextFormField(
                        controller: TextEditingController(
                          text: Util.convertDateTimeDisplay(
                              _newAssessment.assessmentDate.toString(),
                              "dd MMM yyyy"),
                        ),
                        onTap: () {
                          _showSelectDatePicker(context);
                          FocusScope.of(context).unfocus();
                        },
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Assessment Date',
                          suffixIcon: IconButton(
                            onPressed: () {
                              _showSelectDatePicker(context);
                            },
                            icon: const Icon(Icons.calendar_month_outlined),
                          ),
                        ),
                        readOnly: true,
                      ),
                    ),
                    // name
                    Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TypeAheadFormField<UserModel>(
                          hideSuggestionsOnKeyboardHide: false,
                          onReset: () {
                            _newAssessment.name = "";
                            _newAssessment.staffNo = "";
                            nameTextController.text = "";
                            staffNoTextController.text = "";
                            // refresh the UI
                            setState(() {});
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: nameTextController,
                            onTap: () {
                              // clear the text field
                              nameTextController.clear();
                              staffNoTextController.clear();
                              licenseNoTextController.clear();
                              licenseExpiryTextController.clear();
                              // refresh the UI
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Name',
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            // wait for the user finish typing
                            Future.delayed(const Duration(milliseconds: 500));
                            if(pattern.isNotEmpty) {
                              _usersSearched = await _userViewModel.getUsersBySearchName(pattern.toTitleCase(), 5);
                              return _usersSearched;
                            } else {
                              return [];
                            }
                          },
                          itemBuilder: (context, UserModel suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          noItemsFoundBuilder: (context) {
                            return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    'No users found.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                            );
                          },
                          onSuggestionSelected: (UserModel? suggestion) {
                            if (suggestion != null) {
                              _newAssessment.name = suggestion.name;
                              _newAssessment.staffNo = suggestion.staffNo;

                              nameTextController.text = "${suggestion.position} ${suggestion.name}";
                              staffNoTextController.text = suggestion.staffNo;
                              licenseNoTextController.text = suggestion.licenseNo;
                              licenseExpiryTextController.text = Util.convertDateTimeDisplay(suggestion.licenseExpiry.toString(), "dd MMM yyyy");
                              // refresh the UI
                              setState(() {});
                            }
                          },
                        )
                    ),
                    // staff no
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: staffNoTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Staff Number',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select user by finding name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.staffNo = value;
                        },
                        readOnly: true,
                      ),
                    ),
                    // license no
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: licenseNoTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'License Number',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select user by finding name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.staffNo = value;
                        },
                        readOnly: true,
                      ),
                    ),
                    // license expiry
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: licenseExpiryTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'License Expiry',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select user by finding name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.staffNo = value;
                        },
                        readOnly: true,
                      ),
                    ),
                    // other crew member's name
                    Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: TypeAheadFormField<UserModel>(
                          hideSuggestionsOnKeyboardHide: false,
                          onReset: () {
                            _newAssessment.otherCrewMemberStaffNo = "";

                            otherCrewMemberNameTextController.clear();
                            otherCrewMemberStaffNoTextController.clear();
                            // refresh the UI
                            setState(() {});
                          },
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: otherCrewMemberNameTextController,
                            onTap: () {
                              // clear the text field
                              otherCrewMemberNameTextController.clear();
                              otherCrewMemberStaffNoTextController.clear();
                              // refresh the UI
                              setState(() {});
                            },
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              labelText: 'Other Crew Member',
                              suffixIcon: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.search),
                              ),
                            ),
                          ),
                          suggestionsCallback: (pattern) async {
                            // wait for the user finish typing
                            Future.delayed(const Duration(milliseconds: 500));
                            if(pattern.isNotEmpty) {
                              _usersSearched = await _userViewModel.getUsersBySearchName(pattern.toTitleCase(), 5);
                              return _usersSearched;
                            } else {
                              return [];
                            }
                          },
                          itemBuilder: (context, UserModel suggestion) {
                            return ListTile(
                              title: Text(suggestion.name),
                            );
                          },
                          noItemsFoundBuilder: (context) {
                            return const SizedBox(
                                height: 100,
                                child: Center(
                                  child: Text(
                                    'No users found.',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                )
                            );
                          },
                          onSuggestionSelected: (UserModel? suggestion) {
                            if (suggestion != null) {
                              _newAssessment.otherCrewMemberStaffNo = suggestion.staffNo;

                              otherCrewMemberNameTextController.text = "${suggestion.position} ${suggestion.name}";
                              otherCrewMemberStaffNoTextController.text = _newAssessment.otherCrewMemberStaffNo;
                              // refresh the UI
                              setState(() {});
                            }
                          },
                        )
                    ),
                    // other crew member's staff no
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        controller: otherCrewMemberStaffNoTextController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Staff Number',
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select other crew member by finding name';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        readOnly: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Aircraft Type',
                          // suffixIcon: IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.search),
                          // ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter aircraft type';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.aircraftType = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Airport & Route',
                          // suffixIcon: IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.search),
                          // ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter airport & route';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.airportAndRoute = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Simulation Hours',
                          // suffixIcon: IconButton(
                          //   onPressed: () {},
                          //   icon: const Icon(Icons.search),
                          // ),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter simulation hours';
                          }
                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onChanged: (value) {
                          _newAssessment.simulationHours = value;
                        },
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Navigator.pushNamed(
                        context,
                        NamedRoute.newAssessmentFlightDetails,
                        arguments: _newAssessment,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(40),
                    backgroundColor: TsOneColor.primary,
                    foregroundColor: TsOneColor.primaryContainer,
                    surfaceTintColor: TsOneColor.primaryContainer,
                  ),
                  child: const Text("Next",
                      style: TextStyle(color: TsOneColor.onPrimary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSelectDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2006),
      lastDate: DateTime(2099),
      helpText: "Select assessment date",
    );
    if (picked != null && picked != _newAssessment.assessmentDate) {
      setState(() {
        _newAssessment.assessmentDate = picked;
      });
    }
  }
}
