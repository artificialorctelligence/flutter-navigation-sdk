// Copyright 2026 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Modified 2026 by Artificial Orctelligence for orcweather: this entrypoint is new.
// Apache-2.0 section 4(b).

/// Test doubles for apps that embed this plugin's map.
///
/// A widget containing [GoogleMapsMapView] cannot be pumped in a `flutter test` run: the view asks
/// the platform instance for its configuration, and off a device there is none, so the screen
/// throws instead of building. Every app embedding the map therefore cannot widget-test the screen
/// that embeds it — which is a large screen, in general.
///
/// The plugin already solved this for its own tests. These are those doubles, moved out of `test/`
/// into the shipped package so that the apps using the plugin can reach them too: a package's test
/// directory is not published, so before this they were visible only from inside the repository.
///
/// ```dart
/// GoogleMapsNavigationPlatform.instance = TestGoogleMapsNavigationPlatform(
///   TestNavigationSessionAPIImpl(),
///   TestMapViewAPIImpl()..ensureViewAPISetUp(),
///   ImageRegistryAPIImpl(),
///   TestAutoMapViewAPIImpl(),
/// );
/// ```
library;

export 'src/testing/mock_auto_api.dart';
export 'src/testing/mock_map_view_api.dart';
export 'src/testing/mock_navigation_platform.dart';
export 'src/testing/mock_navigation_session_api.dart';
