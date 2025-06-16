import 'dart:async';
import 'package:fiona_image_cache/src/domain/cache_file.dart';

///Repository to manage cached files
abstract class CacheFileRepository {
  ///Saves cache file
  Future<void> save(CacheFile cacheFile);

  ///Gets chage file by burl
  Future<CacheFile> getByUrl(String url);

  ///Cleans cached urls.
  Future<void> clean(List<String> urls);

  ///Cleans all cached urls.
  Future<void> cleanAll();
}
