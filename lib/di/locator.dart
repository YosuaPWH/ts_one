import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ts_one/data/users/user_preferences.dart';
import 'package:ts_one/domain/assessment_repo.dart';
import 'package:ts_one/domain/user_repo.dart';

final GetIt getItLocator = GetIt.instance;

void setupLocator() {
  // FirebaseAuth and FirebaseFirestore are singletons
  getItLocator.registerFactory<FirebaseAuth>(
          () => FirebaseAuth.instance
  );
  getItLocator.registerFactory<FirebaseFirestore>(
          () => FirebaseFirestore.instance
  );

  // UserRepoImpl has dependencies on FirebaseAuth and FirebaseFirestore
  getItLocator.registerFactory<UserRepo>(
          () => UserRepoImpl(
            auth: getItLocator<FirebaseAuth>(),
            db: getItLocator<FirebaseFirestore>(),
          )
  );

  // SharedPreferences is a singleton
  getItLocator.registerSingletonAsync<SharedPreferences>(
          () => SharedPreferences.getInstance()
  );

  // UserPreferences has dependency on SharedPreferences
  getItLocator.registerSingletonWithDependencies<UserPreferences>(
          () => UserPreferences(
            preferences: getItLocator<SharedPreferences>(),
          ),
          dependsOn: [SharedPreferences]
  );

  // AssessmentRepoImpl has dependencies on FirebaseFirestore
  getItLocator.registerFactory<AssessmentRepo>(
          () => AssessmentRepoImpl(
            db: getItLocator<FirebaseFirestore>(),
          ),
  );
}