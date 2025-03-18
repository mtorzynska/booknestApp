import 'package:booknest/pages/list_specifics_page.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:booknest/providers/list_provider.dart';
import 'package:booknest/widgets/appbar_widget.dart';
import 'package:booknest/widgets/text_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ListsPage extends ConsumerStatefulWidget {
  const ListsPage({super.key});

  @override
  ConsumerState<ListsPage> createState() => _ListsPageState();
}

class _ListsPageState extends ConsumerState<ListsPage> {
  final TextEditingController listNameController = TextEditingController();

  Future<void> showAddListDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        final listService = ref.read(listServiceProvider);
        final uid = ref.watch(currentUserProvider);
        return AlertDialog(
          title: const Center(
            child: Text(
              'Enter list name',
              style: TextStyle(
                  fontSize: 23, color: Color.fromARGB(255, 255, 159, 178)),
            ),
          ),
          content: TextInputWidget(
            controller: listNameController,
            labelText: "List name",
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
                listService.createList(uid!, listNameController.text);
                Navigator.pop(context);
              },
              child: const Text(
                'Add list',
                style: TextStyle(
                    color: Color.fromARGB(255, 255, 159, 178), fontSize: 17),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final listProvider = ref.watch(userListsProvider);
    final listService = ref.watch(listServiceProvider);
    final uid = ref.read(currentUserProvider);
    return Scaffold(
      appBar: const AppBarWidget(title: 'My Lists'),
      body: listProvider.when(
        data: (lists) {
          if (lists.isEmpty) {
            return const Center(
                child: Text("No lists found. You can add a new list."));
          } else {
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
                      leading: Icon(Icons.star,
                          size: 15,
                          color: (index % 2 == 0)
                              ? Color.fromARGB(255, 255, 165, 143)
                              : Color.fromARGB(255, 202, 153, 205)),
                      trailing: lists[index].name == 'currently reading' ||
                              lists[index].name == 'to read' ||
                              lists[index].name == 'read'
                          ? null
                          : IconButton(
                              onPressed: () {
                                listService.deleteList(uid!, lists[index].name);
                              },
                              icon: const Icon(Icons.delete,
                                  color: Color.fromARGB(255, 255, 216, 167)))),
                );
              },
            );
          }
        },
        loading: () => const Center(
            child: CircularProgressIndicator(
          color: Color.fromARGB(255, 193, 219, 179),
        )),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 15, 15),
        child: FloatingActionButton(
          elevation: 0,
          backgroundColor: Color.fromARGB(255, 255, 159, 178),
          shape: CircleBorder(),
          onPressed: showAddListDialog,
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 255, 246, 220),
            size: 35,
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 255, 246, 220),
    );
  }
}
