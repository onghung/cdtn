class Book {
  final String id;
  final String view;
  final int price;
  final String description;
  final String content;
  final String url;
  final String name;
  final double start;
  final String sound;

  Book({
    required this.id,
    required this.view,
    required this.price,
    required this.description,
    required this.content,
    required this.url,
    required this.name,
    required this.start,
    required this.sound,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      view: json['view'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      url: json['url'] ?? '',
      name: json['name'] ?? '',
      start: json['start'] != null ? json['start'].toDouble() : 0.0,
      sound: json['sound'] ?? '',
    );
  }

  // Convert Book to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'view': view,
      'price': price,
      'description': description,
      'content': content,
      'url': url,
      'name': name,
      'start': start,
      'sound': sound,
    };
  }
}
