import 'package:equatable/equatable.dart';

/// Load more object for pagination matching Java LoadMoreObject
/// Handles pagination state for orders list
class LoadMoreObject extends Equatable {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final bool isLoading;

  const LoadMoreObject({
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    this.isLoading = false,
  });

  /// Initial page number (matching Java implementation)
  static const int initialPage = 1;

  /// Create a copy with updated values
  LoadMoreObject copyWith({
    int? currentPage,
    int? totalPages,
    int? totalItems,
    bool? isLoading,
  }) {
    return LoadMoreObject(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalItems: totalItems ?? this.totalItems,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  /// Create initial LoadMoreObject
  factory LoadMoreObject.initial() {
    return const LoadMoreObject(
      currentPage: initialPage,
      totalPages: 0,
      totalItems: 0,
      isLoading: false,
    );
  }

  /// Check if should fetch more pages
  bool shouldFetchMore() {
    return currentPage < totalPages && !isLoading;
  }

  /// Get next page number
  int getNextPage() {
    return currentPage + 1;
  }

  /// Check if this is the first page
  bool get isFirstPage {
    return currentPage == initialPage;
  }

  /// Check if this is the last page
  bool get isLastPage {
    return currentPage >= totalPages;
  }

  /// Check if there are any items
  bool get hasItems {
    return totalItems > 0;
  }

  /// Increase page (matching Java increasePage method)
  LoadMoreObject increasePage() {
    return copyWith(
      currentPage: currentPage + 1,
      isLoading: false,
    );
  }

  /// Set loading state
  LoadMoreObject setLoading(bool loading) {
    return copyWith(isLoading: loading);
  }

  /// Update pagination info from API response
  LoadMoreObject updateFromResponse({
    required int totalPages,
    required int totalItems,
  }) {
    return copyWith(
      totalPages: totalPages,
      totalItems: totalItems,
    );
  }

  @override
  List<Object?> get props => [
        currentPage,
        totalPages,
        totalItems,
        isLoading,
      ];
}



