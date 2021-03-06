import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'CloudCacheManager.dart';
import 'Config.dart';

class CloudImageProvider extends CachedNetworkImageProvider {
  CloudImageProvider(String url)
      : super(url,
            cacheManager:
                url.startsWith(Config.AppBucket) || !url.startsWith('http')
                    ? CloudCacheManager()
                    : DefaultCacheManager());




}
