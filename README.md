
This package helps your app to cache an image when get it from an URI.

## Features

FionaImageCache downloads the image and saves it into your local path.
The next time the app read the same image, it will return the local path.


## Getting started

You have to provide an implementation of CacheFileRepository to manage Cache files information.
The package provides a default one called CacheFileRepositoryInMemory which saves cache files in memory.


## Usage

You have to create the manager with the repository and the local path where you want to download the images:

```dart
/* create cache */
var fionaCache = FionaImageCache(repository:CacheFileRepositoryInMemory(), cacheFolder: "my_cache_folder");
  ```

Then in your Flutter widget you can use the manager to get the image path from an url.
The first time, the cache will get the image from the url, download it & save it.
The next time you call this method with the same url, the cache will return the local uri of the image.

```flutter
/* get image local path from cache */
String imagePath = await fionaCache.getImagePath(url);


/* and then you can create an image from the imagePath (local uri) */
Image image = Image.file(File(imagePath));
image.image.resolve(ImageConfiguration()).addListener(
    ImageStreamListener((ImageInfo image, bool synchronousCall) {
        var myImage = image.image;
        Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
        completer.complete(ImageCacheInfo(size, imagePath));
        },
    ),
); 
```

## Additional information

