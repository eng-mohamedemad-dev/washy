import 'dart:convert';

class LandingPageResponse {
  final LandingData? data;

  LandingPageResponse({this.data});

  factory LandingPageResponse.fromJson(Map<String, dynamic> json) {
    return LandingPageResponse(
      data: json['data'] != null ? LandingData.fromJson(json['data']) : null,
    );
  }

  static LandingPageResponse fromRawJson(String str) =>
      LandingPageResponse.fromJson(json.decode(str) as Map<String, dynamic>);
}

class LandingData {
  final List<BannerItem> bannersItems;
  final List<LandingItem> landingItems;

  LandingData({required this.bannersItems, required this.landingItems});

  factory LandingData.fromJson(Map<String, dynamic> json) {
    final banners = (json['landing_banners'] as List<dynamic>? ?? [])
        .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final items = (json['landing_items'] as List<dynamic>? ?? [])
        .map((e) => LandingItem.fromJson(e as Map<String, dynamic>))
        .toList();
    return LandingData(bannersItems: banners, landingItems: items);
  }
}

class BannerItem {
  final String? image;
  final String? deepLink;

  BannerItem({this.image, this.deepLink});

  factory BannerItem.fromJson(Map<String, dynamic> json) => BannerItem(
        image: json['banner_image'] as String?,
        deepLink: json['banner_deeplink'] as String?,
      );
}

class LandingItem {
  final String? title;
  final String? image; // هذا يحتوي على URL الصورة من الباك إند (من حقل 'icon' في JSON)
  final String? deeplink;

  LandingItem({this.title, this.image, this.deeplink});

  factory LandingItem.fromJson(Map<String, dynamic> json) => LandingItem(
        title: json['title'] as String? ?? json['name'] as String?,
        // CRITICAL: الباك إند يرجع الحقل باسم 'icon' وليس 'image'
        // من JSON: "icon": "https://storage.washywash.com/image/catalog/Landing page/icons8-shirt-64.png"
        image: json['icon'] as String? ?? json['image'] as String?,
        deeplink: json['deeplink'] as String? ?? json['deep_link'] as String?,
      );
}


