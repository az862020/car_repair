import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'CloudCacheManager.dart';
import 'conf.dart';

class CloudImageProvider extends CachedNetworkImageProvider {
  CloudImageProvider(String url)
      : super(url,
            cacheManager:
                url.startsWith(Config.AppBucket) || !url.startsWith('http')
                    ? CloudCacheManager()
                    : null);
}
