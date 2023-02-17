import 'dart:io';

import 'package:my_app/mvc/models/firebase/crypto_file.dart';
import 'package:my_app/mvc/models/utils/rsa_utils.dart';

import '../utils/public_key.dart';

class Complaint {
  final String text;
  final Map<String, List<CryptoFile>>? filesEnd;
  final int? progressId;
  final Map<String, List<File>>? files;

  Complaint({required this.text, this.files, this.progressId, this.filesEnd});

  Future<Complaint> crypto() async {
    PublicKey keys = await RSAUtils.getPublicKey();

    String textC =
        await RSAUtils.encryptionText(text, publicKey: keys.publicKey);
    Map<String, List<CryptoFile>> filesC =
        await RSAUtils.encryptionFile(files!, publicKey: keys.publicKey);

    return Complaint(
        text: textC, filesEnd: filesC, progressId: keys.progressId);
  }
}
