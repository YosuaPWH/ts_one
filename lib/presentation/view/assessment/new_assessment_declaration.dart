import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';

import '../../theme.dart';

class NewAssessmentDeclaration extends StatefulWidget {
  const NewAssessmentDeclaration(
      {super.key, required this.dataAssessmentCandidate, required this.dataAssessmentFlightDetails, required this.dataAssessmentVariablesFirst});

  final NewAssessment dataAssessmentCandidate;
  final AssessmentFlightDetails dataAssessmentFlightDetails;
  final Map<AssessmentVariables, Map<String, String>> dataAssessmentVariablesFirst;

  @override
  State<NewAssessmentDeclaration> createState() => _NewAssessmentDeclarationState();
}

class _NewAssessmentDeclarationState extends State<NewAssessmentDeclaration> with SingleTickerProviderStateMixin {
  bool _isConfirmed = false;
  late SignatureController signatureController;
  late TabController _tabController;
  late ImagePicker imagePicker;

  @override
  void initState() {
    signatureController = SignatureController(
      penStrokeWidth: 3,
      penColor: TsOneColor.primary,
    );
    _tabController = TabController(length: 2, vsync: this);
    imagePicker = ImagePicker();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future getImage() async {
    final image = await imagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("dataCandidate: ${widget.dataAssessmentCandidate}");
    debugPrint("dataFlightDetails: ${widget.dataAssessmentFlightDetails}");
    debugPrint("dataVariables: ${widget.dataAssessmentVariablesFirst}");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Declaration"),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField(
              onChanged: (newValue) {},
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintMaxLines: 1,
                  label: Text(
                    "For Check",
                    style: TextStyle(
                      fontSize: 12,
                    ),
                  )),
              items: const [
                DropdownMenuItem(
                  value: "PASS",
                  child: Text(
                    "PASS",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                DropdownMenuItem(
                  value: "FAIL",
                  child: Text(
                    "FAIL",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Signature"),
              ),
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  color: TsOneColor.primary,
                ),
                padding: EdgeInsets.zero,
                labelColor: TsOneColor.secondary,
                unselectedLabelColor: TsOneColor.primary,
                tabs: const [
                  Center(child: Text("Draw")),
                  Center(child: Text("Image")),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: [
                  ClipRRect(
                    child: SizedBox(
                      child: Signature(
                        controller: signatureController,
                        backgroundColor: TsOneColor.primaryFaded,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImage();
                    },
                    child: Ink(
                      color: TsOneColor.primaryFaded.withOpacity(0.5),
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              size: 72,
                              color: TsOneColor.primaryFaded,
                            ),
                            Text("Signature")
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ListTileTheme(
                horizontalTitleGap: 0.0,
                contentPadding: const EdgeInsets.only(bottom: 0),
                child: CheckboxListTile(
                  value: _isConfirmed,
                  title: const Text("I agree with all of the results"),
                  dense: true,
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newValue) {
                    setState(() {
                      _isConfirmed = newValue!;
                    });
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _isConfirmed ? dd : null,
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  backgroundColor: TsOneColor.primary),
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

  void dd() {}
}
