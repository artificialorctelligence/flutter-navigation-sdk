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
///
/// This holds a `GMSURLTileLayer` rather than subclassing one. That class exposes a single
/// factory, `+tileLayerWithURLConstructor:`, and no initializer; Swift surfaces the factory as
/// `GMSURLTileLayer(urlConstructor:)`, so a subclass's `super.init(urlConstructor:)` compiles and
/// then aborts at runtime — `unrecognized selector sent to instance`, killing the app the first
/// time Dart adds an overlay. `map` forwards so callers read the same as any other layer.
class TileOverlayLayer {
  let tileOverlayId: String
  private(set) var urlTemplate: String
  private(set) var transparency: Double

  private let layer: GMSURLTileLayer

  /// The map this layer is attached to, or nil while detached — how visibility is expressed.
  var map: GMSMapView? {
    get { layer.map }
    set { layer.map = newValue }
  }

  init(tileOverlayId: String, options: TileOverlayOptionsDto) {
    self.tileOverlayId = tileOverlayId
    urlTemplate = options.urlTemplate
    transparency = options.transparency

    let template = options.urlTemplate
    layer = GMSURLTileLayer(urlConstructor: { x, y, zoom in
      let url =
        template
        .replacingOccurrences(of: "{x}", with: String(x))
        .replacingOccurrences(of: "{y}", with: String(y))
        .replacingOccurrences(of: "{z}", with: String(zoom))
      // A nil URL tells the SDK there is no tile here, which is how a tile is declined.
      return URL(string: url)
    })

    layer.tileSize = Int(options.tileSize)
    apply(options: options)
  }

  /// Mutable options. The URL template and tile size are fixed at construction by the SDK.
  func apply(options: TileOverlayOptionsDto) {
    layer.zIndex = Int32(options.zIndex)
    transparency = options.transparency
    // Android expresses this as transparency, iOS as opacity: they are complements.
    layer.opacity = Float(1.0 - options.transparency)
    layer.fadeIn = options.fadeIn
  }

  /// Drops the SDK's cached tiles for this layer — how a newer radar frame is forced in.
  func clearTileCache() {
    layer.clearTileCache()
  }

  func toPigeonTileOverlay() -> TileOverlayDto {
    TileOverlayDto(
      tileOverlayId: tileOverlayId,
      options: TileOverlayOptionsDto(
        urlTemplate: urlTemplate,
        tileSize: Int64(layer.tileSize),
        zIndex: Double(layer.zIndex),
        transparency: transparency,
        visible: layer.map != nil,
        fadeIn: layer.fadeIn
      )
    )
  }
}
