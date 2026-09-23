/*
 * Copyright 2026 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.google.maps.flutter.navigation

import com.google.android.gms.maps.model.TileOverlay
import com.google.android.gms.maps.model.UrlTileProvider
import java.net.MalformedURLException
import java.net.URL

/**
 * Serves tiles by substituting `{x}`, `{y}` and `{z}` in a URL template.
 *
 * The template is resolved here rather than in Dart so tile bytes never cross the method channel:
 * the maps SDK fetches, decodes and caches them on its own threads, as it does for its own tiles.
 */
class UrlTemplateTileProvider(width: Int, height: Int, private val urlTemplate: String) :
  UrlTileProvider(width, height) {

  override fun getTileUrl(x: Int, y: Int, zoom: Int): URL? {
    val url =
      urlTemplate
        .replace("{x}", x.toString())
        .replace("{y}", y.toString())
        .replace("{z}", zoom.toString())
    return try {
      URL(url)
    } catch (_: MalformedURLException) {
      // Returning null tells the SDK there is no tile here, which is the documented way to
      // decline one; throwing would take down the tile worker.
      null
    }
  }
}

class TileOverlayController(val tileOverlay: TileOverlay, val tileOverlayId: String) {
  /** The template this overlay was created with, so [GoogleMapsBaseMapView] can report it back. */
  var urlTemplate: String = ""

  /** Tile edge length in pixels, likewise reported back rather than read from the overlay. */
  var tileSize: Int = 256

  fun setZIndex(zIndex: Float) {
    tileOverlay.zIndex = zIndex
  }

  fun setTransparency(transparency: Float) {
    tileOverlay.transparency = transparency
  }

  fun setVisible(visible: Boolean) {
    tileOverlay.isVisible = visible
  }

  fun setFadeIn(fadeIn: Boolean) {
    tileOverlay.fadeIn = fadeIn
  }

  /** Drops the overlay's cached tiles, for a layer whose tiles change over time. */
  fun clearTileCache() {
    tileOverlay.clearTileCache()
  }

  fun remove() {
    tileOverlay.remove()
  }
}
