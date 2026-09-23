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

import 'package:flutter_test/flutter_test.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:google_navigation_flutter/src/method_channel/method_channel.dart';

void main() {
  late TileOverlay tileOverlay;

  setUp(() {
    tileOverlay = const TileOverlay(
      tileOverlayId: 'TileOverlay_0',
      options: TileOverlayOptions(
        urlTemplate: 'https://tiles.example.com/radar/{z}/{x}/{y}.png',
        tileSize: 512,
        zIndex: 3,
        transparency: 0.25,
        visible: false,
        fadeIn: false,
      ),
    );
  });

  test('TileOverlay survives a round trip through its Dto', () {
    final TileOverlayDto dto = tileOverlay.toDto();
    expect(dto.tileOverlayId, 'TileOverlay_0');
    expect(
      dto.options.urlTemplate,
      'https://tiles.example.com/radar/{z}/{x}/{y}.png',
    );
    expect(dto.options.tileSize, 512);
    expect(dto.toTileOverlay(), tileOverlay);
  });

  test('defaults are an opaque, visible 256px layer that fades in', () {
    const TileOverlayOptions options = TileOverlayOptions(
      urlTemplate: 'https://tiles.example.com/{z}/{x}/{y}.png',
    );
    expect(options.tileSize, 256);
    expect(options.zIndex, 0);
    expect(options.transparency, 0);
    expect(options.visible, isTrue);
    expect(options.fadeIn, isTrue);
  });

  test('copyWith replaces only the named fields', () {
    final TileOverlayOptions updated = tileOverlay.options.copyWith(
      transparency: 0.5,
      visible: true,
    );
    expect(updated.transparency, 0.5);
    expect(updated.visible, isTrue);
    expect(updated.urlTemplate, tileOverlay.options.urlTemplate);
    expect(updated.tileSize, 512);

    final TileOverlay withOptions = tileOverlay.copyWith(options: updated);
    expect(withOptions.tileOverlayId, tileOverlay.tileOverlayId);
    expect(withOptions.options, updated);
  });

  test('equality and hashCode cover every field', () {
    expect(
      tileOverlay,
      const TileOverlay(
        tileOverlayId: 'TileOverlay_0',
        options: TileOverlayOptions(
          urlTemplate: 'https://tiles.example.com/radar/{z}/{x}/{y}.png',
          tileSize: 512,
          zIndex: 3,
          transparency: 0.25,
          visible: false,
          fadeIn: false,
        ),
      ),
    );
    expect(
      tileOverlay.hashCode,
      const TileOverlay(
        tileOverlayId: 'TileOverlay_0',
        options: TileOverlayOptions(
          urlTemplate: 'https://tiles.example.com/radar/{z}/{x}/{y}.png',
          tileSize: 512,
          zIndex: 3,
          transparency: 0.25,
          visible: false,
          fadeIn: false,
        ),
      ).hashCode,
    );
    expect(
      tileOverlay ==
          tileOverlay.copyWith(
            options: tileOverlay.options.copyWith(zIndex: 9),
          ),
      isFalse,
    );
  });

  test('options reject a non-positive tile size and out-of-range transparency', () {
    expect(
      () => TileOverlayOptions(
        urlTemplate: 'https://tiles.example.com/{z}/{x}/{y}.png',
        tileSize: 0,
      ),
      throwsAssertionError,
    );
    expect(
      () => TileOverlayOptions(
        urlTemplate: 'https://tiles.example.com/{z}/{x}/{y}.png',
        transparency: 1.5,
      ),
      throwsAssertionError,
    );
  });
}
