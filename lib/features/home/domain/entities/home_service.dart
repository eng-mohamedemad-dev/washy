import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';

/// HomeService entity - represents a service on the home page
class HomeService extends Equatable {
  final int id;
  final String title;
  final String subtitle;
  final String price;
  final String estimatedTime;
  final String imageUrl;
  final Color color;

  const HomeService({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.estimatedTime,
    required this.imageUrl,
    required this.color,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    subtitle,
    price,
    estimatedTime,
    imageUrl,
    color,
  ];
}
