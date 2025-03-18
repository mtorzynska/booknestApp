import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/services/goal_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final goalServiceProvider = Provider((ref) => GoalService());

final userGoalsProvider = StreamProvider.autoDispose((ref) {
  final userId = ref.watch(currentUserProvider.notifier).state;
  final goalService = ref.watch(goalServiceProvider);
  if (userId != null) {
    return goalService.getUserGoals(userId);
  }
  return Stream.value([]);
});
