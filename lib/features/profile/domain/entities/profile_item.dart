import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'profile_item_type.dart';

/// Profile Item entity (100% matching Java ProfileItem)
class ProfileItem extends Equatable {
  final String title;
  final ProfileItemType profileItemType;
  final IconData iconData;
  final String iconAssetPath;

  const ProfileItem({
    required this.title,
    required this.profileItemType,
    required this.iconData,
    required this.iconAssetPath,
  });

  @override
  List<Object?> get props => [
        title,
        profileItemType,
        iconData,
        iconAssetPath,
      ];

  /// Copy with updated values
  ProfileItem copyWith({
    String? title,
    ProfileItemType? profileItemType,
    IconData? iconData,
    String? iconAssetPath,
  }) {
    return ProfileItem(
      title: title ?? this.title,
      profileItemType: profileItemType ?? this.profileItemType,
      iconData: iconData ?? this.iconData,
      iconAssetPath: iconAssetPath ?? this.iconAssetPath,
    );
  }
}



