class Site {
  final int id;
  final String name;
  final String desc;
  final String url;

  Site({
    required this.id,
    required this.name,
    required this.desc,
    required this.url,
  });

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json['id'],
        name: json['name'],
        desc: json['desc'],
        url: json['url'],
      );
}
