class LastUpdate {
  final String date;
  final int timezoneType;
  final String timezone;

  LastUpdate({
    required this.date,
    required this.timezoneType,
    required this.timezone,
  });

  factory LastUpdate.fromJson(Map<String, dynamic> json) {
    return LastUpdate(
      date: json['date'],
      timezoneType: json['timezone_type'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'timezone_type': timezoneType,
      'timezone': timezone,
    };
  }
}
