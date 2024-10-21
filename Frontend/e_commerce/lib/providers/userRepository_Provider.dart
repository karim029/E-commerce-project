import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_commerce/repositories/user_Repository.dart';
import 'package:http/http.dart' as http;

final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository(http.Client());
});
