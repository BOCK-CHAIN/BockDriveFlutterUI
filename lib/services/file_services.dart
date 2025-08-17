import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart' as picker;
import '../models/drive_models.dart' as models;

class FileService {
  // File picker methods
  Future<List<picker.PlatformFile>?> pickFiles() async {
    try {
      picker.FilePickerResult? result = await picker.FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: picker.FileType.any,
      );

      if (result != null) {
        return result.files;
      }
    } catch (e) {
      print('Error picking files: $e');
    }
    return null;
  }

  Future<String?> pickDirectory() async {
    try {
      String? selectedDirectory = await picker.FilePicker.platform.getDirectoryPath();
      return selectedDirectory;
    } catch (e) {
      print('Error picking directory: $e');
    }
    return null;
  }

  // File type helpers
  models.DriveItemType getFileTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'pdf':
        return models.DriveItemType.pdf;
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
        return models.DriveItemType.document;
      case 'xls':
      case 'xlsx':
      case 'csv':
        return models.DriveItemType.spreadsheet;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
      case 'svg':
        return models.DriveItemType.image;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'wmv':
      case 'flv':
      case 'webm':
        return models.DriveItemType.video;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'flac':
      case 'ogg':
        return models.DriveItemType.audio;
      case 'zip':
      case 'rar':
      case '7z':
      case 'tar':
      case 'gz':
        return models.DriveItemType.archive;
      default:
        return models.DriveItemType.other;
    }
  }

  IconData getFileIcon(models.DriveItemType type) {
    switch (type) {
      case models.DriveItemType.folder:
        return Icons.folder;
      case models.DriveItemType.pdf:
        return Icons.picture_as_pdf;
      case models.DriveItemType.spreadsheet:
        return Icons.table_chart;
      case models.DriveItemType.document:
        return Icons.description;
      case models.DriveItemType.image:
        return Icons.image;
      case models.DriveItemType.video:
        return Icons.videocam;
      case models.DriveItemType.audio:
        return Icons.audiotrack;
      case models.DriveItemType.archive:
        return Icons.archive;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color getFileColor(models.DriveItemType type) {
    switch (type) {
      case models.DriveItemType.folder:
        return const Color(0xFF1A73E8);
      case models.DriveItemType.pdf:
        return const Color(0xFFEA4335);
      case models.DriveItemType.spreadsheet:
        return const Color(0xFF34A853);
      case models.DriveItemType.document:
        return const Color(0xFF4285F4);
      case models.DriveItemType.image:
        return const Color(0xFFFF6D01);
      case models.DriveItemType.video:
        return const Color(0xFFEA4335);
      case models.DriveItemType.audio:
        return const Color(0xFF9C27B0);
      case models.DriveItemType.archive:
        return const Color(0xFF795548);
      default:
        return const Color(0xFF5F6368);
    }
  }

  String formatFileSize(int bytes) {
    if (bytes <= 0) return '0 B';
    
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    int i = 0;
    double size = bytes.toDouble();
    
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    
    return '${size.toStringAsFixed(size % 1 == 0 ? 0 : 1)} ${suffixes[i]}';
  }

  String getFileExtension(String filename) {
    int dotIndex = filename.lastIndexOf('.');
    if (dotIndex == -1) return '';
    return filename.substring(dotIndex + 1);
  }

  bool isImageFile(String extension) {
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'];
    return imageExtensions.contains(extension.toLowerCase());
  }

  bool isVideoFile(String extension) {
    const videoExtensions = ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'];
    return videoExtensions.contains(extension.toLowerCase());
  }

  bool isAudioFile(String extension) {
    const audioExtensions = ['mp3', 'wav', 'aac', 'flac', 'ogg'];
    return audioExtensions.contains(extension.toLowerCase());
  }

  bool isDocumentFile(String extension) {
    const documentExtensions = ['pdf', 'doc', 'docx', 'txt', 'rtf', 'xls', 'xlsx', 'csv'];
    return documentExtensions.contains(extension.toLowerCase());
  }
}