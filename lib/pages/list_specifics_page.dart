import 'package:booknest/models/list.dart';
import 'package:booknest/pages/book_specifics_page.dart';
import 'package:booknest/pages/search_or_add_book_page.dart';
import 'package:booknest/providers/list_provider.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListSpecificsPage extends ConsumerStatefulWidget {
  const ListSpecificsPage({super.key, required this.list});
  final BookList list;

  @override
  ConsumerState<ListSpecificsPage> createState() => _ListSpecificsPageState();
}

class _ListSpecificsPageState extends ConsumerState<ListSpecificsPage> {
  @override
  Widget build(BuildContext context) {
    final listContents = ref.watch(listContentsProvider(widget.list.name));
    final listService = ref.watch(listServiceProvider);
    final uid = ref.read(currentUserProvider);
    return Scaffold(
      appBar: AppBarWidget(title: widget.list.name, arrow: true),
      backgroundColor: const Color.fromARGB(255, 255, 246, 220),
      body: listContents.when(
        data: (currentlist) {
          if (currentlist.contents.isEmpty) {
            return const Center(
                child: Text(
              "No books here...",
              style: TextStyle(
                  fontSize: 17, color: Color.fromARGB(255, 255, 165, 143)),
            ));
          } else {
            return Padding(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
              child: ListView.builder(
                itemCount: currentlist.contents.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(currentlist.contents[index].title,
                        style: TextStyle(
                          color: (index % 2 == 0)
                              ? Color.fromARGB(255, 255, 165, 143)
                              : Color.fromARGB(255, 202, 153, 205),
                          fontSize: 20,
                        )),
                    subtitle: Text(currentlist.contents[index].author,
                        style: TextStyle(
                          color: (index % 2 == 0)
                              ? Color.fromARGB(255, 255, 165, 143)
                              : Color.fromARGB(255, 202, 153, 205),
                          fontSize: 16,
                        )),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => BookSpecificsPage(
                                book: currentlist.contents[index])))),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete,
                          color: Color.fromARGB(255, 255, 216, 167)),
                      onPressed: () {
                        listService.deleteBookFromList(uid!, currentlist.name,
                            currentlist.contents[index]);
                      },
                    ),
                  );
                },
              ),
            );
          }
        },
        error: (error, stackTrace) => Text("error: $error"),
        loading: () => const Center(
            child: CircularProgressIndicator(
          color: Color.fromARGB(255, 193, 219, 179),
        )),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 255, 159, 178),
          shape: CircleBorder(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SearchOrAddBookPage(),
              ),
            );
          },
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 246, 220),
            size: 35,
          ),
        ),
      ),
    );
  }
}
