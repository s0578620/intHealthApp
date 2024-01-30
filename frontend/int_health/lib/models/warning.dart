class Warning {
  final String warningText;

  Warning({required this.warningText});

  factory Warning.fromJson(Map<String, dynamic> json) {
    return Warning(
      warningText: json['warning_text'] as String,
    );
  }
}


