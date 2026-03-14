import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

/// Service for compressing images before upload
class ImageCompressionService {
  /// Compress image with high quality (for property images)
  /// Returns compressed file or original if compression fails
  static Future<File> compressPropertyImage(File file) async {
    try {
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      // Compress image
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 1920,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        
        // Check if compression actually reduced file size
        final originalSize = await file.length();
        final compressedSize = await compressedFile.length();
        
        // If compressed size is smaller, use it; otherwise use original
        if (compressedSize < originalSize) {
          return compressedFile;
        }
      }
      
      return file;
    } catch (e) {
      // If compression fails, return original file
      return file;
    }
  }

  /// Compress image with medium quality (for profile/logo images)
  /// Returns compressed file or original if compression fails
  static Future<File> compressProfileImage(File file) async {
    try {
      // Get temp directory
      final tempDir = await getTemporaryDirectory();
      final targetPath = path.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}_compressed.jpg',
      );

      // Compress image
      final result = await FlutterImageCompress.compressAndGetFile(
        file.absolute.path,
        targetPath,
        quality: 85,
        minWidth: 1024,
        minHeight: 1024,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final compressedFile = File(result.path);
        
        // Check if compression actually reduced file size
        final originalSize = await file.length();
        final compressedSize = await compressedFile.length();
        
        // If compressed size is smaller, use it; otherwise use original
        if (compressedSize < originalSize) {
          return compressedFile;
        }
      }
      
      return file;
    } catch (e) {
      // If compression fails, return original file
      return file;
    }
  }

  /// Compress multiple images in parallel
  static Future<List<File>> compressMultipleImages(
    List<File> files, {
    bool isPropertyImages = true,
  }) async {
    final futures = files.map((file) {
      return isPropertyImages
          ? compressPropertyImage(file)
          : compressProfileImage(file);
    }).toList();

    return await Future.wait(futures);
  }

  /// Get file size in MB
  static Future<double> getFileSizeInMB(File file) async {
    final bytes = await file.length();
    return bytes / (1024 * 1024);
  }

  /// Check if file needs compression (larger than 1MB)
  static Future<bool> needsCompression(File file) async {
    final sizeInMB = await getFileSizeInMB(file);
    return sizeInMB > 1.0;
  }
}
