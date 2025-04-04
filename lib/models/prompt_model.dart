class Prompt {
  String id;
  String title;
  String content;
  String? link;

  Prompt({
    required this.id,
    required this.title,
    required this.content,
    this.link,
  });

  // 从JSON转换为Prompt对象
  factory Prompt.fromJson(Map<String, dynamic> json) {
    return Prompt(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      link: json['link'],
    );
  }

  // 将Prompt对象转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'link': link,
    };
  }

  // 创建Prompt的副本
  Prompt copyWith({
    String? id,
    String? title,
    String? content,
    String? link,
  }) {
    return Prompt(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      link: link ?? this.link,
    );
  }
}