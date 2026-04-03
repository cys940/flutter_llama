# 채팅 타이핑 인디케이터 고도화 설계 문서 (Chat Typing Indicator Design)

## 1. 개요 (Overview)
AI가 답변을 생성하기 전 대기 시간(Latency) 동안 사용자에게 "생성 중"임을 시각적으로 명확하고 세련되게 전달하기 위해, 현재의 분리된 로딩 위젯을 `ChatBubble` 내 통합된 타입핑 인디케이터(Typing Indicator)로 고도화합니다.

## 2. 주요 설계 목표 (Design Goals)
- **프리미엄 사용자 경험**: Stitch 디자인 시스템의 유리 질감(Glassmorphism)과 조화를 이루는 고품질 애니메이션 적용.
- **매끄러운 전환(Transition)**: 고민 중(Typing) 상태에서 실제 답변(Text)이 시작되는 순간 자연스럽게 치환되는 '전환형' UI 구현.
- **일관된 레이아웃**: 메시지 리스트와 동일한 정렬 및 여백을 유지하여 시각적 노이즈 최소화.

## 3. 상세 설계 (Detailed Design)

### 3.1. 컴포넌트 확장 (`ChatBubble`)
- **새 프로퍼티**: `bool isTyping` 추가.
- **UI 로직**:
    - `isTyping`이 `true`일 경우, `message` 텍스트 대신 `_TypingIndicator` 위젯 표시.
    - `_TypingIndicator`: 가로로 배치된 3개의 점(Dot)이 `flutter_animate`를 통해 순차적으로 Bouncing(또는 Opacity) 애니메이션 수행.
- **스타일**: AI 아바타 및 유리 질감 배경을 그대로 유지하여 답변 버블과 동일한 비주얼 선사.

### 3.2. 상태 관리 업데이트 (`ChatNotifier`)
- **`sendMessage` 생명주기 관리**:
    1. 사용자가 메시지를 발송하면 `state = state.copyWith(isLoading: true)` 설정.
    2. AI 응답 스트림(`responseStream`)에서 **첫 번째 토큰**이 도착하는 즉시 `isLoading: false`로 전환.
    3. 에러 발생 시 `finally` 블록에서 `isLoading: false` 보장.

### 3.3. 레이아웃 통합 (`ChatScreen`)
- **SliverList 동적 렌더링**:
    - `_ChatBody`의 `CustomScrollView` 내에서 `index == 0`이고 `state.isLoading == true`인 경우 `ChatBubble(isTyping: true)`를 리스트의 첫 번째 항목으로 삽입.
- **기존 위젯 제거**: 기존의 `_buildThinkingState` 및 고정된 여백(`SliverToBoxAdapter`) 제거 및 최적화.

## 4. 예외 처리 가이드 (Error Handling)
- **Timeouts**: 모델 응답이 극도로 늦어질 경우에도 인디케이터는 계속 작동하며, 타임아웃 에러 발생 시 에러 메시지로 자동 교체.
- **Race Conditions**: 답변이 매우 빠르게(거의 즉시) 올 경우, 타입핑 인디케이터가 너무 짧게 반짝이지 않도록 최소 표시 시간(예: 300ms) 고려 가능 (선택 사항).

## 5. 승인 내역 (Approval)
- **설계 승인**: 2026-03-29
- **승인자**: 사용자 (User)

---
*Next Step: 이 문서를 바탕으로 `/plan` 실행 및 구현 착수.*
