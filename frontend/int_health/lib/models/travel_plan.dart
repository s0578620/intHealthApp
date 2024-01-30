class TravelPlan {
  String countryName;
  DateTime startDate;
  DateTime endDate;

  TravelPlan({
    required this.countryName,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'countryName': countryName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
    };
  }
}
