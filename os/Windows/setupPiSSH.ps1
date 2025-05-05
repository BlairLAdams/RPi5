# ✅ Filename: setupPiSSH.ps1
# 📦 Purpose: One-time SSH setup for connecting from Windows to Raspberry Pi via key
# 💻 Platform: Windows PowerShell
# 🧠 Features: Input validation, default localhost IP, no emojis, config backup, key install

# ─────────────────────────────────────────────────────────────────────────────
# 📥 STEP 1: PROMPT FOR PI INFO + SSH KEY
# ─────────────────────────────────────────────────────────────────────────────
$piUser = Read-Host "Enter your Pi username [default: pi]"
if ([string]::IsNullOrWhiteSpace($piUser)) { $piUser = "pi" }

$piIP = Read-Host "Enter your Pi IP address [default: 127.0.0.1]"
if ([string]::IsNullOrWhiteSpace($piIP)) { $piIP = "127.0.0.1" }

# Prompt for key file
$keyFiles = Get-ChildItem "$HOME\.ssh" -Filter *.pub
if ($keyFiles.Count -eq 0) {
    Write-Host "ERROR: No public key (.pub) files found in ~/.ssh"
    exit 1
}

Write-Host "`nAvailable public keys:"
$keyFiles | ForEach-Object -Begin { $i = 1 } -Process {
    Write-Host "[$i] $_.Name"
    $i++
}

$selection = Read-Host "`nSelect the number of the key to use"
$selectedKey = $keyFiles[[int]$selection - 1]
$selectedKeyPath = $selectedKey.FullName
$privateKeyPath = $selectedKeyPath -replace "\.pub$",""

# ─────────────────────────────────────────────────────────────────────────────
# 🛡️ STEP 2: BACKUP + UPDATE LOCAL SSH CONFIG
# ─────────────────────────────────────────────────────────────────────────────
$sshDir = "$HOME\.ssh"
$configPath = "$sshDir\config"
$backupPath = "$configPath.bak"

if (Test-Path $configPath) {
    Copy-Item $configPath $backupPath -Force
    Write-Host "Backed up existing SSH config to $backupPath"
}

$escapedKeyPath = $privateKeyPath -replace '\\','/'  # VS Code wants forward slashes

@"
Host pi
  HostName $piIP
  User $piUser
  IdentityFile $escapedKeyPath
"@ | Out-File -Encoding utf8 -FilePath $configPath -Force

# ─────────────────────────────────────────────────────────────────────────────
# 📤 STEP 3: COPY KEY TO PI + AUTHORIZE
# ─────────────────────────────────────────────────────────────────────────────
$tempRemoteKey = "/home/$piUser/tempkey.pub"
Write-Host "Copying public key to ${piUser}@${piIP}..."
scp $selectedKeyPath "${piUser}@${piIP}:${tempRemoteKey}"

Write-Host "Installing key on the Pi..."
ssh "${piUser}@${piIP}" @"
mkdir -p ~/.ssh
cat $tempRemoteKey >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
rm $tempRemoteKey
"@

# ─────────────────────────────────────────────────────────────────────────────
# ✅ STEP 4: VERIFY ACCESS
# ─────────────────────────────────────────────────────────────────────────────
Write-Host "`nSetup complete. Testing ssh pi..."
ssh pi
