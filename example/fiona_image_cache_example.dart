import 'package:fiona_image_cache/fiona_image_cache.dart';
import 'package:fiona_image_cache/src/data/cache_file_repository_in_memory.dart';

void main() {
  var fionaCache = FionaImageCache(repository:CacheFileRepositoryInMemory(), cacheFolder: "");
  String url =
      "https://storage.googleapis.com/cms-storage-bucket/ec64036b4eacc9f3fd73.svg";
  fionaCache.save(url);
  print('Saving: $url');
}
