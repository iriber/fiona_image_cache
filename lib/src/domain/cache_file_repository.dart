import 'dart:async';
import 'package:fiona_image_cache/src/domain/cache_file.dart';

abstract class CacheFileRepository {
  FutureOr<void> save(CacheFile cacheFile);

  FutureOr<CacheFile> getByUrl(String url);

  FutureOr<void> clean(List<String> urls);

  FutureOr<void> cleanAll();
}
