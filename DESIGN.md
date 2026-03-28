# Design Specification: The Editorial Curator (Concept A)

로컬 AI 채팅 애플리케이션의 프리미엄화를 위한 에디토리얼 스타일의 디자인 명세서입니다. 정갈한 구조와 고품격 서체, 그리고 절제된 애니메이션을 통해 신뢰감 있는 사용자 경험을 제공합니다.

## 1. Visual Style & Philosophy
- **Editorial Authority**: 잡지나 정갈한 아티클을 읽는 듯한 레이아웃을 지향합니다.
- **Tonal Hierarchy**: 깊은 바다색(Deep Ocean) 배경 위에 세밀한 채도 차이를 두어 깊이감을 형성합니다.
- **Glassmorphism**: 슬리버 헤더와 입력부에 블러(Blur) 처리가 된 반투명 레이어를 적용하여 현대적인 느낌을 줍니다.

## 2. Design Tokens
- **Colors**:
    - `Background`: #060E20 (Deep Void)
    - `Surface`: #091328 (Low Surface - Sidebar/Header)
    - `Primary`: #9FA7FF (Spark Blue - User Bubbles)
    - `Secondary`: #3ADFFA (Flow Cyan - Accent/Glow)
- **Typography**:
    - **Headlines**: `Plus Jakarta Sans`, Semi-bold, Letter-spacing -0.02em.
    - **Body**: `Inter`, Regular, Line-height 1.6.

## 3. Sliver Architecture
- **SliverAppBar (Floating/Pinned)**: 
    - 스크롤 시 높이가 줄어들며 배경이 점진적으로 불투명해지는 효과.
    - `FlexibleSpace`를 활용해 모델 정보와 타이틀의 위치를 다이내믹하게 조정.
- **SliverList (Reversed)**:
    - 채팅 특성에 맞춰 하단부터 쌓이는 `reversed: true` 구조 활용.
    - 대화의 연속성을 강조하기 위해 `SliverChildBuilderDelegate` 최적화.

## 4. Motion & Animations (The Kinetic Logic)
- **Message Entry**: 신규 메시지 수신 시 하단에서 20px 정도 부드럽게 솟아오르며 나타나는 `Slide + Fade In` 효과 (Duration: 300ms, Curve: `EaseOutCubic`).
- **Header Transition**: 스크롤 오프셋에 따라 헤더의 색상 농도와 폰트 크기가 자연스럽게 보간(Interpolation)되는 애니메이션.
- **Staggered List**: 대화 세션 로드 시 메시지들이 50ms 간격으로 순차적으로 등장하여 리듬감을 부여.
- **Fluid Input**: 입력창 포커스 시 테두리의 그래디언트가 미세하게 회전하거나 글로우(Glow)가 확장되는 효과.

## 5. Components
- **Editorial Bubble**: 대화 구분을 명확히 하기 위해 유저 메시지는 강조색(Primary), AI 메시지는 표면색(SurfaceHigh)에 얇은 테두리 적용.
- **Glass Bottom Bar**: 하단 입력부는 항상 떠 있는 느낌을 주며, 배경이 비치는 프로스트 효과 적용.
