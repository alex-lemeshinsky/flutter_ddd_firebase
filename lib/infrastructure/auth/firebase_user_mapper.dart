import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ddd_firebase/domain/auth/user.dart';
import 'package:flutter_ddd_firebase/domain/core/value_objects.dart';

extension FirebaseUserDomainX on User {
  AppUser toDomain() => AppUser(id: UniqueId.fromUniqueString(uid));
}
