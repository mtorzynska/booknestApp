import 'package:booknest/services/user_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final currentUserProvider = StateProvider<String?>((ref) => null);

final userServiceProvider = Provider((ref) => UserService());
