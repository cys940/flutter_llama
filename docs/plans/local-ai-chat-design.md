# Local AI Chat Project - Design Document

이 문서는 `llamadart` 패키지를 활용한 온디바이스 로컬 AI 채팅 앱의 기술 설계 및 아키텍처를 정의합니다.

## 1. 프로젝트 개요
*   **목적**: 외부 서버 의존성 없이 기기 내에서 LLM(Llama 등)을 실행하는 로컬 AI 채팅 서비스.
*   **타겟 플랫폼**: Android, iOS, Web(WebGPU), Windows, macOS, Linux (Full Cross-Platform).
*   **핵심 기술**: Flutter, Riverpod, `llamadart` (Native Assets).

## 2. 아키텍처 (Clean Architecture)

### Layer 구조
*   **Domain**: 비즈니스 로직과 엔티티(`ChatMessage`, `ChatSession`).
*   **Data**: `llamadart` 엔진 연동 및 로컬 저장소 관리 (`ChatRepositoryImpl`, `LlamaDataSource`).
*   **Presentation**: Riverpod 상태 관리 및 프리미엄 다크 모드 UI.

### 데이터 흐름
`UI -> Riverpod Notifier -> UseCase -> Repository -> Llama Engine (llamadart) -> Stream -> UI`

## 3. 디자인 시스템 (Design System)

### 테마: Premium Dark Mode
*   **Base Colors**: `#000000` (Background), `#121212` (Surface), `#1E1E1E` (Card).
*   **Point Colors**: 일렉트릭 블루/바이올렛 (AI 전용 색상).
*   **Typography**: `GoogleFonts.inter` 혹은 `Montserrat`.

### 주요 컴포넌트
*   `AppButton`, `AppTextField`, `ChatBubble`, `ModelPicker`, `LoadingIndicator`.

## 4. 기술 스택 및 패키지
*   **State Management**: `flutter_riverpod` (3.x or latest), `riverpod_generator`.
*   **Local AI**: `llamadart`.
*   **Model Modeling**: `freezed`, `json_annotation`.
*   **Utils**: `path_provider`, `file_picker`, `google_fonts`, `talker_flutter`.

## 5. 예외 처리 및 최적화
*   **메모리 관리**: 기기 RAM 용량 사전 확인 및 모델 크기 제한.
*   **가속기 선택**: Metal/Vulkan 자동 감지 및 실패시 CPU Fallback.
*   **컨텍스트 관리**: `ChatSession` 기반 Sliding Window 전략으로 토큰 초과 방지.

## 6. 결론
이 설계는 높은 성능과 개인정보 보호를 동시에 제공하며, 현대적인 디자인 시스템을 통해 사용자에게 프리미엄한 경험을 제공하는 것을 목표로 합니다.
