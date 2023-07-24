import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ts_one/data/assessments/assessment_results.dart';
import 'package:ts_one/data/users/users.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';
import 'package:ts_one/presentation/view_model/assessment_results_viewmodel.dart';
import 'package:ts_one/presentation/view_model/user_viewmodel.dart';
import 'package:ts_one/util/util.dart';

class CardUser extends StatefulWidget {
  const CardUser({Key? key, required this.assessmentResults}) : super(key: key);

  final AssessmentResults assessmentResults;

  @override
  State<CardUser> createState() => _CardUserState();
}

class _CardUserState extends State<CardUser> {
  late AssessmentResults _assessmentResults;

  @override
  void initState() {
    _assessmentResults = widget.assessmentResults;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: TsOneColor.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, NamedRoute.resultAssessmentVariables, arguments: _assessmentResults);
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset("assets/images/placeholder_person.png"),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _assessmentResults.examineeName.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _assessmentResults.examinerStaffIDNo.toString(),
                        style: const TextStyle(fontWeight: FontWeight.normal),
                      ),
                      Text(
                        _assessmentResults.examineeRank.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Text(Util.convertDateTimeDisplay(_assessmentResults.date.toString())),
            ],
          ),
        ),
      ),
    );
  }
}
