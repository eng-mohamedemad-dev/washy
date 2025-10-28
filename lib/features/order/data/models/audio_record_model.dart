import 'dart:convert';
import '../../domain/entities/audio_record.dart';

/// AudioRecord data model for serialization
class AudioRecordModel extends AudioRecord {
  const AudioRecordModel({
    required super.filePath,
    required super.durationInSeconds,
    required super.recordedAt,
    super.fileName,
    super.fileSize,
  });

  /// Create from JSON (matching Java AudioRecord)
  factory AudioRecordModel.fromJson(Map<String, dynamic> json) {
    return AudioRecordModel(
      filePath: json['file_path'] ?? '',
      durationInSeconds: json['duration_in_seconds'] ?? 0,
      recordedAt: DateTime.tryParse(json['recorded_at'] ?? '') ?? DateTime.now(),
      fileName: json['file_name'],
      fileSize: json['file_size'],
    );
  }

  /// Convert to JSON (matching Java AudioRecord)
  Map<String, dynamic> toJson() {
    return {
      'file_path': filePath,
      'duration_in_seconds': durationInSeconds,
      'recorded_at': recordedAt.toIso8601String(),
      'file_name': fileName,
      'file_size': fileSize,
    };
  }

  /// Create from entity
  factory AudioRecordModel.fromEntity(AudioRecord entity) {
    return AudioRecordModel(
      filePath: entity.filePath,
      durationInSeconds: entity.durationInSeconds,
      recordedAt: entity.recordedAt,
      fileName: entity.fileName,
      fileSize: entity.fileSize,
    );
  }

  /// Convert to JSON string
  String toJsonString() => json.encode(toJson());

  /// Create from JSON string
  static AudioRecordModel fromJsonString(String jsonString) =>
      AudioRecordModel.fromJson(json.decode(jsonString));

  /// Copy with updated values (override to return AudioRecordModel)
  @override
  AudioRecordModel copyWith({
    String? filePath,
    int? durationInSeconds,
    DateTime? recordedAt,
    String? fileName,
    int? fileSize,
  }) {
    return AudioRecordModel(
      filePath: filePath ?? this.filePath,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      recordedAt: recordedAt ?? this.recordedAt,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}
