import 'package:booknest/pages/book_specifics_page.dart';
import 'package:booknest/pages/goals_page.dart';
import 'package:booknest/pages/home_page.dart';
import 'package:booknest/pages/lists_page.dart';
import 'package:booknest/pages/search_or_add_book_page.dart';
import 'package:booknest/providers/list_provider.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/providers/book_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:booknest/widgets/icon_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserDashboardPage extends ConsumerWidget {
  const UserDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(currentUserProvider);
    final userSer = ref.read(userServiceProvider);

    final currentlyReading =
        ref.watch(listContentsProvider('currently reading'));

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
      appBar: AppBarWidget(
        title: 'BookNest',
        arrow: false,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SearchOrAddBookPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              ref.read(currentUserProvider.notifier).state = null;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            const SizedBox(
              height: 10,
            ),
            if (uid != null)
              FutureBuilder<String>(
                future: userSer.getUsername(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 193, 219, 179),
                    ));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final username = snapshot.data ?? 'Reader';
                    return Text('Welcome, $username!',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 255, 159, 178),
                          fontSize: 25,
                        ));
                  }
                },
              ),
            const Icon(Icons.menu_book,
                color: Color.fromARGB(255, 255, 159, 178)),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 150,
              width: 390,
              child: Card(
                elevation: 0,
                color: Color.fromARGB(255, 202, 153, 205),
                child: TextButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 246, 220)),
                  ),
                  child: currentlyReading.when(
                    data: (books) {
                      if (books.contents.isEmpty) {
                        return const Center(
                            child: Text(
                          'No books currently reading',
                          style: TextStyle(fontSize: 19),
                        ));
                      }
                      final book = books.contents[0];
                      return Container(
                        child: ref.watch(bookSpecificsProvider(book)).when(
                              data: (book) {
                                return Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 30),
                                      if (book.imageUrl == '')
                                        Image.asset(
                                          'assets/images/no_cover.jpg',
                                          height: 100,
                                          width: 70,
                                          fit: BoxFit.cover,
                                        )
                                      else
                                        Image.network(
                                          book.imageUrl,
                                          height: 100,
                                          width: 70,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/no_cover.jpg',
                                              height: 100,
                                              width: 70,
                                              fit: BoxFit.cover,
                                            );
                                          },
                                        ),
                                      const SizedBox(width: 25),
                                      Text(
                                        'Currently Reading:\n ${book.title}',
                                        style: const TextStyle(fontSize: 19),
                                      )
                                    ],
                                  ),
                                );
                              },
                              loading: () => const CircularProgressIndicator(
                                color: Color.fromARGB(255, 193, 219, 179),
                              ),
                              error: (err, stack) =>
                                  Text('Error fetching book: $err'),
                            ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(
                        color: Color.fromARGB(255, 193, 219, 179)),
                    error: (err, stack) => Text('Error: $err'),
                  ),
                  onPressed: () {
                    if (currentlyReading.value!.contents.isNotEmpty) {
                      final book = currentlyReading.value!.contents[0];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                BookSpecificsPage(book: book)),
                      );
                    }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const IconRowWidget(
              icons: Icon(Icons.circle),
              iconSize: 12,
              middleIconColor: Color.fromARGB(255, 255, 159, 178),
              leftToMiddleColor: Color.fromARGB(255, 193, 219, 179),
              borderIconColor: Color.fromARGB(255, 255, 216, 167),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 150,
              width: 390,
              child: Card(
                elevation: 0,
                color: const Color.fromARGB(255, 255, 165, 143),
                child: TextButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 246, 220)),
                  ),
                  child: const Text(
                    "My lists",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ListsPage()));
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const IconRowWidget(
              icons: Icon(Icons.circle),
              iconSize: 12,
              middleIconColor: Color.fromARGB(255, 255, 159, 178),
              leftToMiddleColor: Color.fromARGB(255, 193, 219, 179),
              borderIconColor: Color.fromARGB(255, 255, 216, 167),
            ),
            const SizedBox(
              height: 8,
            ),
            SizedBox(
              width: 390,
              height: 150,
              child: Card(
                elevation: 0,
                color: const Color.fromARGB(255, 255, 216, 167),
                child: TextButton(
                  style: const ButtonStyle(
                    foregroundColor: MaterialStatePropertyAll(
                        Color.fromARGB(255, 255, 246, 220)),
                  ),
                  child: const Text(
                    "My goals",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GoalsPage()));
                  },
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
