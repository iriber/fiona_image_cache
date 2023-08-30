
import 'package:fiona_cache/src/domain/cache_file.dart';

abstract class CacheFileRepository {

  Future<void> save(CacheFile cacheFile);

  Future<CacheFile> getByUrl(String url);

  Future<void> clean(List<String> urls);

  Future<void> cleanAll();
}