class HomePageResponse {
  final HomePageData? data;
  HomePageResponse({this.data});
  factory HomePageResponse.fromJson(Map<String, dynamic> json) {
    return HomePageResponse(
      data: json['data'] != null ? HomePageData.fromJson(json['data']) : null,
    );
  }
}

class HomePageData {
  final List<HomeCategory> categories;
  HomePageData({required this.categories});
  factory HomePageData.fromJson(Map<String, dynamic> json) {
    final list = (json['categories'] as List<dynamic>? ?? [])
        .map((e) => HomeCategory.fromJson(e as Map<String, dynamic>))
        .toList();
    return HomePageData(categories: list);
  }
}

class HomeCategory {
  final String? title;
  final String? image;
  final String? deeplink;
  HomeCategory({this.title, this.image, this.deeplink});
  factory HomeCategory.fromJson(Map<String, dynamic> json) => HomeCategory(
        title: json['title'] as String? ?? json['name'] as String?,
        image: json['image'] as String?,
        deeplink: json['deeplink'] as String? ?? json['deep_link'] as String?,
      );
}


