# Flutter Llama - Premium Local AI Chat 🚀

**Flutter Llama**는 외부 서버와의 통신 없이 사용자의 기기에서 직접 대규모 언어 모델(LLM)을 실행하는 프리미엄 로컬 AI 채팅 앱입니다. `llamadart` 0.6.9 엔진을 기반으로 설계되어 최신 가속 기술을 완벽하게 활용합니다.

---

## ✨ 핵심 기능

- **완전한 로컬 추론**: 인터넷 연결 없이 기기 내부에서 직접 `.gguf` 포맷의 모델을 구동합니다.
- **WebGPU 지원 (Web)**: 브라우저 환경에서도 하드웨어 가속을 통해 데스크톱급 추론 성능을 제공합니다.
- **GPU 가속 (Native)**: iOS(Metal), Android(Vulkan), Windows/Linux(Vulkan) 등 전 플랫폼 가속을 지원합니다.
- **스마트 세션 관리**: `ChatSession`을 통한 지능적인 대화 맥락 유지 및 컨텍스트 윈도우 최적화.
- **Hugging Face 통합**: 웹 환경에서 Hugging Face의 GGUF 모델을 직접 URL로 로드하여 즉시 사용 가능합니다.
- **프리미엄 디자인**: Fluent한 애니메이션과 세련된 다크 모드, 모든 기기에 대응하는 반응형 레이아웃.

---

## 🛠 기술 스택

- **Engine**: `llamadart` v0.6.9 (Unified Platform Backend)
- **Framework**: Flutter (Stable 3.41.5)
- **State Management**: `flutter_riverpod`, `riverpod_generator`
- **DI**: `injectable`, `get_it`
- **Architecture**: **Clean Architecture** (Domain, Data, Presentation)
- **Local Storage**: `sqflite` (대화 저장), `shared_preferences` (설정)
- **UI/UX**: `flutter_animate`, `flex_color_scheme`, Google Fonts (Inter)

---

## 📱 플랫폼별 시스템 요구 사항

| 플랫폼 | 요구 사항 | 가속 기술 |
| :--- | :--- | :--- |
| **iOS** | iOS 16.4 이상 (SharedArrayBuffer 지원) | Metal |
| **Android** | Android 7.0+ (Vulkan 1.1 이상 권장) | Vulkan |
| **Web** | Chrome/Edge 113+ (WebGPU 활성화) | WebGPU |
| **Desktop** | macOS 13+, Windows 10+ | Metal, Vulkan |

---

## 🌍 WebGPU 배포 및 설정 (중요)

웹 환경에서 대용량 GGUF 모델을 로드하고 WebGPU를 안정적으로 사용하려면 다음 설정이 필수적입니다.

### 1. 보안 헤더 (Cross-Origin Isolation)
서버 수준에서 다음 HTTP 헤더를 설정해야 합니다:
```http
Cross-Origin-Opener-Policy: same-origin
Cross-Origin-Embedder-Policy: require-corp
```

### 2. 브리지 에셋 (index.html)
`web/index.html`에 WebGPU 브리지 로더가 이미 구성되어 있습니다:
```html
<script>
  window.__llamadartBridgeAssetsRepo = 'leehack/llama-web-bridge-assets';
  window.__llamadartBridgeAssetsTag = 'v0.1.10'; 
</script>
<script src="https://cdn.jsdelivr.net/npm/llamadart-web-bridge@0.1.10/dist/llamadart-web-bridge.js"></script>
```

---

## 🚀 빠른 시작

### 1. 환경 설정
- **FVM** 설치 권장
- `fvm use 3.41.5`

### 2. 프로젝트 초기화
```bash
# 의존성 설치
fvm flutter pub get

# 코드 생성 (DI, Freezed, Riverpod)
fvm flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. 플랫폼별 실행
- **Android (Vulkan 가속 포함)**:
  ```bash
  fvm flutter run --dart-define=LLAMADART_BACKEND=vulkan
  ```
- **Web (WebGPU 브라우저 실행)**:
  ```bash
  fvm flutter run -d chrome --web-renderer canvaskit
  ```

---

## 📂 프로젝트 구조

```text
lib/
├── core/             # 공통 테마, DI, 플랫폼 서비스
├── features/         # 기능별 도메인 뱅크
│   └── chat/         # 채팅 모듈
│       ├── data/     # LlamaDataSource, ModelRepository (GGUF 로드 및 관리)
│       ├── domain/   # ChatSession 기반 비즈니스 로직
│       └── presentation/ # Riverpod Proivders 및 UI 위젯
└── main.dart         # 진입점 및 전역 초기화
```

---

## 📄 라이선스 및 저작권
Copyright © 2026 [cys940](https://github.com/cys940). All rights reserved. 본 프로젝트는 `llamadart` 오픈소스 라이브러리의 연동 규격을 준수합니다.
