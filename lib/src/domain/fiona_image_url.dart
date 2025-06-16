import 'dart:async';
import 'dart:io';
import 'package:fiona_image_cache/src/domain/i_fiona_image_url.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

///Gets the image file from an url
class FionaImageUrl implements IFionaImageUrl {
  @override
  Future<dynamic> getImageBytes(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      return bytes;
    } else {
      throw Exception("Image not found $url");
    }
  }

  @override
  Future<File?> imageUrlToFile(String imageUrl, String fullLocalName) async {
    try {
      final response = await http.get(Uri.parse(imageUrl));

      if (response.statusCode == 200) {
        Uint8List bytes = response.bodyBytes;

        File file = File(fullLocalName);
        return await file.writeAsBytes(bytes);
      } else {
        // Error al obtener la imagen
        return null;
      }
    } catch (e) {
      // Error general
      return null;
    }
  }
}
