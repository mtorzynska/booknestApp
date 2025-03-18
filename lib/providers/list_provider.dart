import 'package:booknest/models/list.dart';
import 'package:booknest/providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:booknest/services/list_service.dart';

final listServiceProvider = Provider((ref) => ListService());

final userListsProvider = StreamProvider((ref) {
  final userId = ref.watch(currentUserProvider.notifier).state;
  final listService = ref.watch(listServiceProvider);
  if (userId != null) {
    return listService.getUserLists(userId);
  }
  return Stream.value([]);
});

final listContentsProvider =
    StreamProvider.family<BookList, String>((ref, listName) {
  final userId = ref.watch(currentUserProvider.notifier).state;
  final listService = ref.watch(listServiceProvider);
  if (userId != null) {
    return listService.getListContents(userId, listName);
  }
  return Stream.value(BookList(name: listName, contents: []));
});
