class Links {
  final String? url;
  final String? label;
  final bool active;

  Links({
    this.url,
    this.label,
    this.active = false,
  });

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      url: json['url'],
      label: json['label'],
      active: json['active'],
    );
  }
}
