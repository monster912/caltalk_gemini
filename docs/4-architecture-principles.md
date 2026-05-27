# 프로젝트 구조 설계 원칙 (Architecture Principles)

**Version**: v1.0.0 (Based on PRD v2.0.0)  
**Status**: Finalized

## 1. 최상위 설계 원칙
*   **KISS (Keep It Simple, Stupid)**: 2일 내 MVP 완성을 위해 오버엔지니어링을 지양하고 본질적인 기능에 집중한다.
*   **Stateless Backend**: 서버는 상태를 가지지 않으며, 모든 인증 및 세션 정보는 JWT를 통해 처리하여 수평 확장성을 확보한다.
*   **SSOT (Single Source of Truth)**: 모든 데이터의 원천은 PostgreSQL DB로 단일화하며, 프론트엔드 상태(Zustand)는 UI 동기화 목적으로만 사용한다.
*   **Separation of Concerns**: 프론트엔드(UI/UX)와 백엔드(비즈니스 로직/데이터)의 역할을 명확히 분리한다.

## 2. 의존성 및 레이어 원칙
### 백엔드 (Layered Architecture)
- **Controller Layer**: HTTP 요청 수신 및 응답 반환. 유효성 검사 수행.
- **Service Layer**: 실제 비즈니스 로직 처리. 트랜잭션 관리.
- **Model/Repository Layer**: `pg` 라이브러리를 사용한 데이터베이스 직접 쿼리 수행.
- **의존성 방향**: Controller -> Service -> Model (역방향 의존성 금지)

### 프론트엔드 (Feature-based Structure)
- **React 19**: 최신 버전의 React 기능을 적극 활용.
- **Components**: 재사용 가능한 공통 UI 컴포넌트.
- **Features**: 특정 기능(Calendar, Chat, Team)과 관련된 도메인별 컴포넌트 및 로직.
- **Stores**: Zustand를 이용한 전역 상태 관리.
- **Hooks**: TanStack Query를 이용한 서버 데이터 페칭 및 상태 관리 로직 분리.
- **Internationalization**: i18next를 활용한 다국어 처리.

## 3. 코드 및 네이밍 원칙
*   **TypeScript**: 모든 스택에서 엄격한 타입을 적용하여 런타임 에러를 최소화한다.
*   **명명 규칙**:
    - 폴더/파일명: `kebab-case` (예: `user-profile/`)
    - 컴포넌트명: `PascalCase` (예: `CalendarContainer.tsx`)
    - 변수/함수명: `camelCase` (예: `fetchSchedules`)
    - 상수: `UPPER_SNAKE_CASE` (예: `MAX_TEAM_MEMBERS`)
*   **함수 작성**: 화살표 함수(`const func = () => {}`) 사용을 권장하며, 단일 책임 원칙을 준수한다.

## 4. 테스트 및 품질 원칙
*   **핵심 로직 테스트**: 2일의 일정상 모든 코드를 테스트할 수 없으므로, 권한 검증 및 일정 확정 로직 등 핵심 비즈니스 로직에 대한 단위 테스트를 우선한다.
*   **실시간성 검증**: Socket.io 연결 및 메시지 유실 방지(Ack 처리) 여부를 필수 검증한다.
*   **성능 품질**: 1,000명 동시 접속을 위해 DB 쿼리 실행 계획(`EXPLAIN`)을 확인하고 필수 인덱스를 설정한다.

## 5. 설정 / 보안 / 운영 원칙
*   **환경 변수 관리**: `.env` 파일을 통해 시스템 설정을 관리하며, 다음 변수들을 필수로 정의한다.
    - **Server**: `PORT` (서버 포트), `NODE_ENV` (development/production)
    - **Database**: `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
    - **Security**: `JWT_SECRET` (JWT 서명용), `JWT_EXPIRES_IN` (만료 시간), `CORS_ORIGIN` (허용 도메인)
    - **Frontend**: `VITE_API_URL` (백엔드 API 주소)
*   **인증 보안**: Argon2/Bcrypt를 사용한 비밀번호 암호화, JWT Access/Refresh Token 기반 인증.
*   **로그 관리**: 서버 에러 로그를 기록하여 장애 발생 시 즉각 대응 가능하도록 한다.

## 6. 디렉토리 구조 상세

### Frontend (src/)
```text
src/
├── assets/          # 정적 리소스 (이미지, 폰트)
├── components/      # 재사용 UI 컴포넌트 (Button, Input, Modal)
├── constants/       # 상수 및 설정값 (API_URL, THEME)
├── features/        # 도메인별 기능 단위
│   ├── auth/        # 로그인/회원가입
│   ├── calendar/    # 캘린더 핵심 로직
│   ├── chat/        # 실시간 채팅
│   ├── team/        # 팀 관리/초대
│   └── user/        # 테마/언어 설정 (v2)
├── hooks/           # 공통 커스텀 훅
├── services/        # API 호출 함수 (TanStack Query용)
├── stores/          # Zustand 스토어
├── styles/          # 전역 CSS 및 변수
├── types/           # 공통 TypeScript 타입 정의
└── utils/           # 범용 유틸리티 함수
```

### Backend (server/)
```text
server/
├── config/          # DB 연결 및 환경 변수 설정
├── controllers/     # 요청 핸들러
├── middleware/      # 인증(Auth), 로깅, 에러 핸들링 미들웨어
├── models/          # pg 기반 쿼리/데이터 접근 로직
├── routes/          # API 엔드포인트 라우팅
├── services/        # 비즈니스 로직
├── sockets/         # Socket.io 핸들러 (실시간 채팅)
├── types/           # TypeScript 타입 (CJS 환경 시 생략 가능)
├── utils/           # 공통 유틸리티 (비밀번호 암호화 등)
└── app.js           # Express 진입점
```
