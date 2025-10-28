import 'package:equatable/equatable.dart';

/// Photo entity (matching Java Photo)
class Photo extends Equatable {
  final String filePath;
  final DateTime takenAt;
  final String? fileName;
  final int? fileSize;
  final String? description;

  const Photo({
    required this.filePath,
    required this.takenAt,
    this.fileName,
    this.fileSize,
    this.description,
  });

  /// Get file name from path if not provided
  String get displayName {
    if (fileName != null && fileName!.isNotEmpty) {
      return fileName!;
    }
    return filePath.split('/').last;
  }

  /// Check if file exists
  bool get hasValidPath => filePath.isNotEmpty;

  /// Get formatted file size
  String get formattedFileSize {
    if (fileSize == null) return 'Unknown size';
    
    final sizeInKB = fileSize! / 1024;
    if (sizeInKB < 1024) {
      return '${sizeInKB.toStringAsFixed(1)} KB';
    }
    
    final sizeInMB = sizeInKB / 1024;
    return '${sizeInMB.toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [
        filePath,
        takenAt,
        fileName,
        fileSize,
        description,
      ];

  /// Copy with updated values
  Photo copyWith({
    String? filePath,
    DateTime? takenAt,
    String? fileName,
    int? fileSize,
    String? description,
  }) {
    return Photo(
      filePath: filePath ?? this.filePath,
      takenAt: takenAt ?? this.takenAt,
      fileName: fileName ?? this.fileName,
      fileSize: fileSize ?? this.fileSize,
      description: description ?? this.description,
    );
  }
}
