import 'dart:convert';

import 'package:flutter/services.dart';

class LocalContentDataSource {
  LocalContentDataSource({
    this.assetPath = 'assets/data/local_content_manifest.json',
  });

  final String assetPath;

  Future<Map<String, dynamic>> loadManifest() async {
    final raw = await rootBundle.loadString(assetPath);
    return jsonDecode(raw) as Map<String, dynamic>;
  }
}
