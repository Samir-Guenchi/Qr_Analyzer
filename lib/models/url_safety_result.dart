class UrlSafetyResult {
  final bool safe;
  final String message;
  final String? finalUrl; // Store the final URL after redirects

  UrlSafetyResult({
    required this.safe,
    required this.message,
    this.finalUrl,
  });

  factory UrlSafetyResult.fromJson(Map<String, dynamic> json) {
    return UrlSafetyResult(
      safe: json['safe'] as bool,
      message: json['message'] as String,
      finalUrl: json['url'] as String?,
    );
  }
} 