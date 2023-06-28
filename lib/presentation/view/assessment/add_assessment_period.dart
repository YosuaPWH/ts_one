import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_period.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class AddAssessmentPeriodView extends StatefulWidget {
  const AddAssessmentPeriodView({Key? key}) : super(key: key);

  @override
  State<AddAssessmentPeriodView> createState() =>
      _AddAssessmentPeriodViewState();
}

class _AddAssessmentPeriodViewState extends State<AddAssessmentPeriodView> {
  late AssessmentViewModel viewModel;
  late AssessmentPeriod assessmentPeriod;
  final _formKey = GlobalKey<FormState>();
  late List<Map<String, TextEditingController>> controllers;
  late List<Map<String, Widget>> inputs;

  @override
  void initState() {
    viewModel = Provider.of<AssessmentViewModel>(context, listen: false);
    assessmentPeriod = AssessmentPeriod();
    controllers = [];
    inputs = [];

    super.initState();
  }

  void _selectDateAssessmentPeriod(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2006),
      lastDate: DateTime(2099),
      helpText: "Select effective period date",
    );
    if (picked != null && picked != assessmentPeriod.period) {
      setState(() {
        assessmentPeriod.period = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AssessmentViewModel>(builder: (_, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("New Form Assessment"),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            onTap: () {
                              _selectDateAssessmentPeriod(context);
                              FocusScope.of(context).unfocus();
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Effective date',
                            ),
                            controller: TextEditingController(
                                text: Util.convertDateTimeDisplay(
                                    assessmentPeriod.period.toString())
                            ),
                            readOnly: true,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            _selectDateAssessmentPeriod(context);
                            FocusScope.of(context).unfocus();
                          },
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            height: 36,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            'Variables to be assessed',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Colors.grey,
                            height: 36,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: SizedBox(
                        height: 200.0,
                        child: ListView.builder(
                          itemCount: inputs.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Column(
                                children: [
                                  inputs[index]["name"]!,
                                  inputs[index]["category"]!,
                                  inputs[index]["typeOfAssessment"]!,
                                  const Divider(
                                    color: Colors.grey,
                                    height: 36,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      )
                  ),
                  // row in a column
                  Expanded(
                    flex: 0,
                    child: SizedBox(
                      height: 40.0,
                      width: double.infinity,
                      child: Row(
                        children: [
                          // add the text field dynamically with the add button
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      if (inputs.isNotEmpty) {
                                        inputs.removeLast();
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tsOneColorScheme.secondary,
                                    foregroundColor: tsOneColorScheme.secondaryContainer,
                                    surfaceTintColor: tsOneColorScheme.secondary,
                                    minimumSize: const Size.fromHeight(40),
                                  ),
                                  child: const Icon(Icons.remove, color: Colors.black)
                              ),
                            ),
                          ),
                          // button to delete the last text field
                          Expanded(
                            child: SizedBox(
                              child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _buildInput(inputs.length);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: tsOneColorScheme.secondary,
                                    foregroundColor: tsOneColorScheme.secondaryContainer,
                                    surfaceTintColor: tsOneColorScheme.secondary,
                                    minimumSize: const Size.fromHeight(40),
                                  ),
                                  child: const Icon(Icons.add, color: Colors.black)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
        ),
      );
    },
    );
  }

  void _buildInput(int index) {
    // add new item of AssessmentVariable to AssessmentPeriod
    assessmentPeriod.assessmentVariables.add(
        AssessmentVariables());

    // add the text field
    final nameController = TextEditingController();
    final nameTextField = Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 16.0),
      child: TextFormField(
        controller: nameController,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Name',
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
          assessmentPeriod.assessmentVariables[index].name = value;
        },
      ),
    );

    // add the dropdown field
    final categoryController = TextEditingController();
    final categoryDropdownField = Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Category',
        ),
        validator: (value) {
          if (value == null) {
            return "Category is required";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          assessmentPeriod.assessmentVariables[index].category = value.toString();
        },
        items: const [
          DropdownMenuItem(
            value: "Flight Preparation",
            child: Text("Flight Preparation"),
          ),
          DropdownMenuItem(
            value: "Flight Maneuvers and Procedure",
            child: Text("Flight Maneuvers and Procedure"),
          ),
          DropdownMenuItem(
            value: "App. & Missed App. Procedures",
            child: Text("App. & Missed App. Procedures"),
          ),
          DropdownMenuItem(
            value: "Landing",
            child: Text("Landing"),
          ),
          DropdownMenuItem(
            value: "LVO Qualification / Checking",
            child: Text("LVO Qualification / Checking"),
          ),
          DropdownMenuItem(
            value: "SOP's",
            child: Text("SOP's"),
          ),
          DropdownMenuItem(
            value: "Advance Maneuvers",
            child: Text("Advance Maneuvers"),
          ),
        ],
      ),
    );

    // add the dropdown field
    final typeOfAssessmentController = TextEditingController();
    final typeOfAssessmentDropdownField = Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: DropdownButtonFormField(
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Type of Assessment',
        ),
        validator: (value) {
          if (value == null) {
            return "Position is required";
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        onChanged: (value) {
          assessmentPeriod.assessmentVariables[index].typeOfAssessment = value.toString();
        },
        items: const [
          DropdownMenuItem(
            value: "Satisfactory",
            child: Text("Satisfactory"),
          ),
          DropdownMenuItem(
            value: "PF/PM",
            child: Text("PF/PM"),
          ),
        ],
      ),
    );

    controllers.add({
      'name': nameController,
      'category': categoryController,
      'typeOfAssessment': typeOfAssessmentController,
    });

    inputs.add({
      'name': nameTextField,
      'category': categoryDropdownField,
      'typeOfAssessment': typeOfAssessmentDropdownField,
    });
  }
}
