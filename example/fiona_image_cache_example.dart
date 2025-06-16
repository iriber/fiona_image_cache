import 'package:fiona_image_cache/fiona_image_cache.dart';
import 'package:fiona_image_cache/src/data/cache_file_repository_in_memory.dart';

void main() {
  var fionaCache = FionaImageCache(fionaImageUrl: FionaImageUrl() , repository:CacheFileRepositoryInMemory(), cacheFolder: "my_cache_folder");
  String url =
      "https://picsum.photos/400.jpg";

  print('Saving: $url');
  /*fionaCache.save(url).then((cacheFile){
    print('Saved image: ${cacheFile.localName}');
  });*/

  fionaCache.getImagePath(url).then((imagePath){
    print('Saved image path: $imagePath');
  });

}
