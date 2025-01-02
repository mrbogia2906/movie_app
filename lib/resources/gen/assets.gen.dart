/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsFontsGen {
  const $AssetsFontsGen();

  /// File path: assets/fonts/NotoSans-Bold.ttf
  String get notoSansBold => 'assets/fonts/NotoSans-Bold.ttf';

  /// File path: assets/fonts/NotoSans-Medium.ttf
  String get notoSansMedium => 'assets/fonts/NotoSans-Medium.ttf';

  /// File path: assets/fonts/NotoSans-Regular.ttf
  String get notoSansRegular => 'assets/fonts/NotoSans-Regular.ttf';

  /// List of all assets
  List<String> get values => [notoSansBold, notoSansMedium, notoSansRegular];
}

class $AssetsIconsGen {
  const $AssetsIconsGen();

  /// File path: assets/icons/favorite.svg
  SvgGenImage get favorite => const SvgGenImage('assets/icons/favorite.svg');

  /// File path: assets/icons/favorite_on.svg
  SvgGenImage get favoriteOn =>
      const SvgGenImage('assets/icons/favorite_on.svg');

  /// File path: assets/icons/home.svg
  SvgGenImage get home => const SvgGenImage('assets/icons/home.svg');

  /// File path: assets/icons/home_on.svg
  SvgGenImage get homeOn => const SvgGenImage('assets/icons/home_on.svg');

  /// File path: assets/icons/profile.svg
  SvgGenImage get profile => const SvgGenImage('assets/icons/profile.svg');

  /// File path: assets/icons/profile_on.svg
  SvgGenImage get profileOn => const SvgGenImage('assets/icons/profile_on.svg');

  /// File path: assets/icons/search.svg
  SvgGenImage get search => const SvgGenImage('assets/icons/search.svg');

  /// File path: assets/icons/search_on.svg
  SvgGenImage get searchOn => const SvgGenImage('assets/icons/search_on.svg');

  /// File path: assets/icons/setting.svg
  SvgGenImage get setting => const SvgGenImage('assets/icons/setting.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        favorite,
        favoriteOn,
        home,
        homeOn,
        profile,
        profileOn,
        search,
        searchOn,
        setting
      ];
}

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/avatar_default.png
  AssetGenImage get avatarDefault =>
      const AssetGenImage('assets/images/avatar_default.png');

  /// File path: assets/images/background.png
  AssetGenImage get backgroundPng =>
      const AssetGenImage('assets/images/background.png');

  /// File path: assets/images/background.svg
  SvgGenImage get backgroundSvg =>
      const SvgGenImage('assets/images/background.svg');

  /// File path: assets/images/background2.png
  AssetGenImage get background2Png =>
      const AssetGenImage('assets/images/background2.png');

  /// File path: assets/images/background2.svg
  SvgGenImage get background2Svg =>
      const SvgGenImage('assets/images/background2.svg');

  /// File path: assets/images/bear.jpg
  AssetGenImage get bear => const AssetGenImage('assets/images/bear.jpg');

  /// File path: assets/images/logo-facebook.png
  AssetGenImage get logoFacebook =>
      const AssetGenImage('assets/images/logo-facebook.png');

  /// File path: assets/images/logo-mv.png
  AssetGenImage get logoMv => const AssetGenImage('assets/images/logo-mv.png');

  /// List of all assets
  List<dynamic> get values => [
        avatarDefault,
        backgroundPng,
        backgroundSvg,
        background2Png,
        background2Svg,
        bear,
        logoFacebook,
        logoMv
      ];
}

class Assets {
  Assets._();

  static const $AssetsFontsGen fonts = $AssetsFontsGen();
  static const $AssetsIconsGen icons = $AssetsIconsGen();
  static const $AssetsImagesGen images = $AssetsImagesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
