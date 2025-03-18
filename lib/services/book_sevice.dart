import 'package:booknest/models/book.dart';
import 'package:booknest/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BookService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference books =
      FirebaseFirestore.instance.collection("books");

  Stream<List<Book>> getBooks() {
    return books.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<Book> getBookSpecifics(Book book) {
    return books.doc('${book.title} - ${book.author}').snapshots().map(
        (snapshot) => Book.fromMap(snapshot.data() as Map<String, dynamic>));
  }

  Stream<List<Book>> getBooksByTitle(String title) {
    return books.where('title', isEqualTo: title).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return Book.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<String> addBook(Book book) async {
    final docRef = books.doc('${book.title} - ${book.author}');
    final String docId = docRef.id;
    docRef.set({...book.toMap(), 'id': docId});
    return docId;
  }

  Future<void> updateBook(Book book, String bookId) {
    return books.doc(bookId).update(book.toMap());
  }

  Future<void> deleteBook(String docId) {
    return books.doc(docId).delete();
  }

  Future<void> addReviewToBook(Book book, Review review) async {
    final bookDocRef = books
        .doc('${book.title} - ${book.author}')
        .collection('reviews')
        .doc(review.user.email);
    await bookDocRef.set(review.toMap());
  }

  Future<bool> checkIfReviewed(String uid, Book book) async {
    final reviewsSnapshot = await books
        .doc('${book.title} - ${book.author}')
        .collection('reviews')
        .where('user.uid', isEqualTo: uid)
        .get();

    return reviewsSnapshot.docs.isNotEmpty;
  }

  Future<void> updateReview(Book book, Review review, String email) async {
    final bookDocRef = books
        .doc('${book.title} - ${book.author}')
        .collection('reviews')
        .doc(email);
    await bookDocRef.update(review.toMap());
  }

  Future<void> deleteReview(Book book, String email) async {
    final bookDocRef = books
        .doc('${book.title} - ${book.author}')
        .collection('reviews')
        .doc(email);
    await bookDocRef.delete();
  }

  Stream<List<Review>> getBookReviews(Book book) {
    return books
        .doc('${book.title} - ${book.author}')
        .collection('reviews')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Review.fromMap(doc.data());
      }).toList();
    });
  }
}
