class DisplayName {
  final String text;
  final String languageCode;

  const DisplayName({required this.text, required this.languageCode});

  factory DisplayName.fromJson(Map<String, dynamic> json) {
    return DisplayName(
      text: json['text'],
      languageCode: json['languageCode'],
    );
  }
}
