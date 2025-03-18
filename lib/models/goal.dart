import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';

class Goal {
  final String goalName;
  final DateTime? deadline;
  Goal({
    required this.goalName,
    this.deadline,
  });

  Goal copyWith({
    String? goalName,
    DateTime? deadline,
  }) {
    return Goal(
      goalName: goalName ?? this.goalName,
      deadline: deadline ?? this.deadline,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'goalName': goalName,
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
    };
  }

  factory Goal.fromMap(Map<String, dynamic> map) {
    return Goal(
      goalName: map['goalName'] as String,
      deadline: map['deadline'] != null
          ? (map['deadline'] as Timestamp).toDate()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Goal.fromJson(String source) =>
      Goal.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Goal(goalName: $goalName, deadline: $deadline)';

  @override
  bool operator ==(covariant Goal other) {
    if (identical(this, other)) return true;

    return other.goalName == goalName && other.deadline == deadline;
  }

  @override
  int get hashCode => goalName.hashCode ^ deadline.hashCode;
}
