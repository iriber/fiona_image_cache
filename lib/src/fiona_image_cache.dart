import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fiona_image_cache/src/domain/cache_file.dart';
import 'package:fiona_image_cache/src/domain/cache_file_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

/// This class represents a cache of images.

class FionaImageCache {
  ///Default cache folder name
  final String defaultCacheFolder = "fiona_image_cache";

  ///specific cache folder name
  String? cacheFolder;

  ///Repository to manage the downloaded images
  CacheFileRepository repository;

  FionaImageCache({required this.repository, this.cacheFolder});

  ///Returns the image by url
  ///Tries to get the image from the repository.
  ///If it is not there, then downloads and saves it.
  Future<String> getImagePath(String url) async {
    CacheFile cacheFile = await save(url);
    return _getLocalPath(cacheFile);
  }

  ///Saves the image into the repository
  Future<CacheFile> save(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    CacheFile cacheFile = await repository.getByUrl(encodedUrl);

    if (cacheFile.isEmpty()) {
      cacheFile = await _downloadAndSave(url);
    }

    return cacheFile;
  }

  Future<CacheFile> _downloadAndSave(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    String extension = "dat";
    if (encodedUrl.split(".").isNotEmpty) {
      extension = encodedUrl.split(".").last;
      if (extension.length != 3) {
        extension = "dat";
      }
    }

    String localName = _generateFileName(extension: extension);

    CacheFile cacheFile = CacheFile(-1, encodedUrl, localName);

    //await _downloadImage(url, _getLocalPath(cacheFile));
    await imageUrlToFile(url, _getLocalPath(cacheFile));
    repository.save(cacheFile);

    return cacheFile;
  }

  String _generateFileName({String prefix = "img", String extension = "jpg"}) {
    final timestamp = DateTime.now().microsecondsSinceEpoch;
    return "${prefix}_$timestamp.$extension";
  }

  Future<dynamic> downloadImage(String url, String localPath) async {
    File(localPath).createSync(recursive: true);
    File file = File(localPath);
    var bytes = await _getImageBytes(url);
    await file.writeAsBytes(bytes);
    return bytes;
  }

  String _getCacheFolder() {
    String path = cacheFolder ?? "";
    if (path.isNotEmpty) {
      return path;
    } else {
      return defaultCacheFolder;
    }
  }

  String _getLocalPath(CacheFile cacheFile) {
    String localPath = path.join(_getCacheFolder(), cacheFile.localName);
    return localPath;
  }

  Future<dynamic> _getImageBytes(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      return bytes;
    } else {
      throw Exception("Image not found $url");
    }
  }
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

  Future<void> cleanCache() async {
    repository.cleanAll();
  }

  Future<void> cleanOrphanFiles() async {
    List<String> urls = List.empty(growable: true);
    repository.clean(urls);
  }
}
