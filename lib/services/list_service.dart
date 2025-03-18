import 'package:booknest/models/book.dart';
import 'package:booknest/models/list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createList(String uid, String listName) async {
    await firestore
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listName)
        .set({'name': listName});
  }

  Future<void> addBookToList(String uid, String listName, Book book) async {
    final userDocRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final booksCollection =
        userDocRef.collection('lists').doc(listName).collection('books');

    final bookReference = FirebaseFirestore.instance
        .collection('books')
        .doc('${book.title} - ${book.author}');

    await booksCollection.doc('${book.title} - ${book.author}').set({
      'book': bookReference,
    });
  }

  Stream<List<BookList>> getUserLists(String uid) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('lists')
        .snapshots()
        .asyncMap((snapshot) async {
      List<BookList> lists = [];
      for (var doc in snapshot.docs) {
        var booksSnapshot = await doc.reference.collection('books').get();
        List<Book> books = [];
        for (var bookDoc in booksSnapshot.docs) {
          DocumentReference bookRef = bookDoc.data()['book'];
          var bookSnapshot = await bookRef.get();
          books.add(Book.fromMap(bookSnapshot.data() as Map<String, dynamic>));
        }
        lists.add(BookList(name: doc.id, contents: books));
      }
      return lists;
    });
  }

  Stream<BookList> getListContents(String uid, String listName) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listName)
        .collection('books')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Book> books = [];
      for (var doc in snapshot.docs) {
        DocumentReference bookRef = doc['book'];
        var bookSnapshot = await bookRef.get();
        Book book = Book.fromMap(bookSnapshot.data() as Map<String, dynamic>);
        books.add(book);
      }
      return BookList(name: listName, contents: books);
    });
  }

  Future<bool> checkIfBookIsInTheList(
      String uid, Book book, String listName) async {
    final bookDocId = '${book.title} - ${book.author}';
    final bookRef =
        FirebaseFirestore.instance.collection('books').doc(bookDocId);

    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listName)
        .collection('books')
        .get();

    for (var doc in querySnapshot.docs) {
      DocumentReference docRef = doc['book'];
      if (docRef == (bookRef)) {
        return true;
      }
    }

    return false;
  }

  Future<void> createDefaultListsForNewUser(String uid) async {
    final defaultLists = ['currently reading', 'to read', 'read'];
    final userDoc = firestore.collection('users').doc(uid);
    for (var list in defaultLists) {
      await userDoc.collection('lists').doc(list).set({'name': list});
    }
  }

  Future<void> deleteList(String uid, String listName) {
    return firestore
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listName)
        .delete();
  }

  Future<void> deleteBookFromList(
      String uid, String listName, Book book) async {
    final bookDocRef = FirebaseFirestore.instance
        .collection('books')
        .doc('${book.title} - ${book.author}');
    final bookToDelete = await firestore
        .collection('users')
        .doc(uid)
        .collection('lists')
        .doc(listName)
        .collection('books')
        .where('book', isEqualTo: bookDocRef)
        .get();
    for (var doc in bookToDelete.docs) {
      await doc.reference.delete();
    }
  }
}
