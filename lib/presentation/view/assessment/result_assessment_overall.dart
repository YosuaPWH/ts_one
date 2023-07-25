import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';

class ResultAssessmentOverall extends StatefulWidget {
  const ResultAssessmentOverall({Key? key, required this.assessmentResults}) : super(key: key);

  final AssessmentResults assessmentResults;

  @override
  State<ResultAssessmentOverall> createState() => _ResultAssessmentOverallState();
}

class _ResultAssessmentOverallState extends State<ResultAssessmentOverall> with SingleTickerProviderStateMixin {
  late AssessmentResults _assessmentResults;
  bool isCPTS = false;

  @override
  void initState() {
    _assessmentResults = widget.assessmentResults;
    isCPTS = _assessmentResults.isCPTS;

    super.initState();
  }

  // @override
  // void dispose() {
  //   _tabController.dispose();
  //   super.dispose();
  // }

  // Future getImage() async {
  //   _pickedImage = await imagePicker.pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 50,
  //   );
  //   if (_pickedImage == null) return;
  //   File? imgTemp;
  //
  //   if(_pickedImage != null) {
  //     final croppedFile = await ImageCropper().cropImage(
  //       sourcePath: _pickedImage!.path,
  //       compressFormat: ImageCompressFormat.png,
  //       compressQuality: 100,
  //       aspectRatioPresets: [
  //         CropAspectRatioPreset.square,
  //       ],
  //       uiSettings: [
  //         AndroidUiSettings(
  //           statusBarColor: tsOneColorScheme.onSecondary,
  //           toolbarTitle: "Crop Image",
  //           toolbarColor: tsOneColorScheme.secondary,
  //           toolbarWidgetColor: tsOneColorScheme.onSurface,
  //           initAspectRatio: CropAspectRatioPreset.square,
  //           activeControlsWidgetColor: tsOneColorScheme.primary,
  //           lockAspectRatio: true,
  //         ),
  //         IOSUiSettings(
  //           title: "Crop Image",
  //         ),
  //         WebUiSettings(
  //             context: context
  //         ),
  //       ],
  //     );
  //     if (croppedFile != null) {
  //       setState(() {
  //         _croppedImage = croppedFile;
  //         imgTemp = File(_croppedImage!.path);
  //         _image = imgTemp;
  //       });
  //     }
  //     else{
  //       setState(() {
  //         _pickedImage = null;
  //         imgTemp = null;
  //       });
  //     }
  //   }
  // }

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
            _assessmentResults.isFromHistory ? const SizedBox() :
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, NamedRoute.resultAssessmentDeclaration, arguments: _assessmentResults);
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
