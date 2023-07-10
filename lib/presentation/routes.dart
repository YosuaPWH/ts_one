import 'package:flutter/material.dart';
import 'package:ts_one/data/assessments/assessment_flight_details.dart';
import 'package:ts_one/data/assessments/assessment_variables.dart';
import 'package:ts_one/data/assessments/new_assessment.dart';
import 'package:ts_one/presentation/main_view.dart';
import 'package:ts_one/presentation/view/assessment/add_assessment_period.dart';
import 'package:ts_one/presentation/view/assessment/all_assessment_periods.dart';
import 'package:ts_one/presentation/view/assessment/detail_assessment_period.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_candidate.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_declaration.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_flight_details.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_overall_performance.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_success.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_variables.dart';
import 'package:ts_one/presentation/view/assessment/new_assessment_variables_second.dart';
import 'package:ts_one/presentation/view/assessment/update_assessment_period.dart';
import 'package:ts_one/presentation/view/users/add_user.dart';
import 'package:ts_one/presentation/view/users/all_users.dart';
import 'package:ts_one/presentation/view/users/detail_user.dart';
import 'package:ts_one/presentation/view/users/login.dart';
import 'package:ts_one/presentation/view/users/update_user.dart';

class AppRoutes {
  AppRoutes._();

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case NamedRoute.home:
        return MaterialPageRoute<void>(
          builder: (context) => const MainView(),
          settings: settings,
        );

      case NamedRoute.login:
        return MaterialPageRoute<void>(
          builder: (context) => const LoginView(),
          settings: settings,
        );

      case NamedRoute.allUsers:
        return MaterialPageRoute<void>(
          builder: (context) => const AllUsersView(),
          settings: settings,
        );

      case NamedRoute.addUser:
        return MaterialPageRoute<void>(
          builder: (context) => const AddUserView(),
          settings: settings,
        );

      case NamedRoute.detailUser:
        return MaterialPageRoute<void>(
          builder: (context) => DetailUserView(
              userIDNo: settings.arguments as String),
          settings: settings,
        );

      case NamedRoute.updateUser:
        return MaterialPageRoute<void>(
          builder: (context) => UpdateUserView(
              userEmail: settings.arguments as String),
          settings: settings,
        );

      // ====================== NEW ASSESSMENT ==========================================

      case NamedRoute.newAssessmentCandidate:
        return MaterialPageRoute<void>(
          builder: (context) => const NewAssessmentCandidate(),
          settings: settings,
        );

      case NamedRoute.newAssessmentFlightDetails:
        // final arguments = settings.arguments as NewAssessment;
        // final dataAssessmentCandidate = arguments['dataAssessmentCandidate'] as NewAssessment;

        return MaterialPageRoute<void>(
          builder: (context) => NewAssessmentFlightDetails(
            dataAssessmentCandidate: settings.arguments as NewAssessment,
          ),
          settings: settings,
        );

      case NamedRoute.newAssessmentVariables:
        final arguments = settings.arguments as Map<String, dynamic>;
        final dataAssessmentFlightDetails = arguments['dataAssessmentFlightDetails'] as AssessmentFlightDetails;
        final dataAssessmentCandidate = arguments['dataAssessmentCandidate'] as NewAssessment;

        return MaterialPageRoute<void>(
          builder: (context) => NewAssessmentVariables(
            dataAssessmentFlightDetails: dataAssessmentFlightDetails,
            dataAssessmentCandidate: dataAssessmentCandidate,
          ),
          settings: settings,
        );

      case NamedRoute.newAssessmentVariablesSecond:
        final arguments = settings.arguments as Map<String, dynamic>;
        final dataAssessmentCandidate = arguments['dataAssessmentCandidate'] as NewAssessment;
        final dataAssessmentFlightDetails = arguments['dataAssessmentFlightDetails'] as AssessmentFlightDetails;
        final dataVariablesFirst = arguments['dataAssessmentVariablesFirst'] as Map<AssessmentVariables, Map<String, String>>;

        return MaterialPageRoute<void>(
          builder: (context) => NewAssessmentVariablesSecond(
            dataCandidate: dataAssessmentCandidate,
            dataAssessmentFlightDetails: dataAssessmentFlightDetails,
            dataAssessmentVariables: dataVariablesFirst,
          ),
          settings: settings,
        );

