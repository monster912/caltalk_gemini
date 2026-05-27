# Team CalTalk PRD (Product Requirements Document)

**Version**: v2.0.0  
**Status**: Updated with v2 features and UC structure

## 1. 프로젝트 개요 (Project Overview)
**Team CalTalk**은 일정과 대화의 맥락이 하나로 이어지는 팀 협업 경험을 제공하기 위해 캘린더와 실시간 채팅을 결합한 플랫폼입니다.

- **핵심 가치**: 일정 파편화 해소, 소통 맥락 보존, 서버 기반 환경 설정 동기화.

## 2. 사용자 플로우 (User Flow)
1.  **인증 및 설정**: 회원가입/로그인 후 개인 환경(테마/언어) 설정.
2.  **팀 빌딩**: 팀 생성 또는 초대 코드를 통한 팀 가입.
3.  **협업**: 캘린더 조회 → 일자별 채팅 논의 → 일정 변경 요청 → 팀장 승인 → 일정 반영.

## 3. 기능 요구사항 (Functional Requirements)

### UC-01: 회원가입 및 인증
*   **UC-01-1**: 이메일 및 비밀번호를 이용한 회원가입 및 로그인.
*   **UC-01-2**: JWT 기반의 안전한 세션 유지 및 로그아웃.
*   **UC-01-3**: 초기 가입 시 기본 테마(Light) 및 언어(KO) 자동 설정.

### UC-02: 팀 생성 및 관리
*   **UC-02-1**: 사용자는 팀을 생성할 수 있으며, 생성자는 자동으로 '팀장' 권한을 가짐.
*   **UC-02-2**: 6자리 영문/숫자 조합의 고유 초대 코드 생성 및 공유.
*   **UC-02-3**: 초대 코드를 통한 팀 가입 및 다중 팀 소속 지원.

### UC-03: 통합 캘린더 일정 조회
*   **UC-03-1**: 월(Month), 주(Week), 일(Day) 단위의 캘린더 뷰 제공.
*   **UC-03-2**: 소속된 팀의 모든 일정을 통합하여 시각화.
*   **UC-03-3**: 일정 클릭 시 해당 일자의 상세 정보 및 일자별 채팅창으로 즉시 연결.

### UC-04: 팀 일정 관리 (팀장 전용)
*   **UC-04-1**: 팀 일정의 생성, 수정, 삭제 권한 행사.
*   **UC-04-2**: 일정 변경 시 팀원들에게 실시간 알림 전송.

### UC-05: 일자별 실시간 채팅
*   **UC-05-1**: 캘린더의 특정 날짜를 기준으로 독립된 채팅 환경 제공.
*   **UC-05-2**: WebSocket 기반의 실시간 메시지 송수신.
*   **UC-05-3**: 날짜 전환 시 해당 날짜의 과거 채팅 내역 자동 로딩.

### UC-06: 일정 변경 요청 프로세스
*   **UC-06-1**: 팀원은 채팅창 내 전용 UI를 통해 일정 변경(시간, 내용 등)을 팀장에게 요청.
*   **UC-06-2**: 요청 상태(대기/승인/반려)의 실시간 추적 및 채팅 내 UI 업데이트.
*   **UC-06-3**: 팀장의 승인 시 관련 일정에 데이터 자동 반영 (또는 관리 팝업 노출).

### UC-07: 사용자 환경 설정 (v2 핵심)
*   **UC-07-1**: **다국어 지원**: i18n을 활용하여 한국어/영어 등 언어 전환 기능 제공.
*   **UC-07-2**: **테마 설정**: Light Mode와 Dark Mode 중 선택 가능.
*   **UC-07-3**: **서버 동기화**: 사용자의 테마/언어 설정 값을 DB에 저장하여 어떤 기기에서 접속해도 동일한 환경 유지.

## 4. 기술 스택 (Tech Stack)
*   **Frontend**: React 19, TypeScript, Zustand, TanStack Query, i18next.
*   **Backend**: Node.js, Express, PostgreSQL 17 (pg client).
*   **Communication**: Socket.io (실시간 채팅 및 알림).
*   **Security**: Argon2 또는 Bcrypt (비밀번호 암호화), JWT (인증).

## 5. 데이터 모델 (Data Model)
*   **Users**: id, email, password, name, **theme(LIGHT/DARK)**, **language(KO/EN)**, created_at
*   **Teams**: id, name, invite_code, leader_id
*   **TeamMembers**: id, team_id, user_id, role(LEADER/MEMBER)
*   **Schedules**: id, team_id, title, description, start_time, end_time, date
*   **Chats**: id, team_id, user_id, message, date, created_at
*   **ChangeRequests**: id, schedule_id, requester_id, team_id, content, status, created_at

## 6. 비기능 요구사항 (Non-functional Requirements)
*   **가용성**: 99.9% 이상의 시스템 가동률 보장.
*   **반응형 디자인**: 데스크탑부터 모바일 기기까지 일관된 유스케이스 경험 제공.
*   **확장성**: 사용자별 설정(Theme, Language) 확장 가능 구조 설계.

## 7. 제외 범위 (Out of Scope)
*   외부 서비스(Google, Outlook) 캘린더 동기화.
*   채팅 내 파일 및 이미지 업로드 (v1/v2 미포함).
