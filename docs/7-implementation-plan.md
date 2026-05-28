# Team CalTalk 실행 계획 (Implementation Plan)

**Version**: v1.0.0 (Based on PRD v2.0.0 & ERD v1.0.0)  
**Status**: Ready for Development

## Phase 1: Database (데이터베이스)

### Task 1.1: DB 환경 구성 및 스키마 적용
- **목표**: PostgreSQL 17 환경 구축 및 `schema.sql` 기반 테이블 생성
- **Dependencies**: 
  - [ ] 없음 (None)
- **완료 조건 (Definition of Done)**:
  - [ ] 로컬 또는 클라우드에 PostgreSQL 17 인스턴스 실행
  - [ ] `database/schema.sql` 스크립트 에러 없이 실행 완료
  - [ ] `psql` 또는 DB 클라이언트를 통해 6개 테이블 및 4개 ENUM 타입 생성 확인
  - [ ] 성능 최적화를 위한 6개의 인덱스 생성 확인

### Task 1.2: 시드 데이터(Seed Data) 구성 (선택/디버깅용)
- **목표**: BE/FE 개발을 위한 초기 테스트 데이터 삽입
- **Dependencies**: 
  - [ ] Task 1.1 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 2명의 사용자(팀장, 팀원) 데이터 삽입
  - [ ] 1개의 테스트 팀 및 팀 멤버 매핑 데이터 삽입
  - [ ] 테스트용 팀 일정 2건 삽입

---

## Phase 2: Backend (백엔드 - Node.js/Express)

### Task 2.1: 백엔드 아키텍처 스켈레톤 구성
- **목표**: `server/` 디렉토리 구조 생성 및 필수 패키지 설치
- **Dependencies**: 
  - [ ] Task 1.1 완료
- **완료 조건 (Definition of Done)**:
  - [ ] `express`, `pg`, `dotenv`, `cors` 패키지 설치 및 초기화
  - [ ] `config/`, `controllers/`, `services/`, `models/`, `routes/` 폴더 구조 생성
  - [ ] `pg` 라이브러리를 이용한 DB 연결 모듈(Pool) 작성 및 연결 테스트 성공

### Task 2.2: 사용자 인증 및 개인화 설정 API (UC-01, UC-07)
- **목표**: JWT 기반 인증 및 테마/다국어 설정 동기화
- **Dependencies**: 
  - [ ] Task 2.1 완료
- **완료 조건 (Definition of Done)**:
  - [ ] `argon2` 또는 `bcrypt`를 이용한 비밀번호 해싱 및 회원가입 API(`/api/auth/register`) 구현
  - [ ] 로그인 API(`/api/auth/login`) 구현 및 JWT 발급
  - [ ] 사용자 테마(theme) 및 언어(language) 업데이트 API(`/api/users/settings`) 구현

### Task 2.3: 팀 관리 및 초대 API (UC-02)
- **목표**: 팀 생성, 초대 코드 발급, 팀 가입 처리
- **Dependencies**: 
  - [ ] Task 2.2 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 팀 생성 API 구현 (자동으로 생성자를 LEADER로 지정, 6자리 `invite_code` 생성)
  - [ ] 초대 코드를 이용한 팀 가입 API 구현
  - [ ] 내 소속 팀 목록 조회 API 구현

### Task 2.4: 캘린더 및 일정 관리 API (UC-03, UC-04, UC-06)
- **목표**: 팀 일정 CRUD 및 변경 요청 프로세스 처리
- **Dependencies**: 
  - [ ] Task 2.3 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 특정 팀의 월/주간 일정 목록 조회 API 구현
  - [ ] 팀장 권한 검증 미들웨어 및 일정 생성/수정/삭제 API 구현
  - [ ] 일정 변경 요청(Change Request) 생성 API 구현 (`JSONB` content 활용)
  - [ ] 변경 요청 상태(승인/반려) 업데이트 API 구현 (승인 시 일정 자동 갱신 로직 포함)

### Task 2.5: WebSocket 실시간 채팅 및 알림 (UC-05)
- **목표**: `socket.io`를 이용한 일자별 채팅 및 상태 변경 알림
- **Dependencies**: 
  - [ ] Task 2.1 완료
