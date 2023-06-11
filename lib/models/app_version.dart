import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersion {
  final String? mockVersion;
  String? _version;
  AppVersion({this.mockVersion});

  Future<String?> version() async {
    if (mockVersion != null) return mockVersion;
    if (_version != null) return _version;
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final platform = _getPlatform();
    final versionString = '${packageInfo.version}${platform.isNotEmpty ? ' $platform' : ''}';
    _version = versionString;
    return versionString;
  }

  String _getPlatform() {
    if (kIsWeb) {
      return 'web';
    } else if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isWindows) {
      return 'windows';
    } else if (Platform.isLinux) {
      return 'linux';
    } else if (Platform.isMacOS) {
      return 'macos';
    }
    return '';
  }
}
