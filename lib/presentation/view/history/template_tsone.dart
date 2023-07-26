import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class TemplateTSOne extends StatefulWidget {
  const TemplateTSOne({Key? key, required this.assessmentResults}) : super(key: key);

  final AssessmentResults assessmentResults;

  @override
  State<TemplateTSOne> createState() => _TemplateTSOneState();
}

class _TemplateTSOneState extends State<TemplateTSOne> {
  late AssessmentResults assessmentResults;
  late AssessmentResultsViewModel viewModel;

  String messageMakePDF = "";

  @override
  initState() {
    viewModel = Provider.of<AssessmentResultsViewModel>(context, listen: false);
    assessmentResults = widget.assessmentResults;
    super.initState();
  }


  Future<void> makePDF() async {
    messageMakePDF = await viewModel.makePDFSimulator(assessmentResults);

    log("messageMakePDF: $messageMakePDF");
    // setState(() {
    //   messageMakePDF = messageMakePDF;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Template TSOne'),
      ),
      body: const Center(
        child: Text("DOWNLOAD PDF"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          makePDF();
        },
        child: const Icon(Icons.download),
      ),
    );
  }
}