      case NamedRoute.newAssessmentOverallPerformance:
        final arguments = settings.arguments as Map<String, dynamic>;
        final dataAssessmentCandidate = arguments['dataAssessmentCandidate'] as NewAssessment;
        final dataAssessmentFlightDetails = arguments['dataAssessmentFlightDetails'] as AssessmentFlightDetails;
        final dataAssessmentVariablesFirst = arguments['dataAssessmentVariablesFirst'] as Map<AssessmentVariables, Map<String, String>>;

        return MaterialPageRoute<void>(
          builder: (context) => NewAssessmentOverallPerformance(
            dataAssessmentCandidate: dataAssessmentCandidate,
            dataAssessmentFlightDetails: dataAssessmentFlightDetails,
            dataAssessmentVariables: dataAssessmentVariablesFirst,
          ),
          settings: settings,
        );

      case NamedRoute.newAssessmentDeclaration:
        final arguments = settings.arguments as Map<String, dynamic>;
        final dataAssessmentCandidate = arguments['dataAssessmentCandidate'] as NewAssessment;
        final dataAssessmentFlightDetails = arguments['dataAssessmentFlightDetails'] as AssessmentFlightDetails;
        final dataAssessmentVariablesFirst = arguments['dataAssessmentVariablesFirst'] as Map<AssessmentVariables, Map<String, String>>;

        return MaterialPageRoute<void>(
          builder: (context) => NewAssessmentDeclaration(
            dataAssessmentCandidate: dataAssessmentCandidate,
            dataAssessmentFlightDetails: dataAssessmentFlightDetails,
            dataAssessmentVariablesFirst: dataAssessmentVariablesFirst,
          ),
          settings: settings,
        );

      case NamedRoute.newAssessmentSuccess:
        return MaterialPageRoute<void>(
          builder: (context) => const NewAssessmentSuccess(),
          settings: settings
        );

      // =============================================================================

      case NamedRoute.allAssessmentPeriods:
        return MaterialPageRoute<void>(
          builder: (context) => const AllAssessmentPeriodsView(),
          settings: settings,
        );

      case NamedRoute.detailAssessmentPeriod:
        return MaterialPageRoute<void>(
          builder: (context) => DetailAssessmentPeriodView(
              assessmentPeriodId: settings.arguments as String),
          settings: settings,
        );

      case NamedRoute.addAssessmentPeriod:
        return MaterialPageRoute<void>(
          builder: (context) => const AddAssessmentPeriodView(),
          settings: settings,
        );

      case NamedRoute.updateAssessmentPeriod:
        return MaterialPageRoute<void>(
          builder: (context) => UpdateAssessmentPeriodView(
              assessmentPeriodId: settings.arguments as String),
          settings: settings,
        );

      default:
        return MaterialPageRoute<void>(
          builder: (_) => _UndefinedView(name: settings.name),
          settings: settings,
        );
    }
  }
}

class _UndefinedView extends StatelessWidget {
  const _UndefinedView({Key? key, this.name}) : super(key: key);
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Something wrong for: $name'),
      ),
    );
  }
}

class NamedRoute {
  NamedRoute._();

  static const String main = '/';
  static const String login = '/login';
  static const String home = '/home';

  static const String allUsers = '/allUsers';
  static const String addUser = '/addUser';
  static const String detailUser = '/detailUser';
  static const String updateUser = '/updateUser';

  static const String newAssessmentCandidate = '/newAssessmentCandidate';
  static const String newAssessmentFlightDetails = '/newAssessmentFlightDetails';
  static const String newAssessmentVariables = '/newAssessmentVariables';
  static const String newAssessmentVariablesSecond = '/newAssessmentVariablesSecond';
  static const String newAssessmentOverallPerformance = '/newAssessmentOverallPerformance';
  static const String newAssessmentDeclaration = '/newAssessmentDeclaration';
  static const String newAssessmentSuccess = '/newAssessmentSuccess';

  static const String allAssessmentPeriods = '/allAssessmentPeriods';
  static const String detailAssessmentPeriod = '/detailAssessmentPeriod';
  static const String addAssessmentPeriod = '/addAssessmentPeriod';
  static const String updateAssessmentPeriod = '/updateAssessmentPeriod';
}
