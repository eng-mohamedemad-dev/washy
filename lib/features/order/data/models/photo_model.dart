import 'dart:convert';
import '../../domain/entities/photo.dart';

/// Photo data model for serialization
class PhotoModel extends Photo {
  const PhotoModel({
    required super.filePath,
    required super.takenAt,
    super.fileName,
    super.fileSize,
    super.description,
  });

  /// Create from JSON (matching Java Photo)
  factory PhotoModel.fromJson(Map<String, dynamic> json) {
    return PhotoModel(
      filePath: json['file_path'] ?? '',
      takenAt: DateTime.tryParse(json['taken_at'] ?? '') ?? DateTime.now(),
      fileName: json['file_name'],
      fileSize: json['file_size'],
      description: json['description'],
    );
  }

  /// Convert to JSON (matching Java Photo)
  Map<String, dynamic> toJson() {
    return {
      'file_path': filePath,
      'taken_at': takenAt.toIso8601String(),
      'file_name': fileName,
      'file_size': fileSize,
      'description': description,
    };
  }

  /// Create from entity
  factory PhotoModel.fromEntity(Photo entity) {
    return PhotoModel(
      filePath: entity.filePath,
      takenAt: entity.takenAt,
      fileName: entity.fileName,
      fileSize: entity.fileSize,
      description: entity.description,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static PhotoModel fromJsonString(String jsonString) =>
      PhotoModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return PhotoModel)
  @override
  PhotoModel copyWith({
    String? filePath,
    DateTime? takenAt,
    String? fileName,
    int? fileSize,
    String? description,
  }) {
    return PhotoModel(
      filePath: filePath ?? this.filePath,
      takenAt: takenAt ?? this.takenAt,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
    );
  }
}
