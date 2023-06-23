import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({Key? key}) : super(key: key);

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  late UserViewModel viewModel;
  late UserModel userModel;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    viewModel = Provider.of<UserViewModel>(context, listen: false);
    initModel();
    super.initState();
  }

  void initModel() {
    userModel = UserModel();
  }

  void _selectDateLicenseLastPassed(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2006),
        lastDate: DateTime(2099),
        helpText: "Select license last passed date",
    );
    if (picked != null && picked != userModel.licenseLastPassed) {
      print("Date Selected: $picked");
      setState(() {
        userModel.licenseLastPassed = picked;
      });
    }
  }

  void _selectDateLicenseExpiry(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2006),
        lastDate: DateTime(2099),
        helpText: "Select license expiry date",
    );
    if (picked != null && picked != userModel.licenseExpiry) {
      setState(() {
        userModel.licenseExpiry = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (_, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Add User", style: TextStyle(fontWeight: FontWeight.w600)),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Name',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      userModel.name = value;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Staff No',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter staff number';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      userModel.staffNo = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: DropdownButtonFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Position',
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Position is required";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                        userModel.position = value!;
                    },
                    items: const [
                      DropdownMenuItem(
                        value: "CAPT",
                        child: Text("CAPT"),
                      ),
                      DropdownMenuItem(
                        value: "FO",
                        child: Text("FO"),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'License No',
                    ),
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter license number';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      userModel.licenseNo = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            _selectDateLicenseLastPassed(context);
                            FocusScope.of(context).unfocus();
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'License Last Passed',
                          ),
                          controller: TextEditingController(
                              text: Util.convertDateTimeDisplay(userModel.licenseLastPassed.toString())
                          ),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _selectDateLicenseLastPassed(context);
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          onTap: () {
                            _selectDateLicenseExpiry(context);
                            FocusScope.of(context).unfocus();
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'License Expiry',
                          ),
                          controller: TextEditingController(
                              text: Util.convertDateTimeDisplay(userModel.licenseExpiry.toString()),
                          ),
                          readOnly: true,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _selectDateLicenseExpiry(context);
                          FocusScope.of(context).unfocus();
                        },
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      else if(!EmailValidator.validate(value)) {
                        return 'Please enter valid email';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) {
                      userModel.email = value;
                    },
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // send data to view model
                        viewModel.addUser(userModel);
                        // clear form
                        _formKey.currentState!.reset();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("User added successfully"),
                            duration: const Duration(milliseconds: 1000),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text("Please fill in all the fields"),
                            duration: const Duration(milliseconds: 1000),
                            action: SnackBarAction(
                              label: 'Close',
                              onPressed: () {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                              },
                            ),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(40),
                    ),
                    child: const Text('Add User'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
