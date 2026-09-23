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

import '../../../google_navigation_flutter.dart';
import '../method_channel.dart';

/// [TileOverlayDto] convert extension.
/// @nodoc
extension ConvertTileOverlayDto on TileOverlayDto {
  /// Convert [TileOverlayDto] to [TileOverlay].
  TileOverlay toTileOverlay() {
    return TileOverlay(
      tileOverlayId: tileOverlayId,
      options: options.toTileOverlayOptions(),
    );
  }
}

/// [TileOverlay] convert extension.
/// @nodoc
extension ConvertTileOverlay on TileOverlay {
  /// Convert [TileOverlay] to [TileOverlayDto].
  TileOverlayDto toDto() {
    return TileOverlayDto(
      tileOverlayId: tileOverlayId,
      options: options.toDto(),
    );
  }
}

/// [TileOverlayOptionsDto] convert extension.
/// @nodoc
extension ConvertTileOverlayOptionsDto on TileOverlayOptionsDto {
  /// Convert [TileOverlayOptionsDto] to [TileOverlayOptions].
  TileOverlayOptions toTileOverlayOptions() {
    return TileOverlayOptions(
      urlTemplate: urlTemplate,
      tileSize: tileSize,
      zIndex: zIndex,
      transparency: transparency,
      visible: visible,
      fadeIn: fadeIn,
    );
  }
}

/// [TileOverlayOptions] convert extension.
/// @nodoc
extension ConvertTileOverlayOptions on TileOverlayOptions {
  /// Convert [TileOverlayOptions] to [TileOverlayOptionsDto].
  TileOverlayOptionsDto toDto() {
    return TileOverlayOptionsDto(
      urlTemplate: urlTemplate,
      tileSize: tileSize,
      zIndex: zIndex,
      transparency: transparency,
      visible: visible,
      fadeIn: fadeIn,
    );
  }
}
