# memex-kit

> Claude Code를 위한 메모리 인덱싱 시스템
> Serena MCP 기반의 세션 간 컨텍스트 유지 도구

**Memex** (1945, Vannevar Bush) - "Memory Extender"의 현대적 구현

[English](README.md)

⚠️ **중요: memex-kit은 pip 패키지가 아닙니다!** Claude Code 설정 파일입니다.

```bash
# 설치 확인 (올바른 방법)
ls ~/.claude/commands/ | grep -E "(save-context|update-index|archive)"

# pip show memex-kit ← 이렇게 하면 안 됨!
```

---

## 특징

- **자동 인덱싱**: 메모리를 카테고리별로 자동 정리
- **저장 트리거**: 중요한 결정/작업 완료 시 저장 제안
- **세션 연속성**: 세션 간 컨텍스트 유지
- **간편한 명령어**: `/mk:init`, `/mk:save`, `/mk:index`, `/mk:end`

---

## 왜 memex-kit인가?

Serena MCP만 사용할 때와 비교:

| 항목 | 기본 Serena | memex-kit |
|------|------------|-----------|
| **저장** | 수동 (`write_memory`) | `/mk:save` + 자동 제안 |
| **구조** | 플랫 리스트 | 카테고리별 정리 + 인덱스 |
| **검색성** | 이름 기억해야 함 | `_index`에서 요약+날짜로 탐색 |
| **세션 시작** | 뭐가 있는지 모름 | 인덱스 읽으면 전체 파악 |
| **프로젝트 초기화** | 수동 설정 | `/mk:init` 한 번 |

### 핵심 장점

1. **발견성 (Discoverability)**
   - Serena: "그때 그거 뭐라고 저장했더라?"
   - memex-kit: `_index` 보면 전체 메모리 요약+날짜 한눈에

2. **저장 습관화**
   - Serena: 저장하려면 직접 요청해야 함
   - memex-kit: 중요한 결정/작업 후 Claude가 "저장할까요?" 제안

3. **컨텍스트 연속성**
   - Serena: 새 세션마다 뭘 읽어야 할지 고민
   - memex-kit: 인덱스 → 관련 메모리 빠르게 로드

### 왜 폴더가 아닌 접두어 방식인가?

Serena는 폴더 구조를 지원하지만, `list_memories()` API는 **루트 레벨만 스캔**합니다:

```
.serena/memories/
├── decision-auth.md      ← list_memories()로 보임 ✓
├── feature-login.md      ← list_memories()로 보임 ✓
├── decisions/
│   └── auth.md           ← 안 보임 ✗
└── features/
    └── login.md          ← 안 보임 ✗
```

폴더 방식 사용 시 `_index` 자동 생성이 불가능해집니다.
memex-kit은 접두어 방식으로 모든 메모리를 루트에 저장하여 **완전한 자동 인덱싱**을 구현합니다.

> **한 마디로:** Serena는 저장소, memex-kit은 **정리된 지식 관리 시스템**

---

## 요구사항

