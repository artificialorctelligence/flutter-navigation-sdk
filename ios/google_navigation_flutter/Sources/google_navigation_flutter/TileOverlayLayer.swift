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

import GoogleMaps

/// A raster tile layer fetched from a URL template, identified so Dart can address it later.
///
/// The template is resolved here rather than in Dart so tile bytes never cross the method
/// channel: the maps SDK fetches, decodes and caches them on its own threads.
class TileOverlayLayer: GMSURLTileLayer {
  let tileOverlayId: String
  private(set) var urlTemplate: String
  private(set) var transparency: Double

  init(tileOverlayId: String, options: TileOverlayOptionsDto) {
    self.tileOverlayId = tileOverlayId
    urlTemplate = options.urlTemplate
    transparency = options.transparency

    let template = options.urlTemplate
    super.init(urlConstructor: { x, y, zoom in
      let url =
        template
        .replacingOccurrences(of: "{x}", with: String(x))
        .replacingOccurrences(of: "{y}", with: String(y))
        .replacingOccurrences(of: "{z}", with: String(zoom))
      // A nil URL tells the SDK there is no tile here, which is how a tile is declined.
      return URL(string: url)
    })

    tileSize = Int(options.tileSize)
    apply(options: options)
  }

  /// Mutable options. The URL template and tile size are fixed at construction by the SDK.
  func apply(options: TileOverlayOptionsDto) {
    zIndex = Int32(options.zIndex)
    transparency = options.transparency
    // Android expresses this as transparency, iOS as opacity: they are complements.
    opacity = Float(1.0 - options.transparency)
    fadeIn = options.fadeIn
  }

  func toPigeonTileOverlay() -> TileOverlayDto {
    TileOverlayDto(
      tileOverlayId: tileOverlayId,
      options: TileOverlayOptionsDto(
        urlTemplate: urlTemplate,
        tileSize: Int64(tileSize),
        zIndex: Double(zIndex),
        transparency: transparency,
        visible: map != nil,
        fadeIn: fadeIn
      )
    )
  }
}
