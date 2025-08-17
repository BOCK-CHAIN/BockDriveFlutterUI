enum DriveItemType {
  folder,
  pdf,
  spreadsheet,
  document,
  image,
  video,
  audio,
  archive,
  other,
}

class DriveItem {
  final String name;
  final DriveItemType type;
  final String size;
  final String lastModified;
  final String? path;
  final bool isShared;
  final String? owner;
  final String? location;
  final String? reasonSuggested;

  DriveItem({
    required this.name,
    required this.type,
    required this.size,
    required this.lastModified,
    this.path,
    this.isShared = false,
    this.owner,
    this.location,
    this.reasonSuggested,
  });

  DriveItem copyWith({
    String? name,
    DriveItemType? type,
    String? size,
    String? lastModified,
    String? path,
    bool? isShared,
    String? owner,
    String? location,
    String? reasonSuggested,
  }) {
    return DriveItem(
      name: name ?? this.name,
      type: type ?? this.type,
      size: size ?? this.size,
      lastModified: lastModified ?? this.lastModified,
      path: path ?? this.path,
      isShared: isShared ?? this.isShared,
      owner: owner ?? this.owner,
      location: location ?? this.location,
      reasonSuggested: reasonSuggested ?? this.reasonSuggested,
    );
  }
}

class StorageItem {
  final String name;
  final String size;
  final String? path;
  final DriveItemType type;

  StorageItem({
    required this.name,
    required this.size,
    this.path,
    this.type = DriveItemType.video,
  });
}

class FilePickerResult {
  final String name;
  final String? extension;
  final int size;
  final String? path;

  FilePickerResult({
    required this.name,
    this.extension,
    required this.size,
    this.path,
  });
}