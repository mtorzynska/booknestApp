import 'package:booknest/models/goal.dart';
import 'package:booknest/services/notification_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GoalService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createGoal(String userId, Goal goal) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('goals')
        .doc(goal.goalName)
        .set(goal.toMap());
  }

  Future<void> createGoalWithDeadline(String userId, Goal goal) async {
    await createGoal(userId, goal);

    DateTime notificationTime =
        goal.deadline!.subtract(const Duration(days: 1));
    DateTime deadlineTime = goal.deadline!;

    NotificationService.showNotification('BookNest Reminder',
        'Your goal ${goal.goalName} is due tommorow!', notificationTime);

    NotificationService.showNotification('BookNest Reminder',
        'Your goal ${goal.goalName} is due now!', deadlineTime);
  }

  Stream<List<Goal>> getUserGoals(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('goals')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Goal.fromMap(doc.data())).toList();
    });
  }

  Future<void> deleteGoal(String uid, String goalName) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('goals')
        .doc(goalName)
        .delete();
  }

  Future<void> createEmptyGoalsCollectionForNewUser(String uid) async {}
}
