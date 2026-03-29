import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PlatformService {
  bool get isWeb => kIsWeb;
  
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isDesktop => !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// 여유 저장 공간(MB)을 가져옵니다. 미지원 플랫폼(Web 등)은 null을 반환합니다.
  Future<double?> getFreeDiskSpace() async {
    if (isWeb) return null;
    try {
      // macOS는 공식적으로 미지원일 가능성이 높으므로 예외 처리
      if (isMacOS) return null;
      
      final diskSpace = DiskSpacePlus();
      return await diskSpace.getFreeDiskSpace;
    } catch (_) {
      return null;
    }
  }

  /// 전체 저장 공간(MB)을 가져옵니다. 미지원 플랫폼은 null을 반환합니다.
  Future<double?> getTotalDiskSpace() async {
    if (isWeb) return null;
    try {
      if (isMacOS) return null;
      
      final diskSpace = DiskSpacePlus();
      return await diskSpace.getTotalDiskSpace;
    } catch (_) {
      return null;
    }
  }

  /// 저장소 접근 권한을 확인합니다. 안드로이드 이외는 항상 true를 반환합니다.
  Future<bool> checkStoragePermission() async {
    if (isAndroid) {
      return await Permission.storage.isGranted || await Permission.storage.isLimited;
    }
    return true; // iOS, Desktop, Web은 시스템 파일 선택기로 대체되거나 권한이 필요 없음
  }

  /// 저장소 권한을 요청합니다. 안드로이드 이외는 별도 처리 없이 true를 반환합니다.
  Future<bool> requestStoragePermission() async {
    if (isAndroid) {
      final status = await Permission.storage.request();
      return status.isGranted || status.isLimited;
    }
    return true;
  }
}
