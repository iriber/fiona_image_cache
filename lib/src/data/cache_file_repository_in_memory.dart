import 'dart:async';
import 'package:fiona_image_cache/src/domain/cache_file.dart';
import 'package:fiona_image_cache/src/domain/cache_file_repository.dart';

/*
 * This sample repository save the cached files into memory.
 *
 * Implementing CacheFileRepository you will we able to save the
 * cached files wherever you want.
 *
 */
class CacheFileRepositoryInMemory implements CacheFileRepository {
  Map<String, CacheFile> files = {};

  @override
  FutureOr<void> save(CacheFile cacheFile) async {
    files.putIfAbsent(cacheFile.url, () => cacheFile);
  }

  @override
  FutureOr<CacheFile> getByUrl(String url) async {
    return files[url] ?? CacheFile.empty();
  }

  @override
  FutureOr<void> clean(List<String> urls) async {
    for (var i = 0; i < urls.length; i++) {
      String url = urls[i];
      files.remove(url);
    }
  }

  @override
  FutureOr<void> cleanAll() async {
    files.clear();
  }
}
