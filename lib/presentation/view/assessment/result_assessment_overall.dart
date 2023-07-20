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
  // late TabController _tabController;
  // late SignatureController signatureController;
  // late ImagePicker imagePicker;
  // bool _isConfirmed = false;

  // File? _image;
  // XFile? _pickedImage;
  // CroppedFile? _croppedImage;

  @override
  void initState() {
    _assessmentResults = widget.assessmentResults;
    // _tabController = TabController(length: 2, vsync: this);
    // signatureController = SignatureController(
    //   penStrokeWidth: 5,
    //   penColor: TsOneColor.onSecondary,
    // );
    // imagePicker = ImagePicker();

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
  //       // print("HALOOOO image: ${_image!.path}");
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
            // Container(
            //   padding: const EdgeInsets.all(0),
            //   height: 45,
            //   width: 400,
            //   decoration: BoxDecoration(
            //     color: Colors.grey.shade200,
            //     borderRadius: BorderRadius.circular(25.0),
            //   ),
            //   child: TabBar(
            //     controller: _tabController,
            //     indicator: BoxDecoration(
            //       borderRadius: BorderRadius.circular(25.0),
            //       color: TsOneColor.primary,
            //     ),
            //     padding: EdgeInsets.zero,
            //     labelColor: TsOneColor.secondary,
            //     unselectedLabelColor: TsOneColor.primary,
            //     tabs: const [
            //       SizedBox.expand(child: Center(child: Text("Draw"))),
            //       SizedBox.expand(child: Center(child: Text("Image"))),
            //     ],
            //   ),
            // ),
            // Expanded(
            //   child: TabBarView(
            //     physics: const NeverScrollableScrollPhysics(),
            //     controller: _tabController,
            //     children: [
            //       Stack(children: <Widget>[
            //         ClipRRect(
            //           child: SizedBox(
            //             child:
            //             Signature(
            //               controller: signatureController,
            //               backgroundColor: TsOneColor.primaryFaded,
            //             ),
            //             /*
            //                   Container(
            //                     constraints: BoxConstraints.expand(),
            //                     color: Colors.white,
            //                     child: HandSignature(
            //                       control: handSignatureControl,
            //                       type: SignatureDrawType.shape,
            //                     ),
            //                   )
            //                   */
            //           ),
            //         ),
            //         Container(
            //           alignment: Alignment.topRight,
            //           child: IconButton(
            //             icon: const Icon(
            //               Icons.delete_outline_outlined,
            //               size: 32,
            //               color: TsOneColor.primary,
            //             ),
            //             onPressed: () {
            //               signatureController.clear();
            //               // handSignatureControl.clear();
            //             },
            //           ),
            //         ),
            //       ]),
            //       if (_image == null)
            //         InkWell(
            //           onTap: () {
            //             getImage();
            //           },
            //           child: Ink(
            //             color: TsOneColor.primaryFaded.withOpacity(0.5),
            //             child: const Center(
            //               child: Column(
            //                 mainAxisAlignment: MainAxisAlignment.center,
            //                 children: [
            //                   Icon(
            //                     Icons.camera_alt,
            //                     size: 72,
            //                     color: TsOneColor.primaryFaded,
            //                   ),
            //                   Text("Signature")
            //                 ],
            //               ),
            //             ),
            //           ),
            //         )
            //       else
            //         Padding(
            //           padding: const EdgeInsets.symmetric(vertical: 5),
            //           child: Center(
            //             child: InkWell(
            //               onTap: () {
            //                 getImage();
            //               },
            //               child: Ink(
            //                 color: TsOneColor.primaryFaded.withOpacity(0.5),
            //                 child: Image(
            //                   image: FileImage(_image!),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //     ],
            //   ),
            // ),
            // ListTileTheme(
            //   horizontalTitleGap: 0.0,
            //   contentPadding: const EdgeInsets.only(bottom: 0),
            //   child: CheckboxListTile(
            //     value: _isConfirmed,
            //     title: const Text("I agree with all of the results above"),
            //     dense: true,
            //     controlAffinity: ListTileControlAffinity.leading,
            //     onChanged: (newValue) {
            //       setState(() {
            //         _isConfirmed = newValue!;
            //       });
            //     },
            //   ),
            // ),
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
