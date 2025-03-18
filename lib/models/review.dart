import 'dart:convert';
import 'package:booknest/models/user.dart';

class Review {
  String review;
  final User user;
  Review({
    required this.review,
    required this.user,
  });

  Review copyWith({
    String? review,
    User? user,
  }) {
    return Review(
      review: review ?? this.review,
      user: user ?? this.user,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'review': review,
      'user': user.toMap(),
    };
  }

  factory Review.fromMap(Map<String, dynamic> map) {
    return Review(
      review: map['review'] as String,
      user: User.fromMap(map['user'] as Map<String, dynamic>),
    );
  }

  String toJson() => json.encode(toMap());

  factory Review.fromJson(String source) =>
      Review.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'Review(review: $review, user: $user)';

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.review == review && other.user == user;
  }

  @override
  int get hashCode => review.hashCode ^ user.hashCode;
}
