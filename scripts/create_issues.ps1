# Caltalk Project - GitHub Issues Bulk Creation Script
# This script uses the GitHub CLI (gh) to create 12 tasks as issues.
# Usage: 
# 1. Run 'gh auth login' to authenticate.
# 2. Run this script: 'powershell -ExecutionPolicy Bypass -File scripts/create_issues.ps1'

$issues = @(
    @{
        title = "[Phase 1: DB] Task 1.1: DB 환경 구성 및 스키마 적용"
        labels = "kind:task,area:database,complexity:low"
        body = @"
## 📝 Todo
- [ ] PostgreSQL 17 인스턴스 환경 구축 (Local 또는 Cloud)
- [ ] database/schema.sql 스크립트 실행
- [ ] DB 클라이언트(pgAdmin, DBeaver 등)를 통한 스키마 검증

## ✅ 완료 조건 (Definition of Done)
- [ ] 6개 테이블(Users, Teams, TeamMembers, Schedules, Chats, ChangeRequests) 생성 완료
- [ ] 4개 ENUM 타입(user_theme, user_language, member_role, request_status) 생성 확인
- [ ] 성능 최적화를 위한 6개의 인덱스(INDEX) 정상 생성 확인

## ⚙️ 기술적 고려사항
- PostgreSQL 17의 `gen_random_uuid()` 기능을 활용한 UUID PK 설계 준수.
- `TIMESTAMPTZ`를 사용하여 글로벌 시간대 대응 및 데이터 정합성 확보.
- 인덱스 설계가 PRD의 조회 패턴(팀별/일자별)에 최적화되었는지 `EXPLAIN`으로 확인.

## 🔗 의존성 (Dependencies)
- 로컬 또는 원격 PostgreSQL 17 환경

## 📅 작업 순서
- **선행 작업**: 없음
- **후행 작업**: Task 1.2 (시드 데이터 구성), Task 2.1 (백엔드 초기화)
"@
    },
    @{
        title = "[Phase 1: DB] Task 1.2: 시드 데이터 구성"
        labels = "kind:task,area:database,complexity:low"
        body = @"
## 📝 Todo
- [ ] 로컬/테스트 환경용 초기 데이터 삽입 SQL 스크립트 작성
- [ ] 사용자, 팀, 일정, 멤버십 데이터 삽입 및 외래키 무결성 테스트

## ✅ 완료 조건 (Definition of Done)
- [ ] 테스트 사용자 2명(팀장, 팀원) 데이터 정상 조회
- [ ] 테스트 팀 1개 및 해당 팀 멤버 매핑(Role 분리) 확인
- [ ] 테스트용 팀 일정 2건 및 채팅 기록 삽입 확인

## ⚙️ 기술적 고려사항
- 비밀번호 해싱 알고리즘(Argon2) 적용 전이므로 초기 시드 데이터는 더미 데이터를 사용하되, 추후 호환성 고려.
- UUID 데이터 타입의 정확한 매핑 확인.

## 🔗 의존성 (Dependencies)
- Task 1.1 (DB 환경 구성 및 스키마 적용)

## 📅 작업 순서
- **선행 작업**: Task 1.1
- **후행 작업**: 백엔드 API 개발 단계에서의 단위 테스트 데이터로 활용
"@
    },
    @{
        title = "[Phase 2: BE] Task 2.1: 백엔드 아키텍처 스켈레톤 구성"
        labels = "kind:task,area:backend,complexity:low"
        body = @"
## 📝 Todo
- [ ] npm init 및 필수 패키지 설치 (express, pg, dotenv, cors, helmet)
- [ ] 프로젝트 폴더 구조 생성 (config, controllers, services, models, routes, middlewares)
- [ ] pg 라이브러리를 이용한 DB 연결 모듈(Pool) 작성 및 연결 테스트

## ✅ 완료 조건 (Definition of Done)
- [ ] 서버 실행 시 DB 연결 성공 로그 확인
- [ ] 레이어드 아키텍처 패턴(Controller-Service-Model)에 따른 디렉토리 구조 확립
- [ ] 전역 에러 핸들링 및 로깅 미들웨어 적용 확인

## ⚙️ 기술적 고려사항
- `pg` 라이브러리의 커넥션 풀(Pool) 설정을 아키텍처 원칙에 명시된 환경 변수로 관리.
- Prisma 사용 금지 원칙을 준수하며 순수 SQL 기반의 Model 레이어 구축.

## 🔗 의존성 (Dependencies)
- Task 1.1 (DB 환경 구성)

## 📅 작업 순서
- **선행 작업**: Task 1.1
- **후행 작업**: Task 2.2 (사용자 인증 API), Task 2.5 (WebSocket 초기화)
"@
    },
    @{
        title = "[Phase 2: BE] Task 2.2: 사용자 인증 및 개인화 설정 API (UC-01, UC-07)"
        labels = "kind:feature,area:backend,complexity:medium"
        body = @"
## 📝 Todo
- [ ] Argon2/Bcrypt를 이용한 비밀번호 해싱 및 회원가입 API 구현
- [ ] 로그인 API 구현 및 JWT(Access/Refresh) 발급 로직 구축
- [ ] 사용자 테마(theme) 및 언어(language) 업데이트 API 구현

## ✅ 완료 조건 (Definition of Done)
- [ ] /api/auth/register, /api/auth/login 정상 동작 및 토큰 발급 확인
- [ ] 회원가입 시 PRD 명세에 따른 기본 설정(LIGHT/KO) 자동 저장 확인
- [ ] 테마/언어 변경 시 서버 DB에 영구 저장되고 조회 시 반영되는지 확인

## ⚙️ 기술적 고려사항
- JWT 서명 시 `HS256` 알고리즘 및 환경 변수 `JWT_SECRET` 사용.
- 개인화 설정(Theme, Language)은 v2 핵심 요구사항으로 서버 사이드 저장이 필수임.

## 🔗 의존성 (Dependencies)
- Task 2.1 (백엔드 스켈레톤)

## 📅 작업 순서
- **선행 작업**: Task 2.1
- **후행 작업**: Task 2.3 (팀 관리 API), Task 3.2 (프론트엔드 인증 UI)
"@
    },
    @{
        title = "[Phase 2: BE] Task 2.3: 팀 관리 및 초대 API (UC-02)"
        labels = "kind:feature,area:backend,complexity:medium"
        body = @"
## 📝 Todo
- [ ] 팀 생성 API (자동으로 생성자를 LEADER 권한의 멤버로 등록) 구현
- [ ] 6자리 랜덤 초대 코드(invite_code) 생성 및 중복 검증 로직 구현
- [ ] 초대 코드를 이용한 팀 가입 및 내 소속 팀 목록 조회 API 구현

## ✅ 완료 조건 (Definition of Done)
- [ ] 신규 팀 생성 시 `TEAMS`와 `TEAM_MEMBERS` 테이블에 트랜잭션 단위로 동시 저장 확인
- [ ] 6자리 초대 코드가 유니크하게 생성되고 이를 통해 타 사용자가 가입 가능한지 확인
- [ ] 다중 팀 소속 원칙에 따라 사용자가 여러 팀의 목록을 가져올 수 있는지 확인

## ⚙️ 기술적 고려사항
- 초대 코드 생성 시 충돌 방지를 위한 재시도 로직 또는 사전 검증 필요.
- DB 트랜잭션을 사용하여 팀 생성 실패 시 멤버십 정보가 남지 않도록 처리.

## 🔗 의존성 (Dependencies)
- Task 2.2 (사용자 인증 API)

## 📅 작업 순서
- **선행 작업**: Task 2.2
- **후행 작업**: Task 2.4 (일정 관리 API), Task 3.3 (프론트엔드 팀 UI)
"@
    },
    @{
        title = "[Phase 2: BE] Task 2.4: 캘린더 및 일정 관리 API (UC-03, UC-04, UC-06)"
        labels = "kind:feature,area:backend,complexity:high"
        body = @"
## 📝 Todo
- [ ] 특정 팀의 기간별(월/주) 일정 목록 조회 API 구현
- [ ] 팀장 권한 검증 미들웨어 구현 및 일정 CUD API 연동
- [ ] 일정 변경 요청(Change Request) 생성 및 상태(승인/반려) 업데이트 로직 구현

## ✅ 완료 조건 (Definition of Done)
- [ ] 날짜 범위(`start_date`, `end_date`) 기반의 일정 필터링 조회 성공
- [ ] 팀원 권한으로 일정 직접 수정 시도 시 403 Forbidden 반환 확인
- [ ] 변경 요청 승인 시 `SCHEDULES` 테이블 데이터가 요청된 내용으로 자동 갱신 확인

## ⚙️ 기술적 고려사항
- `JSONB` 타입의 `content` 컬럼을 활용하여 제목, 시간 등 변경될 필드를 유연하게 처리.
- 일정 확정권은 팀장에게만 있다는 비즈니스 규칙 엄격 적용.

## 🔗 의존성 (Dependencies)
- Task 2.3 (팀 관리 API)

## 📅 작업 순서
- **선행 작업**: Task 2.3
- **후행 작업**: Task 3.4 (프론트엔드 캘린더 UI), Task 2.5 (WebSocket 알림)
"@
    },
    @{
        title = "[Phase 2: BE] Task 2.5: WebSocket 실시간 채팅 및 알림 (UC-05)"
        labels = "kind:feature,area:backend,complexity:high"
        body = @"
## 📝 Todo
- [ ] Socket.io 서버 초기화 및 JWT 핸드셰이크 인증 핸들러 구현
- [ ] `team_id` + `chat_date` 조합의 Room 관리(Join/Leave) 로직 구현
- [ ] 채팅 메시지 브로드캐스팅 및 `CHATS` 테이블 비동기 저장 처리
- [ ] 일정 상태 변경(승인/반려) 시 해당 팀원들에게 실시간 이벤트 발송 구현

## ✅ 완료 조건 (Definition of Done)
- [ ] 동일 날짜 룸에 접속한 사용자 간 실시간 메시지 송수신 확인
- [ ] 채팅 내역이 DB에 유실 없이 저장되고 날짜 변경 시 이전 내역 로드 확인
- [ ] 일정 변경 승인 시 브라우저 알림 또는 채팅창 시스템 메시지 수신 확인

## ⚙️ 기술적 고려사항
- WebSocket 연결 시에도 JWT를 통한 보안 검증 필수.
- 일자별로 채팅방을 관리하여 캘린더 날짜 클릭 시 해당 룸으로 전환하는 구조 설계.

## 🔗 의존성 (Dependencies)
- Task 2.1 (백엔드 스켈레톤), Task 2.4 (일정 관리 API)

## 📅 작업 순서
- **선행 작업**: Task 2.1, Task 2.4
- **후행 작업**: Task 3.5 (프론트엔드 채팅 UI)
"@
    },
    @{
        title = "[Phase 3: FE] Task 3.1: 프론트엔드 보일러플레이트 및 환경 설정"
        labels = "kind:task,area:frontend,complexity:low"
        body = @"
## 📝 Todo
- [ ] Vite + React 19 + TypeScript 프로젝트 초기화
- [ ] Zustand(상태), TanStack Query(데이터), React Router(라우팅) 설정
- [ ] i18next 설정 및 CSS Variables 기반 테마(Dark/Light) 스켈레톤 구축

## ✅ 완료 조건 (Definition of Done)
- [ ] 기본 Hello World 페이지 및 라우팅 정상 동작 확인
- [ ] KO/EN 언어 파일 기반의 번역 텍스트 렌더링 확인
- [ ] 로컬 환경에서 다크모드/라이트모드 수동 토글 확인

## ⚙️ 기술적 고려사항
- React 19의 최신 훅 및 성능 최적화 기능 적극 활용.
- CSS 변수를 활용하여 런타임 테마 전환 시 성능 저하 방지.

## 🔗 의존성 (Dependencies)
- 없음 (BE와 병렬 작업 가능)

## 📅 작업 순서
- **선행 작업**: 없음
- **후행 작업**: Task 3.2 (인증 UI)
"@
    },
    @{
        title = "[Phase 3: FE] Task 3.2: 인증 및 공통 레이아웃 (UC-01, UC-07)"
        labels = "kind:feature,area:frontend,complexity:medium"
        body = @"
## 📝 Todo
- [ ] 로그인 및 회원가입 폼 구현 (반응형 레이아웃 적용)
- [ ] API 호출 인터셉터 구성 및 Zustand 유저 스토어 연동
- [ ] 헤더/사이드바에 언어 전환 및 테마 토글 버튼 구현 (BE 동기화 포함)

## ✅ 완료 조건 (Definition of Done)
- [ ] 가입 및 로그인 성공 후 메인 페이지 진입 확인
- [ ] 테마/언어 변경 시 서버 API 호출 및 페이지 새로고침 후에도 유지 확인
- [ ] 로그인하지 않은 사용자의 보호된 페이지 접근 차단 확인

## ⚙️ 기술적 고려사항
- FOUC(Flash of Unstyled Content)를 방지하기 위해 렌더링 전 테마 값 초기화 로직 적용.
- 반응형 와이어프레임 명세에 따라 모바일 햄버거 메뉴 및 헤더 배치 준수.

## 🔗 의존성 (Dependencies)
- Task 3.1 (FE 환경 설정), Task 2.2 (BE 인증 API)

## 📅 작업 순서
- **선행 작업**: Task 3.1, Task 2.2
- **후행 작업**: Task 3.3 (팀 UI)
"@
    },
    @{
        title = "[Phase 3: FE] Task 3.3: 대시보드 및 팀 관리 UI (UC-02)"
        labels = "kind:feature,area:frontend,complexity:medium"
        body = @"
## 📝 Todo
- [ ] 사이드바 내 소속 팀 목록 렌더링 및 팀 전환 기능 구현
- [ ] 팀 생성 모달 및 초대 코드 입력 가입 모달 구현
- [ ] 팀 정보 및 멤버 목록 조회 화면 구성

## ✅ 완료 조건 (Definition of Done)
- [ ] 팀 생성 직후 사이드바 목록이 TanStack Query에 의해 즉시 갱신 확인
- [ ] 존재하지 않는 초대 코드 입력 시 명확한 에러 메시지 노출 확인
- [ ] 팀 선택 시 해당 팀의 일정 및 채팅 공간으로 이동 확인

## ⚙️ 기술적 고려사항
- TanStack Query의 `invalidateQueries`를 사용하여 팀 목록 캐시 최신화.
- 모달 UI 구현 시 와이어프레임의 표준 레이아웃 준수.

## 🔗 의존성 (Dependencies)
- Task 3.2 (인증 UI), Task 2.3 (BE 팀 API)

## 📅 작업 순서
- **선행 작업**: Task 3.2, Task 2.3
- **후행 작업**: Task 3.4 (캘린더 UI)
"@
    },
    @{
        title = "[Phase 3: FE] Task 3.4: 캘린더 및 일정 관리 UI (UC-03, UC-04, UC-06)"
        labels = "kind:feature,area:frontend,complexity:high"
        body = @"
## 📝 Todo
- [ ] FullCalendar 또는 커스텀 캘린더 그리드 구현 (월/주/일 뷰)
- [ ] 일정 클릭 시 상세 정보 모달 및 권한별(팀장/팀원) 버튼 노출 처리
- [ ] 팀장용 변경 요청 목록 대시보드 및 승인/반려 인터페이스 구현

## ✅ 완료 조건 (Definition of Done)
- [ ] 캘린더에 팀 일정이 시각적으로 정상 표시 및 기간 이동 가능 확인
- [ ] 팀원이 일정 클릭 시 'Request Change' 버튼 및 폼 정상 동작 확인
- [ ] 팀장이 요청 승인 시 캘린더 데이터가 실시간으로 자동 갱신 확인

## ⚙️ 기술적 고려사항
- 캘린더 렌더링 최적화를 위해 React.memo 및 가상화 기법 고려.
- 복잡한 날짜 계산 로직을 위해 `date-fns` 또는 `dayjs` 라이브러리 활용.

## 🔗 의존성 (Dependencies)
- Task 3.3 (팀 UI), Task 2.4 (BE 일정 API)

## 📅 작업 순서
- **선행 작업**: Task 3.3, Task 2.4
- **후행 작업**: Task 3.5 (채팅 UI)
"@
    },
    @{
        title = "[Phase 3: FE] Task 3.5: 실시간 채팅 패널 UI (UC-05)"
        labels = "kind:feature,area:frontend,complexity:high"
        body = @"
## 📝 Todo
- [ ] 캘린더 날짜 클릭 시 우측 슬라이드 인(Desktop) 또는 바텀 시트(Mobile) 채팅창 구현
- [ ] socket.io-client 연동 및 실시간 메시지 송수신 UI 구현
- [ ] 시스템 메시지(일정 승인 등) 및 변경 요청 카드의 채팅 내 렌더링

## ✅ 완료 조건 (Definition of Done)
- [ ] 날짜 클릭 시 해당 날짜 전용 채팅방 입장 및 과거 메시지 로딩 확인
- [ ] 메시지 전송 시 지연 없이 내 화면 및 타 팀원 화면에 실시간 반영 확인
- [ ] 채팅창 내부의 '승인/반려' 카드 상호작용 성공 확인

## ⚙️ 기술적 고려사항
- 반응형 와이어프레임에 명시된 1024px 브레이크포인트 기반 레이아웃 전환 구현.
- 채팅 스크롤 유지 및 이미지/파일 업로드 제외(Scope 준수) 확인.

## 🔗 의존성 (Dependencies)
- Task 3.4 (캘린더 UI), Task 2.5 (BE WebSocket)

## 📅 작업 순서
- **선행 작업**: Task 3.4, Task 2.5
- **후행 작업**: 전체 시스템 통합 테스트 및 최종 배포 점검
"@
    }
)

Write-Host "Team CalTalk - GitHub Issues 생성을 시작합니다..." -ForegroundColor Cyan

foreach ($issue in $issues) {
    Write-Host "생성 중: $($issue.title)..." -ForegroundColor Yellow
    # Create the issue using gh CLI
    gh issue create --title $issue.title --body $issue.body --label $issue.labels
}

Write-Host "`n모든 이슈 생성이 완료되었습니다." -ForegroundColor Green
