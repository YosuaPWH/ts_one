import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ts_one/data/users/users.dart';

abstract class UserRepo {
  Future<UserAuth> login(String email, String password);
  // Future<UserAuth> loginWithGoogle();
  Future<UserModel> addUser(UserModel userModel);
  Future<void> logout();
}

class UserRepoImpl implements UserRepo {
  UserRepoImpl({FirebaseFirestore? db, FirebaseAuth? auth})
      : _db = db,
        _auth = auth;

  final FirebaseFirestore? _db;
  final FirebaseAuth? _auth;

  @override
  Future<UserAuth> login(String email, String password) async {
    UserAuth userAuth = UserAuth();

    try {
      // try to login with firebase auth
      UserCredential userCredential = await _auth!.signInWithEmailAndPassword(email: email, password: password);

      // if current user is not null and user credential is not null, it means login is successful
      if (_auth!.currentUser != null && userCredential.user != null) {
        // get user data from firestore database by finding the uid of the current user
        final userData = await _db!.collection('users').doc(userCredential.user!.email).get();

        // create user model from firebase user and user data from firestore
        UserModel userModel = UserModel.fromFirebaseUser(userData.data()!);

        // return user auth with user model and message
        userAuth.userModel = userModel;
        userAuth.userCredential = userCredential;
      }
    } catch (e) {
      print("Exception un UserRepo: $e");
    }
    return userAuth;
  }

  /*
  @override
  Future<UserAuth> loginWithGoogle() async {
    UserAuth userAuth = UserAuth(userModel: null, message: "Something went wrong");

    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to firebase with the credential
      UserCredential userCredential = await _auth!.signInWithCredential(credential);

      // if current user is not null and user credential is not null, it means login is successful
      if (_auth!.currentUser != null && userCredential.user != null) {
        // get user data from firestore database by finding the uid of the current user
        final userData = await _db!.collection('
   */

  @override
  Future<UserModel> addUser(UserModel userModel) async {
    UserModel newUserModel = UserModel();

    try {
      // add new user to firestore database
      await _db!.collection('users').doc(userModel.email).set(userModel.toMap());

      // get user data from firestore database by finding the email of the current user
      final userData = await _db!.collection('users').doc(userModel.email).get();

      // create user model from firebase user and user data from firestore
      newUserModel = UserModel.fromFirebaseUser(userData.data()!);
    } catch (e) {
      print(e.toString());
    }

    return newUserModel;
  }

  @override
  Future<void> logout() async {
    try {
      return await _auth!.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}