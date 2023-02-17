import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ComplaintFilePicker {
  final FilePicker _filePicker = FilePicker.platform;

  Future<List<File>?> getSound() async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.audio,
      allowMultiple: true,
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
       return null;
    }
  }

  Future<List<File>?> getVideo() async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.video,
      allowMultiple: true
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
       return null;
    }
  }

  Future<List<File>?> getPicture() async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.image,
      allowMultiple: true
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
      return null;
    }
  }

  Future<List<File>?>  getDocument() async {
    FilePickerResult? result = await _filePicker.pickFiles(
      type: FileType.custom,
      allowMultiple: true,
      allowedExtensions: ["pdf" , "docs" , "docx"]
    );
    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      return files;
    } else {
       return null;
    }
  }

}
