import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:signature/signature.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';

class ResultAssessmentOverall extends StatefulWidget {
  const ResultAssessmentOverall({Key? key, required this.assessmentResults}) : super(key: key);

  final AssessmentResults assessmentResults;

  @override
  State<ResultAssessmentOverall> createState() => _ResultAssessmentOverallState();
}

class _ResultAssessmentOverallState extends State<ResultAssessmentOverall> with SingleTickerProviderStateMixin {
  late AssessmentResults _assessmentResults;
  late AssessmentResultsViewModel viewModel;
  bool isCPTS = false;
  String messageMakePDF = "";

  @override
  void initState() {
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    _assessmentResults = widget.assessmentResults;
    isCPTS = _assessmentResults.isCPTS;

    super.initState();
  }

  Future<void> makePDF() async {
    // setState(() async {
    // });
    messageMakePDF = await viewModel.makePDFSimulator(_assessmentResults);

    log("messageMakePDF: $messageMakePDF");


    showOpenPDF();

    // setState(() {});
  }

  void showOpenPDF() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Download Success"),
          content: const Text("Do you want to open this file?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () {
                OpenFile.open(messageMakePDF);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
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
    return Consumer<AssessmentResultsViewModel>(
      builder: (_, viewModel, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Overall Performance"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: viewModel.isLoading
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("This will take a while."),
                    ],
                  ))
                : Column(
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
                                        text: _assessmentResults.overallPerformance.round().toString()),
                                    decoration: const InputDecoration(
                                      disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                      hintMaxLines: 1,
                                      label: Text(
                                        "Overall Performance",
                                        style: TextStyle(fontSize: 12, color: Colors.green),
                                      ),
                                    ),
                                  )),
                              TextField(
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                minLines: 10,
                                enabled: false,
                                style: const TextStyle(
                                  color: TsOneColor.onSecondary,
                                ),
                                controller: TextEditingController(text: _assessmentResults.notes),
                                decoration: const InputDecoration(
                                  disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
                                  border: OutlineInputBorder(),
                                  label: Text(
                                    "Overall Performance",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
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
                      // _assessmentResults.isFromHistory
                      //     ? const SizedBox()
                      //     :
                      ElevatedButton(
                        onPressed: () {
                          _assessmentResults.isFromHistory
                              ? showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Download"),
                                      content: const Text("Are you sure you want to download this assessment?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.pop(context);
                                            // Future.delayed(const Duration(seconds: 2));

                                            makePDF();
                                            // await _assessmentResults.downloadAssessment();
                                          },
                                          child: const Text("Download"),
                                        ),
                                      ],
                                    );
                                  },
                                )
                              :
                              // _assessmentResults.isFromHistory ? NamedRoute.template :
                              Navigator.pushNamed(context, NamedRoute.resultAssessmentDeclaration,
                                  arguments: _assessmentResults);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          backgroundColor: TsOneColor.primary,
                        ),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 48,
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              _assessmentResults.isFromHistory ? "Download" : "Next",
                              style: const TextStyle(color: TsOneColor.secondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        );
      }
    );
  }
}
