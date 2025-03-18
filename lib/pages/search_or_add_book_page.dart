import 'package:booknest/models/book.dart';
import 'package:booknest/pages/book_specifics_page.dart';
import 'package:booknest/providers/search_provider.dart';
import 'package:booknest/services/book_sevice.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:booknest/widgets/button_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchOrAddBookPage extends ConsumerStatefulWidget {
  const SearchOrAddBookPage({super.key});

  @override
  ConsumerState<SearchOrAddBookPage> createState() =>
      _SearchOrAddBookPageState();
}

class _SearchOrAddBookPageState extends ConsumerState<SearchOrAddBookPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController pagesController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController subgenreController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final BookService bookService = BookService();
  List<Book> booksSearched = [];
  bool isSearching = false;

  // @override
  // void dispose() {
  //   ref.read(searchInputProvider.notifier).state = '';
  //   super.dispose();
  // }

  Book makeBookFromInput(String title, String author, int pages, String genre,
      String subgenre, String url) {
    return Book(
        title: title,
        author: author,
        pages: pages,
        genre: genre,
        subgenre: subgenre,
        imageUrl: url);
  }

  Book makeBookFromInputWithoutSubgenre(
      String title, String author, int pages, String genre, String url) {
    return Book(
        title: title,
        author: author,
        pages: pages,
        genre: genre,
        imageUrl: url);
  }

  Future<void> addBook() async {
    try {
      Book newBook;
      String url;
      if (imageUrlController.text.isEmpty) {
        url = '';
      } else {
        url = imageUrlController.text;
      }
      if (titleController.text.isNotEmpty &&
          authorController.text.isNotEmpty &&
          pagesController.text.isNotEmpty &&
          genreController.text.isNotEmpty) {
        if (subgenreController.text.isEmpty) {
          newBook = makeBookFromInputWithoutSubgenre(
              titleController.text,
              authorController.text,
              int.parse(pagesController.text),
              genreController.text,
              url);
        } else {
          newBook = makeBookFromInput(
              titleController.text,
              authorController.text,
              int.parse(pagesController.text),
              genreController.text,
              subgenreController.text,
              url);
        }
        await bookService.addBook(newBook);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Book added successfully!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                textAlign: TextAlign.center,
                "You must provide the book's title, author, number of pages and genre."),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 255, 165, 143),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: const AppBarWidget(title: "Search or add books"),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: Column(
            children: [
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(
                controller: searchController,
                labelText: "Search by title",
                onChanged: (input) {
                  ref.read(searchInputProvider.notifier).state = input;
                },
              ),
              SizedBox(
                height: 100,
                child: searchResults.when(
                  data: (books) {
                    if (books.isEmpty && searchController.text.isNotEmpty) {
                      return const Text(
                        "Book not found.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 159, 178)),
                      );
                    } else {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => BookSpecificsPage(
                                          book: books[index])));
                            },
                            title: Text(books[index].title,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 202, 153, 205),
                                  fontSize: 18,
                                )),
                            subtitle: Text(books[index].author,
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 202, 153, 205),
                                  fontSize: 15,
                                )),
                          );
                        },
                      );
                    }
                  },
                  loading: () => const SizedBox(
                      width: 200,
                      height: 10,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 193, 219, 179)))),
                  error: (error, stack) => Text('Error: $error'),
                ),
              ),
              const Text("Couldn't find your book? Add it below!",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 159, 178),
                    fontSize: 17,
                  )),
              TextInputWidget(controller: titleController, labelText: "title"),
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(
                  controller: authorController, labelText: "author"),
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(controller: pagesController, labelText: "pages"),
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(controller: genreController, labelText: "genre"),
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(
                  controller: subgenreController, labelText: "subgenre"),
              const SizedBox(
                height: 5,
              ),
              TextInputWidget(
                  controller: imageUrlController,
                  labelText: "cover picture url"),
              const SizedBox(
                height: 10,
              ),
              ButtonWidget(
                  onPressed: addBook, text: "Add book to the BookNest database")
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
    );
  }
}
