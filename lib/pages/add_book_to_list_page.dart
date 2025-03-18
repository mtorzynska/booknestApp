import 'package:booknest/models/book.dart';
import 'package:booknest/pages/list_specifics_page.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/providers/list_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddBookToListPage extends ConsumerStatefulWidget {
  final Book bookToAdd;
  const AddBookToListPage({super.key, required this.bookToAdd});

  @override
  ConsumerState<AddBookToListPage> createState() => _AddBookToListPageState();
}

class _AddBookToListPageState extends ConsumerState<AddBookToListPage> {
  Future<void> addBookToList(String listname) async {
    final listService = ref.read(listServiceProvider);
    final uid = ref.read(currentUserProvider);
    if (await listService.checkIfBookIsInTheList(
        uid!, widget.bookToAdd, listname)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
          "This book is already in that list!",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color.fromARGB(255, 255, 159, 178),
        duration: Duration(milliseconds: 1000),
      ));
    } else {
      try {
        listService.addBookToList(uid, listname, widget.bookToAdd);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Book added to list $listname",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromARGB(255, 255, 251, 238)),
          ),
          backgroundColor: Color.fromARGB(255, 193, 219, 179),
          duration: const Duration(milliseconds: 1000),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error: $e"),
          duration: const Duration(milliseconds: 1000),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = ref.watch(userListsProvider);

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Add ${widget.bookToAdd.title} to your lists',
        arrow: true,
      ),
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
      body: listProvider.when(
        data: (lists) {
          return ListView.builder(
            itemCount: lists.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ListSpecificsPage(list: lists[index]),
                      ),
                    );
                  },
                  title: Text(lists[index].name,
                      style: TextStyle(
                        color: (index % 2 == 0)
                            ? Color.fromARGB(255, 255, 165, 143)
                            : Color.fromARGB(255, 202, 153, 205),
                        fontSize: 22,
                      )),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.add_circle_outline_sharp,
                      color: (index % 2 == 0)
                          ? Color.fromARGB(255, 255, 165, 143)
                          : Color.fromARGB(255, 202, 153, 205),
                      size: 28,
                    ),
                    onPressed: () => addBookToList(lists[index].name),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
