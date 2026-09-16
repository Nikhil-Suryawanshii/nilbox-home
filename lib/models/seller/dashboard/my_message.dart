class SellerPost {
  final int id;
  final String content;
  final List<String> media;

  SellerPost({
    required this.id,
    required this.content,
    required this.media,
  });

  factory SellerPost.fromMap(Map<String, dynamic> map) {
    return SellerPost(
      id: map['id'],
      content: map['content'] ?? '',
      media: (map['media'] as List? ?? [])
          .map((e) => 'https://www.nilbox.net/storage/${e['src']}')
          .toList(),
    );
  }
}