- **완료 조건 (Definition of Done)**:
  - [ ] `socket.io` 서버 초기화 및 JWT 소켓 인증 미들웨어 구현
  - [ ] `team_id` + `chat_date` 조합의 Room 입장/퇴장 로직 구현
  - [ ] 채팅 메시지 브로드캐스팅 및 DB(`CHATS` 테이블) 비동기 저장 구현
  - [ ] 일정 변경/승인 시 해당 팀 Room에 실시간 알림(Event) 발송 로직 구현

---

## Phase 3: Frontend (프론트엔드 - React 19)

### Task 3.1: 프론트엔드 보일러플레이트 및 환경 설정
- **목표**: `src/` 디렉토리 구성 및 상태 관리/라우터 설정
- **Dependencies**: 
  - [ ] 없음 (BE와 병렬 진행 가능)
- **완료 조건 (Definition of Done)**:
  - [ ] Vite + React 19 + TypeScript 프로젝트 세팅
  - [ ] `zustand`, `@tanstack/react-query`, `react-router-dom` 설치 및 초기화
  - [ ] `i18next` 설치 및 `locales/` 디렉토리에 KO/EN 번역 파일 구조화
  - [ ] 다크/라이트 모드 지원을 위한 CSS(Variables) 또는 Tailwind 스켈레톤 구축

### Task 3.2: 인증 및 공통 레이아웃 (UC-01, UC-07)
- **목표**: 로그인/회원가입 화면 및 개인화 동기화
- **Dependencies**: 
  - [ ] Task 3.1 완료
  - [ ] Task 2.2 완료 (API 연동 시)
- **완료 조건 (Definition of Done)**:
  - [ ] 로그인 및 회원가입 폼 컴포넌트 구현
  - [ ] 인증 성공 시 JWT 로컬 스토리지 저장 및 전역 상태(Zustand) 유저 정보 세팅
  - [ ] 헤더/사이드바 영역에 언어 전환 및 테마 토글 버튼 구현 (변경 시 BE API 호출 동기화)

### Task 3.3: 대시보드 및 팀 관리 UI (UC-02)
- **목표**: 내 팀 목록 표시 및 가입/생성 모달 구현
- **Dependencies**: 
  - [ ] Task 3.2 완료
  - [ ] Task 2.3 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 사이드바에 내 소속 팀 목록 렌더링 (`TanStack Query` 활용)
  - [ ] 신규 팀 생성 모달 및 API 연동
  - [ ] 초대 코드로 팀 가입 모달 및 API 연동

### Task 3.4: 캘린더 및 일정 관리 UI (UC-03, UC-04, UC-06)
- **목표**: 월/주간 캘린더 렌더링 및 일정 상호작용
- **Dependencies**: 
  - [ ] Task 3.3 완료
  - [ ] Task 2.4 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 달력 라이브러리(FullCalendar 등) 통합 및 팀 일정 데이터 패칭
  - [ ] 팀장의 일정 클릭 시 '일정 관리(수정/삭제)' 모달 팝업
  - [ ] 팀원의 일정 클릭 시 '일정 변경 요청' 모달 팝업 및 전송
  - [ ] 팀장용 '변경 요청 목록' 대시보드 및 승인/반려 UI 구현

### Task 3.5: 실시간 채팅 패널 UI (UC-05)
- **목표**: 일자별 독립 채팅창 구현
- **Dependencies**: 
  - [ ] Task 3.4 완료
  - [ ] Task 2.5 완료
- **완료 조건 (Definition of Done)**:
  - [ ] 캘린더에서 특정 날짜 클릭 시 우측(또는 하단)에 채팅 사이드바 활성화
  - [ ] `socket.io-client` 연결 및 해당 날짜(Room) 조인 로직 구현
  - [ ] 과거 채팅 내역 로딩 및 새 메시지 입력/실시간 렌더링 확인
  - [ ] 알림 발생 시(일정 승인 등) 채팅창에 시스템 메시지 형태로 표시
