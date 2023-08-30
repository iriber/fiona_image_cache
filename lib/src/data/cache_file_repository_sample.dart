
import 'package:fiona_image_cache/src/domain/cache_file.dart';
import 'package:fiona_image_cache/src/domain/cache_file_repository.dart';

/**
 * This sample repository save the cached files into memory.
 *
 * Implementing CacheFileRepository you will we able to save the
 * cached files wherever you want.
 *
 */
class CacheFileRepositorySample implements CacheFileRepository {

  Map<String, CacheFile> files = Map<String, CacheFile>();

  Future<void> save(CacheFile cacheFile)async{
    files.putIfAbsent(cacheFile.url, () => cacheFile);
  }

  Future<CacheFile> getByUrl(String url)async{
    return files[url]??CacheFile.empty();
  }

  Future<void> clean(List<String> urls)async{
    urls.forEach((url) {
      files.remove(url);
    });
  }

  Future<void> cleanAll()async{
    files.clear();
  }
}