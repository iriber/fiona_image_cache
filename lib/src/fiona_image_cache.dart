import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fiona_image_cache/src/domain/cache_file.dart';
import 'package:fiona_image_cache/src/domain/cache_file_repository.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';


class FionaImageCache {
  final String defaultCacheFolder = "fiona_cache";
  String cacheFolder;

  CacheFileRepository repository;

  FionaImageCache({required this.repository, required this.cacheFolder});

  FutureOr<CacheFile> save(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    CacheFile cacheFile = await repository.getByUrl(encodedUrl);

    if (cacheFile.isEmpty()) {
      cacheFile = await _downloadAndSave(url);
    }

    return cacheFile;
  }

  FutureOr<CacheFile> _downloadAndSave(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    String extension="dat";
    if(encodedUrl.split(".").length>0){
      extension = encodedUrl.split(".").last;
      if(extension.length!=3){
        extension="dat";
      }
    }

    var urlInBytes = utf8.encode(encodedUrl);
    String value = sha256.convert(urlInBytes).toString();
    String localName = "$value.$extension";

    CacheFile cacheFile = CacheFile(-1, encodedUrl, localName);

    await downloadImage(url, _getLocalPath(cacheFile));

    repository.save(cacheFile);

    return cacheFile;
  }

  FutureOr<dynamic> downloadImage(String url, String localPath) async {
    File(localPath).createSync(recursive: true);
    File file = File(localPath);
    var bytes = await getImageBytes(url);
    await file.writeAsBytes(bytes);
    return bytes;
  }

  String _getCacheFolder() {
    String path = cacheFolder??"";
    if(path.isNotEmpty)
      return path;
    else
      return defaultCacheFolder;
  }

  String _getLocalPath(CacheFile cacheFile) {
    String localPath = path.join(_getCacheFolder(), cacheFile.localName);
    return localPath;
  }

  FutureOr<String> getImagePath(String url) async {
    CacheFile cacheFile = await save(url);
    return _getLocalPath(cacheFile);
  }

  FutureOr<dynamic> getImageBytes(url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var bytes = response.bodyBytes;
      return bytes;
    } else {
      throw Exception("Image not found $url");
    }
  }

  FutureOr<void> cleanCache() async {
    repository.cleanAll();
  }

  FutureOr<void> cleanOrphanFiles() async {
    List<String> urls = List.empty(growable: true);
    repository.clean(urls);
  }
}
