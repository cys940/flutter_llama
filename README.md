# Flutter Llama - Premium Local AI Chat

**Flutter Llama**는 외부 서버와의 통신 없이 사용자의 기기에서 직접 대규모 언어 모델(LLM)을 실행하는 프리미엄 로컬 AI 채팅 앱입니다. 개인정보를 보호하면서도 강력한 AI 성능을 어디서나 경험할 수 있습니다.

---

## ✨ 주요 기능

- **완전한 로컬 추론**: 인터넷 연결 없이도 기기 내부에서 직접 LLM(GGUF 포맷)을 구동합니다.
- **실시간 스트리밍**: AI의 응답을 글자 단위로 실시간으로 확인할 수 있는 스트리밍 인터페이스를 제공합니다.
- **멀티플랫폼 지원**: iOS, Android, macOS, Windows, Linux, Web(WebGPU)을 모두 지원하는 강력한 호환성을 자랑합니다.
- **프리미엄 다크 모드**: 시각적인 편안함과 고급스러움을 강조한 독자적인 다크 모드 디자인 시스템이 적용되어 있습니다.
- **모델 관리**: 다양한 GGUF 모델 파일을 사용자가 직접 선택하여 로드할 수 있는 유연한 구조입니다.

## 🛠 기술 스택

- **Core**: Flutter, Dart
- **AI Engine**: `llamadart` (Native Assets 기반, Metal/Vulkan/WebGPU 가속 지원)
- **State Management**: `flutter_riverpod`, `riverpod_generator`
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **Routing**: `go_router` (선언적 라우팅)
- **UI & UX**: Google Fonts (Inter), Lucide Icons, Custom Design System

## 🚀 시작하기

### 사전 준비 지시사항
- Flutter SDK 3.22.0 이상이 설치되어 있어야 합니다.
- `.gguf` 포맷의 LLM 모델 파일을 준비해 주세요. (예: Llama-3, Gemma 등)

### 설치 및 실행

1. 저장소를 클론합니다:
   ```bash
   git clone https://github.com/cys940/flutter_llama.git
   ```
2. 필요 라이브러리를 설치합니다:
   ```bash
   flutter pub get
   ```
3. 코드 생성을 실행합니다:
   ```bash
   dart run build_runner build
   ```
4. 앱을 실행합니다:
   ```bash
   flutter run
   ```

## 📂 프로젝트 구조

```text
lib/
├── core/             # 공통 테마, 라우팅, 유틸리티
├── features/         # 기능별 모듈
│   └── chat/         # 채팅 기능 (Clean Architecture 적용)
│       ├── data/     # 데이터 소스 및 리포지토리 구현
│       ├── domain/   # 엔티티 및 비즈니스 로직 정의
│       └── presentation/ # UI 및 상태 관리
└── main.dart         # 진입점
```

---

Copyright © 2026 [cys940](https://github.com/cys940). All rights reserved.
