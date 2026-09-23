// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/foundation.dart';

/// A raster tile overlay drawn on top of the base map.
///
/// Imagery layers — weather radar, satellite, air quality — are raster tiles, which the map's
/// vector primitives ([Polygon], [Polyline], [Marker], [Circle]) cannot express.
@immutable
class TileOverlay {
  /// Construct [TileOverlay].
  const TileOverlay({required this.tileOverlayId, required this.options});

  /// Identifies the tile overlay.
  final String tileOverlayId;

  /// Options for the tile overlay.
  final TileOverlayOptions options;

  /// Create a copy of [TileOverlay] with the specified options.
  TileOverlay copyWith({required TileOverlayOptions options}) {
    return TileOverlay(tileOverlayId: tileOverlayId, options: options);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TileOverlay &&
        tileOverlayId == other.tileOverlayId &&
        options == other.options;
  }

  @override
  int get hashCode => Object.hash(tileOverlayId.hashCode, options.hashCode);

  @override
  String toString() =>
      'TileOverlay(tileOverlayId: $tileOverlayId, options: $options)';
}

/// Options for a [TileOverlay].
@immutable
class TileOverlayOptions {
  /// Construct [TileOverlayOptions].
  ///
  /// [urlTemplate] must contain the `{x}`, `{y}` and `{z}` placeholders; the platform substitutes
  /// them per tile using its own URL tile provider (`UrlTileProvider` on Android,
  /// `GMSURLTileLayer` on iOS), so tile bytes never cross the method channel.
  const TileOverlayOptions({
    required this.urlTemplate,
    this.tileSize = 256,
    this.zIndex = 0,
    this.transparency = 0,
    this.visible = true,
    this.fadeIn = true,
  }) : assert(
         tileSize > 0,
         'tileSize must be positive, was $tileSize',
       ),
       assert(
         transparency >= 0 && transparency <= 1,
         'transparency must be between 0 and 1, was $transparency',
       );

  /// URL of a tile, with `{x}`, `{y}` and `{z}` substituted per tile.
  final String urlTemplate;

  /// Edge length in points of each tile the template serves; usually 256 or 512.
  final int tileSize;

  /// Drawing order relative to other overlays.
  final double zIndex;

  /// 0.0 fully opaque, 1.0 fully transparent.
  final double transparency;

  /// Whether the overlay is drawn.
  final bool visible;

  /// Whether tiles fade in as they load.
  final bool fadeIn;

  /// Create a copy of these options with the given fields replaced.
  TileOverlayOptions copyWith({
    String? urlTemplate,
    int? tileSize,
    double? zIndex,
    double? transparency,
    bool? visible,
    bool? fadeIn,
  }) {
    return TileOverlayOptions(
      urlTemplate: urlTemplate ?? this.urlTemplate,
      tileSize: tileSize ?? this.tileSize,
      zIndex: zIndex ?? this.zIndex,
      transparency: transparency ?? this.transparency,
      visible: visible ?? this.visible,
      fadeIn: fadeIn ?? this.fadeIn,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TileOverlayOptions &&
        urlTemplate == other.urlTemplate &&
        tileSize == other.tileSize &&
        zIndex == other.zIndex &&
        transparency == other.transparency &&
        visible == other.visible &&
        fadeIn == other.fadeIn;
  }

  @override
  int get hashCode => Object.hash(
    urlTemplate.hashCode,
    tileSize.hashCode,
    zIndex.hashCode,
    transparency.hashCode,
    visible.hashCode,
    fadeIn.hashCode,
  );

  @override
  String toString() =>
      'TileOverlayOptions(urlTemplate: $urlTemplate, tileSize: $tileSize, '
      'zIndex: $zIndex, transparency: $transparency, visible: $visible, fadeIn: $fadeIn)';
}
