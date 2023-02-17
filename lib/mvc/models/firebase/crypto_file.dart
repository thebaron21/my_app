

import 'dart:io';

class CryptoFile{
  final File file;
  final String type;
  final String? fileC;

  CryptoFile(this.file, this.type,{this.fileC});

  toMap() => {
    "file" : file,
    "name" : type,
  };
}

class CryptoFileUpload{
  final String file;
  final String type;

  CryptoFileUpload(this.file, this.type);

  toMap() => {
    "file" : file,
    "type" : type,
  };
}