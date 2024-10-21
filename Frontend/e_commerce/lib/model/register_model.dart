import 'package:uuid/uuid.dart';

const uid = Uuid();

class RegUserModel {
  final String userId;
  final String name;
  final String email;
  final String password;

  RegUserModel(
      {required this.name, required this.email, required this.password})
      : userId = uid.v4();
}
