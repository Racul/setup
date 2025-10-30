# Development Environment Setup

이 저장소는 새로운 서버나 개발 환경을 빠르게 설정하기 위한 자동화 스크립트 모음입니다.

## 📋 목차

- [스크립트 목록](#스크립트-목록)
- [설치 순서](#설치-순서)
- [개별 스크립트 설명](#개별-스크립트-설명)
- [설정 파일](#설정-파일)

## 🚀 빠른 시작

### sudo 권한이 있는 경우

```bash
git clone <repository-url>
cd setup

# 1. 패키지 설치
./setup_apt.sh

# 2. dotfiles 적용
./setup_dots.sh

# 3. 플랫폼 로그인 (선택사항)
./login.sh

# 4. 기본 쉘 변경
chsh -s $(which zsh)

# 5. 터미널 재시작
exec zsh
```

### sudo 권한이 없는 경우

```bash
git clone <repository-url>
cd setup

# 1. 패키지 소스 컴파일 설치
./setup_apt_nosudo.sh

# 2. PATH 적용
source ~/.bashrc

# 3. dotfiles 적용
./setup_dots.sh

# 4. 플랫폼 로그인 (선택사항)
./login.sh

# 5. 기본 쉘 변경 (관리자 권한 필요 시 건너뛰기)
chsh -s $(which zsh)

# 6. 터미널 재시작
exec zsh
```

## 📜 스크립트 목록

| 스크립트 | 용도 | sudo 필요 |
|---------|------|-----------|
| `setup_apt.sh` | 패키지 관리자를 통한 도구 설치 | ✅ |
| `setup_apt_nosudo.sh` | 소스 컴파일을 통한 도구 설치 | ❌ |
| `setup_dots.sh` | dotfiles 복사 및 적용 | ❌ |
| `login.sh` | GitHub/wandb/HuggingFace 로그인 | ❌ |

## 🔧 개별 스크립트 설명

### 1. setup_apt.sh

**용도**: sudo 권한이 있는 환경에서 apt를 통한 패키지 설치

**설치 항목**:
- Core development libraries (libffi-dev, libbz2-dev, liblzma-dev 등)
- build-essential 및 관련 의존성
- 유틸리티: tree, zsh, curl, git, tmux
- uv (Python 패키지 관리자)
- Oh My Zsh 및 플러그인:
  - zsh-autosuggestions
  - zsh-syntax-highlighting

**사용법**:
```bash
./setup_apt.sh
```

**예상 소요 시간**: 5-10분 (네트워크 속도에 따라 다름)

### 2. setup_apt_nosudo.sh

**용도**: sudo 권한이 없는 환경에서 소스 컴파일을 통한 설치

**설치 항목**:
- tree (소스 컴파일)
- zsh (소스 컴파일)
- uv (Python 패키지 관리자)
- tmux (소스 컴파일)
- Oh My Zsh 및 플러그인

**설치 위치**: `~/.local/bin/` 및 `~/.local/lib/`

**필수 요구사항**:
- gcc/cc 컴파일러
- make
- git
- curl 또는 wget

**사용법**:
```bash
./setup_apt_nosudo.sh
source ~/.bashrc  # PATH 적용
```

**예상 소요 시간**: 10-20분 (컴파일 시간 포함)

**참고**: 빌드 파일은 `~/.local/build/`에 저장되며, 설치 완료 후 삭제 가능

### 3. setup_dots.sh

**용도**: dotfiles를 홈 디렉토리로 복사

**적용 파일**:
- `.vimrc` → `~/.vimrc`
- `.zshrc` → `~/.zshrc`
- `.tmux.conf` → `~/.tmux.conf`

**기능**:
- 기존 파일이 있을 경우 자동 백업 (`.backup.YYYYMMDD_HHMMSS` 형식)
- 스크립트 위치에 상관없이 동작 (상대 경로 사용)

**사용법**:
```bash
./setup_dots.sh
source ~/.zshrc  # 설정 적용
```

### 4. login.sh

**용도**: 주요 개발 플랫폼에 대화형 로그인

**지원 플랫폼**:

#### GitHub (gh CLI)
- 브라우저 또는 토큰을 통한 인증
- HTTPS/SSH 프로토콜 선택
- 자동 설치 지원 (sudo 권한 있을 때)

#### Weights & Biases
- API 키를 통한 인증
- 자동 설치: `pip install wandb`
- API 키 위치: https://wandb.ai/authorize

#### Hugging Face
- API 토큰을 통한 인증
- 자동 설치: `pip install huggingface_hub`
- 토큰 위치: https://huggingface.co/settings/tokens

**사용법**:
```bash
./login.sh
```

각 플랫폼의 로그인 프로세스를 대화형으로 안내합니다.

## 📁 설정 파일

### .vimrc

Vim 에디터 설정 파일

**주요 설정**:
- 줄 번호 표시
- 자동 들여쓰기
- 탭을 공백 4칸으로 변환
- 검색어 하이라이트
- 커서 라인 강조
- 마우스 지원
- 키 매핑: `jj` → ESC, `Ctrl+S` → 저장

### .zshrc

Zsh 쉘 설정 파일

**주요 설정**:
- Oh My Zsh 사용
- 테마: agnoster
- 플러그인: git, zsh-autosuggestions, zsh-syntax-highlighting
- 사용자 프롬프트 커스터마이징
- PATH 설정

**테마 특징**:
- Git 상태 표시
- 2줄 프롬프트
- 색상 구분

### .tmux.conf

tmux 터미널 멀티플렉서 설정 파일

**주요 설정**:
- 마우스 지원
- 256 색상 지원
- 직관적인 창 분할 키바인딩
- 상태바 커스터마이징
- Vim 스타일 패널 이동

## 🔍 문제 해결

### zsh 플러그인이 작동하지 않을 때

```bash
# 플러그인 재설치
rm -rf ~/.oh-my-zsh/plugins/zsh-autosuggestions
rm -rf ~/.oh-my-zsh/plugins/zsh-syntax-highlighting
cd ~/.oh-my-zsh/plugins
git clone https://github.com/zsh-users/zsh-autosuggestions.git
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
source ~/.zshrc
```

### PATH가 제대로 설정되지 않을 때

```bash
# .bashrc 또는 .zshrc에 추가
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Oh My Zsh 테마가 깨져 보일 때

Powerline 폰트가 필요합니다:
- Windows Terminal: Cascadia Code PL, MesloLGS NF
- VS Code: 'terminal.integrated.fontFamily' 설정
- iTerm2: Preferences > Profiles > Text > Font

### sudo 없이 zsh를 기본 쉘로 변경하고 싶을 때

`.bashrc` 또는 `.profile` 마지막에 추가:
```bash
if [ -f "$HOME/.local/bin/zsh" ]; then
    export SHELL="$HOME/.local/bin/zsh"
    exec "$HOME/.local/bin/zsh"
fi
```

## 📝 커스터마이징

### 다른 zsh 테마 사용하기

`.zshrc` 파일에서:
```bash
ZSH_THEME="agnoster"  # 원하는 테마로 변경
```

인기 테마: `robbyrussell`, `agnoster`, `powerlevel10k`

### vim 플러그인 매니저 추가하기

vim-plug 설치:
```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

`.vimrc`에 플러그인 추가 후 `:PlugInstall`

### tmux 플러그인 추가하기

TPM (Tmux Plugin Manager) 설치:
```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

`.tmux.conf`에 플러그인 추가 후 `prefix + I`


