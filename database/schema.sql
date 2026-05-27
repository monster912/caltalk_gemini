-- 1. ENUM 타입 정의
CREATE TYPE user_theme AS ENUM ('LIGHT', 'DARK');
CREATE TYPE user_language AS ENUM ('KO', 'EN');
CREATE TYPE member_role AS ENUM ('LEADER', 'MEMBER');
CREATE TYPE request_status AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- 2. USERS 테이블 생성
CREATE TABLE USERS (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    theme user_theme NOT NULL DEFAULT 'LIGHT',
    language user_language NOT NULL DEFAULT 'KO',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE USERS IS '사용자 기본 정보 및 설정을 저장하는 테이블';
COMMENT ON COLUMN USERS.id IS '사용자 고유 식별자 (UUID v4)';
COMMENT ON COLUMN USERS.email IS '로그인용 이메일 주소 (유니크)';
COMMENT ON COLUMN USERS.password IS '암호화된 비밀번호';
COMMENT ON COLUMN USERS.name IS '사용자 실명 또는 닉네임';
COMMENT ON COLUMN USERS.theme IS 'UI 테마 설정 (LIGHT/DARK)';
COMMENT ON COLUMN USERS.language IS '기본 언어 설정 (KO/EN)';
COMMENT ON COLUMN USERS.created_at IS '계정 생성 일시';
COMMENT ON COLUMN USERS.updated_at IS '정보 수정 일시';

-- 3. TEAMS 테이블 생성
CREATE TABLE TEAMS (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    invite_code CHAR(6) NOT NULL UNIQUE,
    leader_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_teams_leader FOREIGN KEY (leader_id) REFERENCES USERS(id)
);

COMMENT ON TABLE TEAMS IS '그룹 및 팀 정보를 관리하는 테이블';
COMMENT ON COLUMN TEAMS.id IS '팀 고유 식별자 (UUID)';
COMMENT ON COLUMN TEAMS.name IS '팀 명칭';
COMMENT ON COLUMN TEAMS.invite_code IS '6자리 유니크 초대 코드';
COMMENT ON COLUMN TEAMS.leader_id IS '팀을 생성한 리더의 ID';
COMMENT ON COLUMN TEAMS.created_at IS '팀 생성 일시';

-- 4. TEAM_MEMBERS 테이블 생성
CREATE TABLE TEAM_MEMBERS (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL,
    user_id UUID NOT NULL,
    role member_role NOT NULL DEFAULT 'MEMBER',
    joined_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_team_members_team FOREIGN KEY (team_id) REFERENCES TEAMS(id) ON DELETE CASCADE,
    CONSTRAINT fk_team_members_user FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE CASCADE,
    CONSTRAINT uk_team_members_team_user UNIQUE (team_id, user_id)
);

COMMENT ON TABLE TEAM_MEMBERS IS '팀과 사용자 간의 소속 관계 및 권한을 관리하는 테이블';
COMMENT ON COLUMN TEAM_MEMBERS.team_id IS '팀 ID';
COMMENT ON COLUMN TEAM_MEMBERS.user_id IS '사용자 ID';
COMMENT ON COLUMN TEAM_MEMBERS.role IS '팀 내 역할 (LEADER/MEMBER)';
COMMENT ON COLUMN TEAM_MEMBERS.joined_at IS '팀 가입 일시';

-- 5. SCHEDULES 테이블 생성
CREATE TABLE SCHEDULES (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    start_time TIMESTAMPTZ NOT NULL,
    end_time TIMESTAMPTZ NOT NULL,
    schedule_date DATE NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_schedules_team FOREIGN KEY (team_id) REFERENCES TEAMS(id) ON DELETE CASCADE
);

COMMENT ON TABLE SCHEDULES IS '팀별 공유 일정을 관리하는 테이블';
COMMENT ON COLUMN SCHEDULES.team_id IS '일정이 속한 팀 ID';
COMMENT ON COLUMN SCHEDULES.title IS '일정 제목';
COMMENT ON COLUMN SCHEDULES.description IS '일정 상세 내용';
COMMENT ON COLUMN SCHEDULES.start_time IS '일정 시작 시간';
COMMENT ON COLUMN SCHEDULES.end_time IS '일정 종료 시간';
COMMENT ON COLUMN SCHEDULES.schedule_date IS '캘린더 조회를 위한 일정 날짜';

-- 6. CHATS 테이블 생성
CREATE TABLE CHATS (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_id UUID NOT NULL,
    user_id UUID,
    message TEXT NOT NULL,
    chat_date DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_chats_team FOREIGN KEY (team_id) REFERENCES TEAMS(id) ON DELETE CASCADE,
    CONSTRAINT fk_chats_user FOREIGN KEY (user_id) REFERENCES USERS(id) ON DELETE SET NULL
);

COMMENT ON TABLE CHATS IS '팀 내 실시간 채팅 메시지를 저장하는 테이블';
COMMENT ON COLUMN CHATS.team_id IS '채팅이 발생한 팀 ID';
COMMENT ON COLUMN CHATS.user_id IS '메시지 작성자 ID (탈퇴 시 NULL)';
COMMENT ON COLUMN CHATS.message IS '채팅 메시지 내용';
COMMENT ON COLUMN CHATS.chat_date IS '일자별 조회를 위한 날짜 데이터';

-- 7. CHANGE_REQUESTS 테이블 생성
CREATE TABLE CHANGE_REQUESTS (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    schedule_id UUID NOT NULL,
    requester_id UUID NOT NULL,
    team_id UUID NOT NULL,
    content JSONB NOT NULL,
    status request_status NOT NULL DEFAULT 'PENDING',
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_change_requests_schedule FOREIGN KEY (schedule_id) REFERENCES SCHEDULES(id) ON DELETE CASCADE,
    CONSTRAINT fk_change_requests_requester FOREIGN KEY (requester_id) REFERENCES USERS(id) ON DELETE CASCADE,
    CONSTRAINT fk_change_requests_team FOREIGN KEY (team_id) REFERENCES TEAMS(id) ON DELETE CASCADE
);

COMMENT ON TABLE CHANGE_REQUESTS IS '일정 변경 제안 및 승인 프로세스를 관리하는 테이블';
COMMENT ON COLUMN CHANGE_REQUESTS.schedule_id IS '수정 대상 일정 ID';
COMMENT ON COLUMN CHANGE_REQUESTS.requester_id IS '변경을 요청한 사용자 ID';
COMMENT ON COLUMN CHANGE_REQUESTS.team_id IS '해당 요청이 속한 팀 ID';
COMMENT ON COLUMN CHANGE_REQUESTS.content IS '변경될 데이터(제목, 시간 등)를 담은 JSONB';
COMMENT ON COLUMN CHANGE_REQUESTS.status IS '요청 상태 (PENDING/APPROVED/REJECTED)';

-- 8. 성능 최적화 인덱스 생성
CREATE UNIQUE INDEX idx_teams_invite_code ON TEAMS(invite_code);
CREATE INDEX idx_team_members_user_team ON TEAM_MEMBERS(user_id, team_id);
CREATE INDEX idx_schedules_team_date ON SCHEDULES(team_id, schedule_date);
CREATE INDEX idx_chats_team_date ON CHATS(team_id, chat_date);
CREATE INDEX idx_change_requests_team_status ON CHANGE_REQUESTS(team_id, status);
CREATE UNIQUE INDEX idx_users_email ON USERS(email);
