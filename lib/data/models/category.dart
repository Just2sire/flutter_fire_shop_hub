import "dart:convert";

class Category {
  Category({required this.slug, required this.name, required this.url});

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      slug: map["slug"] as String? ?? "",
      name: map["name"] as String? ?? "",
      url: map["url"] as String? ?? "",
    );
  }

  factory Category.fromJson(String source) =>
      Category.fromMap(jsonDecode(source) as Map<String, dynamic>);
  final String slug;
  final String name;
  final String url;

  Category copyWith({String? slug, String? name, String? url}) {
    return Category(
      slug: slug ?? this.slug,
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {"slug": slug, "name": name, "url": url};
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => "Category(slug: $slug, name: $name, url: $url)";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.slug == slug &&
        other.name == name &&
        other.url == url;
  }

  @override
  int get hashCode => slug.hashCode ^ name.hashCode ^ url.hashCode;
}
