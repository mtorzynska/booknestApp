import 'package:booknest/models/book.dart';
import 'package:booknest/models/review.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/services/book_sevice.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);

final userBookProvider = StreamProvider.autoDispose((ref) {
  final userId = ref.watch(currentUserProvider);
  if (userId != null) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('books')
        .snapshots();
  }
  return const Stream.empty();
});

final bookReviewsProvider =
    StreamProvider.family<List<Review>, Book>((ref, book) {
  final reviewService = ref.watch(bookServiceProvider);
  return reviewService.getBookReviews(book);
});

final bookSpecificsProvider = StreamProvider.family<Book, Book>((ref, book) {
  final reviewService = ref.watch(bookServiceProvider);
  return reviewService.getBookSpecifics(book);
});

final bookServiceProvider = Provider((ref) => BookService());
