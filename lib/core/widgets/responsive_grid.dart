import 'package:flutter/material.dart';
import '../utils/responsive_helper.dart';

/// 화면 크기에 따라 열(Column) 개수를 자동으로 조절하는 반응형 그리드 위젯입니다.
/// SliverGrid를 내부적으로 활용하여 효율적인 리스트 렌더링을 제공합니다.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileCrossAxisCount = 1,
    this.tabletCrossAxisCount = 2,
    this.desktopCrossAxisCount = 3,
    this.mainAxisSpacing = 16.0,
    this.crossAxisSpacing = 16.0,
    this.padding = EdgeInsets.zero,
    this.shrinkWrap = false,
    this.physics,
  });

  /// 그리드에 포함될 위젯 리스트
  final List<Widget> children;

  /// 모바일에서의 열 개수 (기본값: 1)
  final int mobileCrossAxisCount;

  /// 태블릿에서의 열 개수 (기본값: 2)
  final int tabletCrossAxisCount;

  /// 데스크탑에서의 열 개수 (기본값: 3)
  final int desktopCrossAxisCount;

  /// 행 간격 (기본값: 16.0)
  final double mainAxisSpacing;

  /// 열 간격 (기본값: 16.0)
  final double crossAxisSpacing;

  /// 그리드의 전체 패딩
  final EdgeInsetsGeometry padding;

  /// 그리드 콘텐츠에 맞게 높이를 조절할지 여부
  final bool shrinkWrap;

  /// 스크롤 물리 효과
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    // ResponsiveHelper를 사용하여 현재 기기에 맞는 열 개수 선택
    final crossAxisCount = context.responsive(
      mobileCrossAxisCount,
      tablet: tabletCrossAxisCount,
      desktop: desktopCrossAxisCount,
    );

    return GridView.builder(
      padding: padding,
      shrinkWrap: shrinkWrap,
      physics: physics,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
        childAspectRatio: 1.0, // 정사각형 비율 권장 (필요시 파라미터화 가능)
      ),
      itemCount: children.length,
      itemBuilder: (context, index) => children[index],
    );
  }
}
