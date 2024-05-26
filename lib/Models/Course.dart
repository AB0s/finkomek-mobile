class Course {
  final String id;
  final String name;
  final int cost;
  final String moduleCount;
  final String shortDescription;
  final String imageUrl;

  Course({
    required this.id,
    required this.name,
    required this.cost,
    required this.moduleCount,
    required this.shortDescription,
    required this.imageUrl,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['name'],
      cost: json['cost'],
      moduleCount: json['module_count'],
      shortDescription: json['short_description'],
      imageUrl: json['image_url'],
    );
  }
}
