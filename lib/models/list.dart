import 'dart:convert';
import 'package:booknest/models/book.dart';

class BookList {
  final String name;
  final List<Book> contents;

  BookList({
    required this.name,
    required this.contents,
  });

  BookList copyWith({
    String? name,
    List<Book>? contents,
  }) {
    return BookList(
      name: name ?? this.name,
      contents: contents ?? this.contents,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'contents': contents.map((x) => x.toMap()).toList(),
    };
  }

  factory BookList.fromMap(Map<String, dynamic> map) {
    return BookList(
      name: map['name'] as String,
      contents: List<Book>.from(
        (map['contents'] as List<dynamic>).map<Book>(
          (x) => Book.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory BookList.fromJson(String source) =>
      BookList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'BookList(name: $name, contents: $contents)';

  @override
  bool operator ==(covariant BookList other) {
    if (identical(this, other)) return true;

    return other.name == name && other.contents == contents;
  }

  @override
  int get hashCode => name.hashCode ^ contents.hashCode;
}
