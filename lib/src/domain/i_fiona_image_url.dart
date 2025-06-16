import 'dart:async';
import 'dart:io';

///Gets the image file from an url
abstract class IFionaImageUrl {
  Future<File?> imageUrlToFile(String imageUrl, String fullLocalName);

  Future<dynamic> getImageBytes(url);
}
