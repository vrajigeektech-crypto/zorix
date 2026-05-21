import 'dart:io';

enum StatusType { image, video }

class StatusItem {
  StatusItem({
    required this.file,
    required this.type,
  });

  final File file;
  final StatusType type;

  String get name => file.path.split('/').last;
}
