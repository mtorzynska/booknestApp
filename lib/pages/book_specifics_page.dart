import 'package:booknest/models/book.dart';
import 'package:booknest/models/review.dart';
import 'package:booknest/models/user.dart';
import 'package:booknest/pages/add_book_to_list_page.dart';
import 'package:booknest/providers/book_provider.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookSpecificsPage extends ConsumerStatefulWidget {
  final Book book;
  const BookSpecificsPage({super.key, required this.book});

  @override
  ConsumerState<BookSpecificsPage> createState() => _BookSpecificsPageState();
}

class _BookSpecificsPageState extends ConsumerState<BookSpecificsPage> {
  TextEditingController urlController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  bool didUserReview = false;
  late String currentImage;

  @override
  void initState() {
    super.initState();
    checkUserReview();
    currentImage = widget.book.imageUrl;
  }

  Future<void> checkUserReview() async {
    final uid = ref.read(currentUserProvider);
    final bookService = ref.read(bookServiceProvider);
    bool value = await bookService.checkIfReviewed(uid!, widget.book);
    setState(() {
      didUserReview = value;
    });
  }

  Future<void> showAddReviewDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final bookService = ref.read(bookServiceProvider);
        final userService = ref.read(userServiceProvider);
        final uid = ref.watch(currentUserProvider);

        return AlertDialog(
          title: Text(
            !didUserReview ? 'Write your review' : 'Edit your review',
            style: const TextStyle(
                fontSize: 23, color: Color.fromARGB(255, 255, 159, 178)),
          ),
          content: TextInputWidget(
            controller: reviewController,
            lines: 5,
            labelText: "Your review...",
          ),
          actions: <Widget>[
            if (didUserReview)
              IconButton(
                onPressed: () async {
                  final email = await userService.getUserEmail(uid!);
                  await bookService.deleteReview(widget.book, email);
                  setState(() {
                    didUserReview = false;
                  });
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 255, 159, 178)),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
              ),
            ),
            TextButton(
                onPressed: () async {
                  final username = await userService.getUsername(uid!);
                  final email = await userService.getUserEmail(uid);
                  if (!didUserReview) {
                    bookService.addReviewToBook(
                      widget.book,
                      Review(
                          review: reviewController.text,
                          user:
                              User(username: username, email: email, uid: uid)),
                    );
                  } else {
                    bookService.updateReview(
                        widget.book,
                        Review(
                            review: reviewController.text,
                            user: User(
                                username: username, email: email, uid: uid)),
                        email);
                  }
                  await checkUserReview();
                  Navigator.pop(context);
                },
                child: Text(
                  !didUserReview ? 'Add review' : 'Edit review',
                  style: const TextStyle(
                      color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
                )),
          ],
        );
      },
    );
  }

  Future<void> showEditCoverDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final bookService = ref.watch(bookServiceProvider);
        return AlertDialog(
          title: const Text(
            'Update cover picture',
            style: TextStyle(
                fontSize: 23, color: Color.fromARGB(255, 255, 159, 178)),
          ),
          content: TextInputWidget(
            controller: urlController,
            labelText: "Image URL",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
              ),
            ),
            TextButton(
                onPressed: () async {
                  Book updatedBook = Book(
                      title: widget.book.title,
                      author: widget.book.author,
                      pages: widget.book.pages,
                      genre: widget.book.genre,
                      subgenre: widget.book.subgenre,
                      imageUrl: urlController.text);
                  bookService.updateBook(updatedBook,
                      '${widget.book.title} - ${widget.book.author}');
                  setState(() {
                    currentImage = urlController.text;
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  'Update image',
                  style: TextStyle(
                      color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
                )),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final reviewService = ref.watch(bookReviewsProvider(widget.book));
    final bookSpecifics = ref.watch(bookSpecificsProvider(widget.book));

    return Scaffold(
        backgroundColor: Color.fromARGB(255, 255, 246, 220),
        appBar: AppBarWidget(
          title: widget.book.title,
          arrow: true,
        ),
        body: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            bookSpecifics.when(
                data: (book) {
                  return Column(
                    children: [
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (book.imageUrl == '')
                              Image.asset('assets/images/no_cover.jpg',
                                  height: 210, width: 140, fit: BoxFit.cover)
                            else if (book.imageUrl != '')
                              Image.network(
                                book.imageUrl,
                                height: 210,
                                width: 140,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/no_cover.jpg',
                                    height: 210,
                                    width: 140,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color.fromARGB(255, 128, 162, 121),
                              ),
                              onPressed: showEditCoverDialog,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Container(
                            padding: EdgeInsets.fromLTRB(100, 15, 100, 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Color.fromARGB(255, 202, 153, 205)),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${book.title}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 246, 220),
                                        fontSize: 21,
                                      )),
                                  Text(
                                    'by ${book.author}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 246, 220),
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text('${book.pages} pages',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 246, 220),
                                        fontSize: 15,
                                      )),
                                  Text('genre: ${book.genre}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 246, 220),
                                        fontSize: 15,
                                      )),
                                  Text('subgenre: ${book.subgenre}',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color:
                                            Color.fromARGB(255, 255, 246, 220),
                                        fontSize: 15,
                                      ))
                                ])),
                      )
                    ],
                  );
                },
                error: ((error, stackTrace) => Text('error $error')),
                loading: () => const Center(
                        child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 193, 219, 179),
                    ))),
            const SizedBox(
              height: 3,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                AddBookToListPage(bookToAdd: widget.book)));
                  },
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 202, 153, 205)),
                    foregroundColor: MaterialStateProperty.all(
                        const Color.fromARGB(255, 255, 246, 220)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Add to list"),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.add)
                    ],
                  )),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () => showAddReviewDialog(),
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all(0),
                  backgroundColor: MaterialStateProperty.all(
                      Color.fromARGB(255, 202, 153, 205)),
                  foregroundColor: MaterialStateProperty.all(
                      const Color.fromARGB(255, 255, 246, 220)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      !didUserReview ? 'Add review' : 'Edit review',
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Icon(!didUserReview ? Icons.add : Icons.edit)
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Container(
                padding: EdgeInsets.fromLTRB(100, 5, 100, 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color.fromARGB(255, 255, 165, 143)),
                child: Text(
                  textAlign: TextAlign.center,
                  "Reviews of ${widget.book.title}",
                  style: const TextStyle(
                      fontSize: 17, color: Color.fromARGB(255, 255, 246, 220)),
                ),
              ),
            ),
            Expanded(
              child: reviewService.when(
                data: (reviews) {
                  if (reviews.isEmpty) {
                    return const SizedBox(
                      child: Center(
                        child: Text(
                          "No reviews yet...",
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 165, 143),
                            fontSize: 17,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                      child: ListView.builder(
                          itemCount: reviews.length,
                          shrinkWrap: true,
                          itemBuilder: ((context, index) {
                            return ListTile(
                                subtitle: Text(reviews[index].review,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 255, 165, 143),
                                      fontSize: 17,
                                    )),
                                title: Text(reviews[index].user.username,
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 202, 153, 205),
                                      fontSize: 19,
                                    )));
                          })),
                    );
                  }
                },
                error: ((error, stackTrace) => Center(
                      child: Text("Error fetching reviews: $error"),
                    )),
                loading: () => const Center(
                    child: CircularProgressIndicator(
                  color: Color.fromARGB(255, 193, 219, 179),
                )),
              ),
            )
          ],
        ));
  }
}
