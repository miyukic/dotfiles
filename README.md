# dotfiles
dotfiles for miyuki❄

## 💡How to Install
### 🟦 Windows
Still incomplete
```bat
./bootstrap.bat [option]
```

- options
    - `auto`        None CLI interactive mode.
    - `full`        Full install.
    - `curl`        When installing using curl.
 
 ### experiment
 curl.exe -s https://raw.githubusercontent.com/miyukic/dotfiles/master/bootstrap.bat | cmd

### 🐧Linux
Still incomplete
```bash
./bootstrap.sh [option]
```

- options:
    - `auto`        None CLI interactive mode.
    - `full`        Full install.

### 🧠 Locus System
The Locus System files (AI context, memory, and rules) have been permanently migrated to the `~\locus` directory. Please use the `locus` directory for all Locus System updates.

### OpenCode

Strataのモデル名・コンテキスト上限を起動時に取得するプラグインは [OpenCode/](OpenCode/README.md) で管理する。
`bootstrap.bat` または `powershell -NoProfile -ExecutionPolicy Bypass -File .\OpenCode\setup.ps1` で配置できる。
