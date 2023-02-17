import 'dart:io';

class EncryptionItem {
  late Object? element;
  final int progressId;
  late List<File>? files;

  EncryptionItem({this.files, this.element, required this.progressId});

  EncryptionItem.toObject(p, e)
      : element = e,
        progressId = p;

  EncryptionItem.toFile(file, prog)
      : files = file,
        progressId = prog;
}
