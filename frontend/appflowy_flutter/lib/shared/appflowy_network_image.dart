import 'dart:convert';

import 'package:appflowy/shared/custom_image_cache_manager.dart';
import 'package:appflowy_backend/protobuf/flowy-user/protobuf.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:string_validator/string_validator.dart';

/// This widget handles the downloading and caching of either internal or network images.
///
/// It will append the access token to the URL if the URL is internal.
class FlowyNetworkImage extends StatelessWidget {
  const FlowyNetworkImage({
    super.key,
    this.userProfilePB,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.progressIndicatorBuilder,
    this.errorWidgetBuilder,
    required this.url,
  });

  final UserProfilePB? userProfilePB;
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;
  final LoadingErrorWidgetBuilder? errorWidgetBuilder;

  @override
  Widget build(BuildContext context) {
    assert(isURL(url));

    if (url.contains('beta.appflowy')) {
      assert(userProfilePB != null && userProfilePB!.token.isNotEmpty);
    }

    return CachedNetworkImage(
      cacheManager: CustomImageCacheManager(),
      httpHeaders: _header(),
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      progressIndicatorBuilder: progressIndicatorBuilder,
      errorWidget: (context, url, error) =>
          errorWidgetBuilder?.call(context, url, error) ??
          const SizedBox.shrink(),
    );
  }

  Map<String, String> _header() {
    final header = <String, String>{};
    final token = userProfilePB?.token;
    if (token != null) {
      header['Authorization'] = 'Bearer ${jsonDecode(token)['access_token']}';
    }
    return header;
  }
}
