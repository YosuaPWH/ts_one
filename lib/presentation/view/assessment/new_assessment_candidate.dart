import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/routes.dart';
import 'package:ts_one/presentation/theme.dart';

class NewAssessmentCandidate extends StatefulWidget {
  const NewAssessmentCandidate({super.key});

  @override
  State<NewAssessmentCandidate> createState() => _NewAssessmentCandidateState();
}

class _NewAssessmentCandidateState extends State<NewAssessmentCandidate> {
  final _nameController = TextEditingController();
  final _staffNumberController = TextEditingController();
  final _otherCrewMemberController = TextEditingController();
  final _aircraftTypeController = TextEditingController();
  final _airportAndRouteController = TextEditingController();
  final _simulationHoursController = TextEditingController();
  final _inputDateController = TextEditingController();
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Assessment"),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Date"),
              TextField(
                controller: _inputDateController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'dd/mm/yyyy',
                  suffixIcon: IconButton(
                    onPressed: () {
                      _showSelectDatePicker(context);
                    },
                    icon: const Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Name"),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Name',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Staff Number"),
              TextField(
                controller: _staffNumberController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Staff Number',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Other Crew Member"),
              TextField(
                controller: _otherCrewMemberController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Other Crew Member',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Aircraft Type"),
              TextField(
                controller: _aircraftTypeController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Aircraft Type',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Airport & Route"),
              TextField(
                controller: _airportAndRouteController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Airport & Route',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Simulation Hours"),
              TextField(
                controller: _simulationHoursController,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Simulation Hours',
                  suffixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    NamedRoute.newAssessmentFlightDetails,
                    arguments: NewAssessment(
                      name: _nameController.text,
                      staffNumber: _staffNumberController.text,
                      otherCrewMember: _otherCrewMemberController.text,
                      aircraftType: _aircraftTypeController.text,
                      airportAndRoute: _airportAndRouteController.text,
                      simulationHours: _simulationHoursController.text,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    backgroundColor: tsOneColorScheme.primary),
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
      ),
    );
  }

  void _showSelectDatePicker(BuildContext context) async {
    DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate! : DateTime.now(),
      firstDate: DateTime(2010),
      lastDate: DateTime(2050),
    );

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _inputDateController
        ..text = DateFormat.yMMMd().format(_selectedDate!)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _inputDateController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }
}
