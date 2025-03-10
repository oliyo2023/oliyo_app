class Post {
  final String id;
  final String title;
  final String content;
  final String? imageUrl;
  final DateTime created;

  Post({
    required this.id,
    required this.title,
    required this.content,
    this.imageUrl,
    required this.created,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      imageUrl: json['image'],
      created: DateTime.parse(json['created']),
    );
  }
} 