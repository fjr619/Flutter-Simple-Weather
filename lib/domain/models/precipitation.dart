class Precipitation {
  double oneHour;

  Precipitation({required this.oneHour});

  factory Precipitation.fromJson(Map<String, dynamic> json) {
    return Precipitation(
      oneHour: json['1h'].toDouble(),
    );
  }
}