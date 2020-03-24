import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'CloudCacheManager.dart';
import 'CloudImageCache.dart';
import 'conf.dart';

class CloudImageProvider extends CachedNetworkImageProvider {
  CloudImageProvider(String url)
      : super(url,
            cacheManager:
                url.startsWith(Config.AppBucket) || !url.startsWith('http')
                    ? CloudCacheManager()
                    : DefaultCacheManager());




}
