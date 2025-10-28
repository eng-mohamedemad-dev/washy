import 'package:equatable/equatable.dart';

/// Audio Record entity (matching Java AudioRecord)
class AudioRecord extends Equatable {
  final String filePath;
  final int durationInSeconds;
  final DateTime recordedAt;
  final String? fileName;
  final int? fileSize;

  const AudioRecord({
    required this.filePath,
    required this.durationInSeconds,
    required this.recordedAt,
    this.fileName,
    this.fileSize,
  });

  /// Get formatted duration
  String get formattedDuration {
    final minutes = (durationInSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (durationInSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Get file name from path if not provided
  String get displayName {
    if (fileName != null && fileName!.isNotEmpty) {
      return fileName!;
    }
    return filePath.split('/').last;
  }

  /// Check if file exists
  bool get hasValidPath => filePath.isNotEmpty;

  @override
  List<Object?> get props => [
        filePath,
        durationInSeconds,
        recordedAt,
        fileName,
        fileSize,
      ];

  /// Copy with updated values
  AudioRecord copyWith({
    String? filePath,
    int? durationInSeconds,
    DateTime? recordedAt,
    String? fileName,
    int? fileSize,
  }) {
    return AudioRecord(
      filePath: filePath ?? this.filePath,
      durationInSeconds: durationInSeconds ?? this.durationInSeconds,
      recordedAt: recordedAt ?? this.recordedAt,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}
