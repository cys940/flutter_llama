# Flutter Llama - Premium Local AI Chat

**Flutter Llama**는 외부 서버와의 통신 없이 사용자의 기기에서 직접 대규모 언어 모델(LLM)을 실행하는 프리미엄 로컬 AI 채팅 앱입니다. 개인정보를 보호하면서도 강력한 AI 성능을 어디서나 경험할 수 있습니다.

---

## ✨ 주요 기능

- **완전한 로컬 추론**: 인터넷 연결 없이도 기기 내부에서 직접 LLM(GGUF 포맷)을 구동합니다.
- **채팅 세션 영속성**: SQLite 기반의 로컬 데이터베이스를 통해 대화 내역을 안전하게 보관하고 관리합니다.
- **실시간 스트리밍**: AI의 응답을 글자 단위로 실시간으로 확인할 수 있는 스트리밍 인터페이스를 제공합니다.
- **멀티플랫폼 지원**: iOS, Android, macOS, Windows, Linux, Web(WebGPU)을 모두 지원하는 강력한 호환성을 자랑합니다.
- **반응형 레이아웃**: 모바일(Drawer), 태블릿/데스크탑(고정 사이드바 및 Max Width) 등 모든 기기 크기에 최적화된 뛰어난 UX를 제공합니다.
- **플랫폼 최적화**: macOS(Impeller), Android(Vulkan GPU 가속) 등 각 플랫폼별 최고의 성능을 내도록 네이티브 레이어가 튜닝되어 있습니다.
- **프리미엄 다크 모드**: 시각적인 편안함과 고급스러움을 강조한 독자적인 다크 모드 디자인 시스템이 적용되어 있습니다.

## 🛠 기술 스택

- **Core**: Flutter, Dart
- **State Management**: `flutter_riverpod`, `riverpod_generator`
- **DI (Dependency Injection)**: `injectable`, `get_it`
- **Database**: `sqflite` (SQLite 기반 로컬 영속성)
- **AI Engine**: `llamadart` (Native Assets 기반, Metal/Vulkan/WebGPU 가속 지원)
- **Architecture**: Clean Architecture (Domain, Data, Presentation)
- **Routing**: `go_router` (선언적 라우팅)
- **UI & UX**: Google Fonts (Inter), Lucide Icons, Responsive Design System Tokens

## 🚀 시작하기

### 사전 준비 및 환경 설정
- **FVM (Flutter Version Management)** 설치 권장
- 프로젝트 사용 SDK 버전: **stable 3.41.5**
- `.gguf` 포맷의 LLM 모델 파일을 준비해 주세요. (예: Llama-3, Gemma 등)

### 설치 및 실행

1. 저장소를 클론합니다:
   ```bash
   git clone https://github.com/cys940/flutter_llama.git
   cd flutter_llama
   ```
2. FVM을 통한 SDK 설정을 완료합니다:
   ```bash
   fvm use 3.41.5
   ```
3. 필요 라이브러리를 설치합니다:
   ```bash
   fvm flutter pub get
   ```
4. 의존성 주입 및 상태 관리 코드 생성을 실행합니다:
   ```bash
   fvm flutter pub run build_runner build --delete-conflicting-outputs
   ```
5. 앱을 실행합니다:
   ```bash
   fvm flutter run
   ```

## 💻 VS Code 개발 환경

본 프로젝트는 VS Code에서 최적의 개발 환경을 제공하도록 구성되어 있습니다.
- **자동 설정**: `.vscode/settings.json`을 통해 로컬 FVM SDK 및 자동 포맷팅이 적용됩니다.
- **Launch Configurations**: iOS, Android, macOS, Web 등 모든 플랫폼에 최적화된 디버그/릴리스 실행 구성을 제공합니다 (`launch.json`).

## 📂 프로젝트 구조

```text
lib/
├── core/             # 공통 테마, 라우팅, 유틸리티
│   ├── database/     # SQLite 기반 DatabaseHelper 및 Migrations
│   ├── di/           # Injectable & GetIt 의존성 주입 설정
│   └── theme/        # 디자인 시스템 및 컬러 스키마
├── features/         # 기능별 모듈
│   └── chat/         # 채팅 기능 (Clean Architecture 적용)
│       ├── data/     # 데이터 소스 (LocalAI, SQLite) 및 리포지토리 구현
│       ├── domain/   # 엔티티 및 비즈니스 로직 정의
│       └── presentation/ # UI (Screens, Widgets) 및 상태 관리 (Providers)
└── main.dart         # 진입점 및 전역 설정
```

---

Copyright © 2026 [cys940](https://github.com/cys940). All rights reserved.
