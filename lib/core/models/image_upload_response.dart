class ImageUploadResponse {
  final String urlSmall;
  final String urlMedium;
  final String urlLarge;

  ImageUploadResponse({
    this.urlSmall = '',
    this.urlMedium = '',
    this.urlLarge = '',
  });

  String get bestUrl {
    if (urlLarge.isNotEmpty) return urlLarge;
    if (urlMedium.isNotEmpty) return urlMedium;
    return urlSmall;
  }

  factory ImageUploadResponse.fromMap(Map<String, dynamic> map) {
    return ImageUploadResponse(
      urlSmall: (map['url_small'] ?? '') as String,
      urlMedium: (map['url_medium'] ?? '') as String,
      urlLarge: (map['url_large'] ?? '') as String,
    );
  }
}
