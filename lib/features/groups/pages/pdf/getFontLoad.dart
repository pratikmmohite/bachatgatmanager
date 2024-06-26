/*
 * Copyright (C) 2024-present Pratik Mohite, Inc - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Author: Pratik Mohite <dev.pratikm@gmail.com>
*/
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw; // Assuming you're using pdf package

class FontLoaders {
  static Future<pw.Font> loadFont(String fontAssetPath) async {
// Load font data from the asset
    final ByteData fontData = await rootBundle.load(fontAssetPath);

// Create the Font object
    final font = pw.Font.ttf(fontData.buffer.asByteData());

    return font;
  }
}
