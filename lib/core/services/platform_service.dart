import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PlatformService {
  // 단일 인스턴스를 재사용하여 불필요한 객체 생성을 방지합니다.
  final DiskSpacePlus _diskSpace = DiskSpacePlus();

  bool get isWeb => kIsWeb;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isMacOS => !kIsWeb && Platform.isMacOS;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isDesktop =>
      !kIsWeb && (Platform.isMacOS || Platform.isWindows || Platform.isLinux);
  bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// 여유 저장 공간(MB)을 가져옵니다. 미지원 플랫폼(Web, macOS)은 null을 반환합니다.
  Future<double?> getFreeDiskSpace() async {
    if (isWeb || isMacOS) return null;
    try {
      return await _diskSpace.getFreeDiskSpace;
    } catch (_) {
      return null;
    }
  }

  /// 전체 저장 공간(MB)을 가져옵니다. 미지원 플랫폼은 null을 반환합니다.
  Future<double?> getTotalDiskSpace() async {
    if (isWeb || isMacOS) return null;
    try {
      return await _diskSpace.getTotalDiskSpace;
    } catch (_) {
      return null;
    }
  }

  /// 저장소 접근 권한을 확인합니다.
  ///
  /// Android 13+(API 33+)에서는 Permission.storage가 deprecated되어
  /// FilePicker(SAF 기반)가 권한 없이도 동작합니다.
  /// isPermanentlyDenied인 경우만 실질적으로 차단된 상태입니다.
  Future<bool> checkStoragePermission() async {
    if (isAndroid) {
      final status = await Permission.storage.status;
      // isPermanentlyDenied: 구형 Android에서 사용자가 명시적으로 영구 거부한 경우
      // isDenied / isRestricted: Android 13+에서 deprecated된 권한이거나 아직 미요청 상태
      // 후자는 FilePicker(SAF)가 자체적으로 처리하므로 진행을 허용합니다.
      return !status.isPermanentlyDenied;
    }
    return true;
  }

  /// 저장소 권한을 요청합니다.
  ///
  /// Android 13+에서는 Permission.storage 요청이 다이얼로그 없이 denied를 반환합니다.
  /// 이 경우 FilePicker는 SAF를 통해 정상 동작하므로 denied도 진행 허용으로 처리합니다.
  Future<bool> requestStoragePermission() async {
    if (isAndroid) {
      final status = await Permission.storage.request();
      // isGranted / isLimited: 구형 Android에서 명시적으로 허용된 경우
      // isDenied: Android 13+ deprecated 권한 (SAF로 대체)
      // isPermanentlyDenied: 사용자가 구형 Android에서 영구 거부 → 설정 화면 안내 필요
      return status.isGranted || status.isLimited || status.isDenied;
    }
    return true;
  }
}
