class GpsData {
  final double latitude;
  final double longitude;
  final String timestamp;

  GpsData(
      {required this.latitude,
      required this.longitude,
      required this.timestamp});

  factory GpsData.fromJson(Map<String, dynamic> json) {
    var coordinates = json['coordinates'] as Map<String, dynamic>;
    return GpsData(
      latitude: coordinates['latitude']?.toDouble() ?? 0.0,
      longitude: coordinates['longitude']?.toDouble() ?? 0.0,
      timestamp: json['date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coordinates': {'latitude': latitude, 'longitude': longitude},
      'date': timestamp,
    };
  }
}