- [Claude Code](https://claude.ai/code) CLI
- [Serena MCP](https://github.com/oraios/serena) (메모리 저장용)

### Serena MCP 설치

```bash
# uv 사용 시 (권장)
claude mcp add serena -- uvx serena

# 또는 pip 사용 시
pip install serena
claude mcp add serena -- serena
```

---

## 설치

### 방법 1: 자동 설치 (권장)

```bash
curl -fsSL https://raw.githubusercontent.com/shanash/memex-kit/main/install.sh | bash
```

### 방법 2: 수동 설치

```bash
git clone https://github.com/shanash/memex-kit.git
cd memex-kit
./install.sh
```

### 방법 3: 파일 직접 복사

```bash
git clone https://github.com/shanash/memex-kit.git
cp -r memex-kit/.claude/* ~/.claude/
```

---

## 사용법

### 1. 프로젝트 초기화

새 프로젝트에서:

```
/mk:init
```

→ 대화형으로 프로젝트 정보 입력
→ CLAUDE.md 생성
→ Serena 프로젝트 등록
→ 초기 `_index` 메모리 생성

### 2. 컨텍스트 저장

작업 중 중요한 결정/구현/논의 후:

```
/mk:save                     # 대화형
/mk:save decision auth-jwt   # 타입+제목 직접 지정
```

### 3. 인덱스 갱신

전체 메모리 인덱스 재생성:

```
/mk:index
```

### 4. 메모리 목록 확인

```
/mk:list
```

### 5. 오래된 메모리 아카이브

메모리가 많아지면 오래된 것을 아카이브:

```
/mk:archive                    # 대화형
/mk:archive --before 2025-06   # 특정 날짜 이전
/mk:archive --type bugfix      # 특정 타입 전체
```

### 6. 세션 종료

작업 세션 종료 시:

```
/mk:end
```

→ 세션 요약 저장 (`session-last`)
→ 다음 작업 기록 (`session-next`)
→ 프로젝트 컨텍스트 업데이트 (`session-context`)
→ `_index` 갱신

---

## 메모리 명명 규칙

| 접두어 | 용도 | 예시 |
|--------|------|------|
| `decision-` | 설계/아키텍처 결정 | `decision-auth-jwt` |
| `feature-` | 기능 구현 기록 | `feature-login-system` |
| `bugfix-` | 버그 수정 이력 | `bugfix-2025-01-01-null` |
| `discussion-` | 주요 논의 내용 | `discussion-api-design` |
| `learning-` | 발견/학습 내용 | `learning-react-hydration` |
| `session-` | 세션 상태 (자동) | `session-last`, `session-next` |

---

## 인덱스 구조

`_index` 메모리는 다음과 같이 구성됩니다:

```markdown
# 프로젝트 메모리 인덱스

> **최종 업데이트**: 2025-01-01
> **총 메모리**: 15개

## 빠른 탐색

### 설계 결정 (decision-) [3개]
| 메모리명 | 날짜 | 요약 |
|---------|------|------|
| decision-auth-jwt | 2025-01-01 | JWT 인증 선택 |
...

## 최근 추가 (최근 5개)
1. [2025-01-01] feature-dashboard - 대시보드 구현
...
```

---

## 자동 저장 트리거

memex-kit 설치 후, Claude는 다음 상황에서 저장을 제안합니다:

- 설계/아키텍처 결정 완료 시
- 기능 구현 완료 시
- 버그 수정 완료 시
- 중요한 논의 종료 시
- 새로운 발견/학습 시

---

## 파일 구조

```
~/.claude/
├── CLAUDE.md                    # 글로벌 설정 (memex-kit 규칙 포함)
└── commands/
    ├── mk:init.md           # 프로젝트 초기화
    ├── mk:save.md          # 컨텍스트 저장
    ├── mk:index.md          # 인덱스 갱신
    ├── mk:list.md         # 메모리 목록
    ├── mk:archive.md      # 메모리 아카이브
    └── mk:end.md          # 세션 종료
```

---

## 대규모 프로젝트 관리

### 왜 아카이브가 필요한가?

memex-kit은 모든 메모리를 루트에 저장합니다 (`list_memories()` API 제약).
메모리가 수백 개 이상이면:
- 목록 조회가 느려짐
- `_index`가 너무 길어짐
- 관련 메모리 찾기 어려움

**해결책**: 오래된 메모리를 `archive/` 폴더로 이동
- `list_memories()`에서 제외 → 활성 메모리만 관리
- 필요시 아카이브에서 수동 접근 가능

### 권장 전략

| 메모리 수 | 권장 전략 |
|----------|----------|
| ~50개 | 접두어만으로 충분 |
| ~200개 | `_index` 의존, 가끔 아카이브 |
| 500+개 | 정기적 아카이브 필수 |

**아카이브 구조:**

```
.serena/memories/
├── _index.md              ← 활성 메모리만 인덱싱
├── decision-*.md          ← 활성 (항상 유지 권장)
├── feature-*.md           ← 활성
├── bugfix-*.md            ← 오래되면 아카이브
└── archive/               ← list_memories()에서 제외됨
    ├── 2024/
    │   └── bugfix-old.md
    └── 2025-Q1/
```

**권장 아카이브 대상:**
- 3개월 이상 된 `bugfix-*`
- 완료된 `discussion-*`
- 오래된 `learning-*`

**유지 권장:**
- `decision-*` (프로젝트 수명 동안)
- 최근 `feature-*`

---

## 기존 설정과의 호환

- 기존 `~/.claude/CLAUDE.md`가 있으면 백업 후 내용 추가
- 기존 commands는 유지, 새 명령어만 추가
- 충돌 시 기존 파일 우선 (덮어쓰지 않음)

---

## 삭제 (Uninstall)

```bash
# 방법 1: 원격 실행
curl -fsSL https://raw.githubusercontent.com/shanash/memex-kit/main/uninstall.sh | bash

# 방법 2: 로컬 실행
git clone https://github.com/shanash/memex-kit.git
cd memex-kit
./uninstall.sh
```

삭제 시:
- memex-kit 명령어 제거 (`/mk:init`, `/mk:save` 등)
- CLAUDE.md에서 memex-kit 설정 제거
- 설치 전 백업이 있으면 복원 옵션 제공
- **Serena 메모리는 보존됨** (프로젝트 데이터 유지)

---

## 라이선스

MIT License

---

## 크레딧

- **Memex 개념**: Vannevar Bush, "As We May Think" (1945)
- **Serena MCP**: [oraios/serena](https://github.com/oraios/serena)
- **영감**: [centminmod/my-claude-code-setup](https://github.com/centminmod/my-claude-code-setup)
