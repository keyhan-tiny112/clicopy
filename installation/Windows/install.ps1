# 0. Install Git (if missing)
if (!(Get-Command git -ErrorAction SilentlyContinue)) {
    winget install --id Git.Git -e --accept-package-agreements --accept-source-agreements 
}

# Get install path
$path = Read-Host "Install Path"

git clone https://github.com/erfan114/clicopy.git $path
Set-Location $path

# 1. Install Rust
if (!(Get-Command cargo -ErrorAction SilentlyContinue)) {
    Invoke-RestMethod https://win.rustup.rs/x86_64 -OutFile rustup-init.exe
    .\rustup-init.exe -y
    $env:PATH += ";$env:USERPROFILE\.cargo\bin"
}

# 2. Install Bun
if (!(Get-Command bun -ErrorAction SilentlyContinue)) {
    powershell -c "irm bun.sh/install.ps1 | iex"
    $env:PATH += ";$env:USERPROFILE\.bun\bin"
}

# 3. Install dependencies
bun install

# 4. Run
bun tauri dev