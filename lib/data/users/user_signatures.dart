import 'package:flutter/cupertino.dart';
import 'package:ts_one/util/util.dart';

class UserSignatures with ChangeNotifier {
  UserSignatures({
    this.urlSignature = Util.defaultStringIfNull,
    this.staffId = Util.defaultIntIfNull,
  });

  static const String firebaseCollection = 'user-signatures';

  static const String keyUrlSignature = 'url-signature';
  static const String keyStaffId = 'staff-id';
  static const String keyDateUploaded = 'date-uploaded';

  String urlSignature = '';
  int staffId = Util.defaultIntIfNull;
  DateTime dateUploaded = DateTime.now();

  UserSignatures.fromFirebase(Map<String, dynamic> map) {
    urlSignature = map[keyUrlSignature];
    staffId = map[keyStaffId];
    dateUploaded = map[keyDateUploaded];
  }

  Map<String, dynamic> toFirebase() {
    return {
      keyUrlSignature: urlSignature,
      keyStaffId: staffId,
      keyDateUploaded: dateUploaded,
    };
  }
}