import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';

class ResultAssessmentOverall extends StatefulWidget {
  const ResultAssessmentOverall({Key? key, required this.assessmentResults, required this.isCPTS}) : super(key: key);

  final AssessmentResults assessmentResults;
  final bool isCPTS;

  @override
  State<ResultAssessmentOverall> createState() => _ResultAssessmentOverallState();
}

class _ResultAssessmentOverallState extends State<ResultAssessmentOverall> with SingleTickerProviderStateMixin {
  late AssessmentResults _assessmentResults;
  bool isCPTS = false;

  @override
  void initState() {
    _assessmentResults = widget.assessmentResults;
    isCPTS = widget.isCPTS;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Overall Performance"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
                      child: TextField(
                        enabled: false,
                        style: const TextStyle(
                          color: TsOneColor.onSecondary,
                        ),
                        controller: TextEditingController(
                          text: _assessmentResults.overallPerformance.round().toString()
                        ),
                        decoration: const InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.green)
                          ),
                          hintMaxLines: 1,
                          label: Text(
                            "Overall Performance",
                            style: TextStyle(
                              fontSize: 12, color: Colors.green
                            ),
                          ),
                        ),
                      )
                    ),
                    TextField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 10,
                      enabled: false,
                      style: const TextStyle(
                        color: TsOneColor.onSecondary,
                      ),
                      controller: TextEditingController(
                        text: _assessmentResults.notes
                      ),
                      decoration: const InputDecoration(
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.green)
                        ),
                        border: OutlineInputBorder(),
                        label: Text(
                          "Overall Performance",
                          style: TextStyle(
                            fontSize: 12, color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, NamedRoute.resultAssessmentDeclaration, arguments: {
                  "assessmentResults": _assessmentResults,
                  "isCPTS": isCPTS,
                });
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                backgroundColor: TsOneColor.primary,
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 48,
                child: const Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Next",
                    style: TextStyle(color: TsOneColor.secondary),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
