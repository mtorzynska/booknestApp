import 'package:booknest/providers/book_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booknest/models/book.dart';

final searchInputProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = StreamProvider.autoDispose<List<Book>>((ref) {
  final bookService = ref.watch(bookServiceProvider);
  final searchQuery = ref.watch(searchInputProvider).toString();
  return bookService.getBooksByTitle(searchQuery);
});
