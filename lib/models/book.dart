import 'dart:convert';

class Book {
  final String title;
  final String author;
  final int pages;
  final String genre;
  final String subgenre;
  final String imageUrl;
  Book({
    required this.title,
    required this.author,
    required this.pages,
    required this.genre,
    this.subgenre = 'not specified',
    this.imageUrl = '',
  });

  Book copyWith({
    String? title,
    String? author,
    int? pages,
    String? genre,
    String? subgenre,
    String? imageUrl,
  }) {
    return Book(
      title: title ?? this.title,
      author: author ?? this.author,
      pages: pages ?? this.pages,
      genre: genre ?? this.genre,
      subgenre: subgenre ?? this.subgenre,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'author': author,
      'pages': pages,
      'genre': genre,
      'subgenre': subgenre,
      'imageUrl': imageUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      title: map['title'] as String,
      author: map['author'] as String,
      pages: map['pages'] as int,
      genre: map['genre'] as String,
      subgenre: map['subgenre'] as String,
      imageUrl: map['imageUrl'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Book.fromJson(String source) =>
      Book.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Book(title: $title, author: $author, pages: $pages, genre: $genre, subgenre: $subgenre, imageUrl: $imageUrl)';
  }

  @override
  bool operator ==(covariant Book other) {
    if (identical(this, other)) return true;

    return other.title == title &&
        other.author == author &&
        other.pages == pages &&
        other.genre == genre &&
        other.subgenre == subgenre &&
        other.imageUrl == imageUrl;
  }

  @override
  int get hashCode {
    return title.hashCode ^
        author.hashCode ^
        pages.hashCode ^
        genre.hashCode ^
        subgenre.hashCode ^
        imageUrl.hashCode;
  }
}
