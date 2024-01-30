class Country {
  final int id;
  final String countryName;

  Country({required this.id, required this.countryName});

  factory Country.fromJson(Map<String, dynamic> json) {
    if (json['country_name'] == null) {
      throw StateError('country_name was null');
    }
    int idNumber = int.parse(json['id_number']);

    return Country(
      id: idNumber,
      countryName: json['country_name'],
    );
  }
}
