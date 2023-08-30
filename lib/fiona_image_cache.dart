library fiona_cache;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:fiona_image_cache/src/domain/cache_file.dart';
import 'package:fiona_image_cache/src/domain/cache_file_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';
import 'package:fiona_logger/src/log/fiona_logger.dart';
import 'package:path_provider/path_provider.dart';

class FionaCache{

  final String cacheFolder = "fiona_cache";
  late String localAppPathFolder;

  FionaLogger? logger;
  late CacheFileRepository repository;

  FionaCacheManager() {
    if (!GetIt.instance.isRegistered<FionaLogger>()) {
      logger = GetIt.instance<FionaLogger>();
    }
    repository = GetIt.instance<CacheFileRepository>();

    getApplicationDocumentsDirectory().then((Directory directory) {
      localAppPathFolder = directory.path;
    });
  }

  Future<CacheFile> save(String url) async {
    String encodedUrl = Uri.encodeFull(url);

    CacheFile cacheFile = await repository.getByUrl(encodedUrl);

    if (cacheFile.isEmpty()) {
      cacheFile = await _downloadAndSave(url);
    }

    return cacheFile;
  }

  Future<CacheFile> _downloadAndSave(String url) async {
    logger?.d("FionaCacheManager->downloadAndSave: $url");

    String encodedUrl = Uri.encodeFull(url);

    var urlInBytes = utf8.encode(encodedUrl);
    String value = sha256.convert(urlInBytes).toString();
    String localName = "${value}.data";

    CacheFile cacheFile = CacheFile(-1, encodedUrl, localName);

    await downloadImage(url, _getLocalPath(cacheFile));

    logger?.d("FionaCacheManager->saving file");

    repository.save(cacheFile);

    return cacheFile;
  }

  Future<dynamic> downloadImage(String url, String localPath) async {

    File(localPath).createSync(recursive: true);

    File file = File(localPath);

    logger?.d('Downloading image from $url');
    logger?.d('file not found downloading from server');

    var bytes = await getImageBytes(url);

    await file.writeAsBytes(bytes);
    logger?.d("Writting image in ${file.path}");
    return bytes;

  }

  String _getCacheFolder(){
    return "$localAppPathFolder/$cacheFolder";
  }

  String _getLocalPath(CacheFile cacheFile) {

    String localPath = path.join(_getCacheFolder(), cacheFile.localName);

    return localPath;
  }

  Future<String> getImagePath(String url)async{

    CacheFile cacheFile =await save(url);
    return _getLocalPath(cacheFile);

  }

  Future<dynamic> getImageBytes(url) async {
    final response = await http.get(Uri.parse(url));
    logger?.d("Getting image from $url");
    if (response.statusCode == 200) {
      var bytes = await response.bodyBytes;
      if(bytes==0){
        logger?.d("Image not found $url");
        throw Exception("Image not found $url");
      }

      return bytes;
    }else{
      logger?.d("Image not found $url");
      throw Exception("Image not found $url");
    }
  }


  Future<void> cleanCache()async {
    repository.cleanAll();
  }

  Future<void> cleanOrphanFiles()async {
    List<String> urls= List.empty(growable: true);
    repository.clean(urls);
  }

}