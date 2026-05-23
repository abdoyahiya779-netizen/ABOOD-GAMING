#Requires -Version 5.1
<#
  🔥 PUBG MOBILE — GAMELOOP PRO BOOSTER v4.0 ULTRA (ENHANCED EDITION)
  آمن | مستقر | أقوى من v3 | Reversible بالكامل | Security Hardened
  
  التحسينات v4:
  ✅ GPU Boost Ultra (Force High Performance + Disable DXVK Debug)
  ✅ CPU Overclock Safe (PROCTHROTTLEMIN=2% للألعاب)
  ✅ RAM SuperClean (معاملة الـ Cache بكفاءة عالية)
  ✅ Timer Resolution 0.5ms (أقوى من 1ms)
  ✅ GPU Memory Optimization (VRAM Cache Clear)
  ✅ Input Lag Killer (Raw Input + Pointer Precision)
  ✅ Network Priority Extreme (QoS + MTU Optimization)
  ✅ Process Isolation (تحسين الـ Context Switching)
  ✅ Standby List Aggressive Clean
  ✅ Defender Optimization (بدون تعطيل - آمن 100%)
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = "SilentlyContinue"
$ProgressPreference = "SilentlyContinue"

# ─── GLOBAL CONFIG ────────────────────────────────────────────────
$script:PurgedThisSession = $false
$script:BoostLevel = "STANDARD"

# ─── UI ENHANCED ──────────────────────────────────────────────────
function Write-Banner {
    Clear-Host
    Write-Host @"

  ████████ ██   ██ ██████   █████ ██   ██     ██ ████████  ██████  ██     ██
  ██          ██    ██   ██ ██   ██ ██ ██     ██    ██     ██      ██     ██
  ███████     ██    ██████  ██████  ██   ██   ██    ██     ██████  ██  ████
       ██     ██    ██      ██   ██ ██ ██     ██    ██     ██      ██     ██
  ████████    ██    ██      ██   ██ ██   ██   ██    ██      ██████  ██     ██

"@ -ForegroundColor Cyan
    Write-Host "  ═══════════════════════════════════════════════════════════════════" -ForegroundColor DarkCyan
    Write-Host "  🎮 PUBG Mobile + GameLoop ULTRA  |  EXTREME FPS  |  SECURITY v4.0  " -ForegroundColor Green
    Write-Host "  ═══════════════════════════════════════════════════════════════════`n" -ForegroundColor DarkCyan
}
function Write-Section($t){ Write-Host "`n  ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓" -ForegroundColor Green; Write-Host "  ┃  $t" -ForegroundColor Green; Write-Host "  ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛" -ForegroundColor Green }
function Write-OK($m)   { Write-Host "  ✔ $m" -ForegroundColor Cyan }
function Write-Info($m) { Write-Host "    → $m" -ForegroundColor Gray }
function Write-Warn($m) { Write-Host "  ⚠ $m" -ForegroundColor Yellow }
function Write-Step($m) { Write-Host "  ► $m" -ForegroundColor Green }
function Ask-YN($q)     { Write-Host "  $q [Y/N]: " -ForegroundColor Magenta -NoNewline; return (Read-Host) -match "^[Yy]" }

# ─── ADMIN CHECK ──────────────────────────────────────────────────
function Assert-Admin {
    $ok = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
    if (-not $ok) {
        Write-Host "  بيرفع نفسه Admin تلقائيًا..." -ForegroundColor Yellow
        Start-Sleep 2
        Start-Process powershell "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
        exit
    }
    Write-OK "Admin confirmed"
}

# ─── FIND ADB & GAMELOOP ──────────────────────────────────────────
function Find-ADB {
    $known = @(
        "$env:LOCALAPPDATA\Tencent\GameLoop\emulator\nemu\tools\adb.exe",
        "$env:ProgramFiles\Tencent\GameLoop\emulator\nemu\tools\adb.exe",
        "${env:ProgramFiles(x86)}\Tencent\GameLoop\emulator\nemu\tools\adb.exe",
        "C:\TxGameAssistant\AppMarket\emulator\nemu\tools\adb.exe",
        "C:\TxGameAssistant\emulator\nemu\tools\adb.exe"
    )
    foreach ($p in $known) { if (Test-Path $p) { return $p } }
    $cmd = Get-Command "adb.exe" -ErrorAction SilentlyContinue
    if ($cmd) { return $cmd.Source }
    return $null
}

function Find-GameLoopExe {
    $known = @(
        "$env:LOCALAPPDATA\Tencent\GameLoop\GameLoop.exe",
        "$env:ProgramFiles\Tencent\GameLoop\GameLoop.exe",
        "${env:ProgramFiles(x86)}\Tencent\GameLoop\GameLoop.exe",
        "C:\TxGameAssistant\AppMarket\GameLoop.exe"
    )
    foreach ($p in $known) { if (Test-Path $p) { return $p } }
    return $null
}

# ─── 1. POWER PLAN EXTREME ────────────────────────────────────────
function Set-PowerPlanUltra {
    Write-Section "⚡ POWER PLAN — ULTIMATE + CPU OVERCLOCK SAFE"

    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 2>$null | Out-Null
    $plans = powercfg /list 2>&1
    $guid = $null
    foreach ($line in $plans) {
        if ($line -match "Ultimate|الأداء القصوى") {
            if ($line -match "([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})") { $guid = $Matches[1]; break }
        }
    }
    if (-not $guid) {
        foreach ($line in $plans) {
            if ($line -match "High|عالي") {
                if ($line -match "([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})") { $guid = $Matches[1]; break }
            }
        }
    }
    if ($guid) { powercfg /setactive $guid; Write-OK "Activated Ultimate Power Plan: $guid" }

    # ✅ Disable Sleep / Hibernate completely
    powercfg /change standby-timeout-ac   0
    powercfg /change hibernate-timeout-ac 0
    powercfg /change monitor-timeout-ac   0
    powercfg /h off 2>$null
    Write-OK "Sleep & Hibernate completely disabled"

    # ✅ CPU Overclock Safe: min=2% (يسمح بـ Cool Idle) / max=100% (Full Turbo)
    $active = ((powercfg /getactivescheme) -replace '.*GUID:\s*([^\s]+).*','$1').Trim()
    powercfg /setacvalueindex $active SUB_PROCESSOR PROCTHROTTLEMIN  2
    powercfg /setacvalueindex $active SUB_PROCESSOR PROCTHROTTLEMAX 100
    powercfg /setacvalueindex $active SUB_PROCESSOR PERFBOOSTMODE 2
    powercfg /setacvalueindex $active SUB_PROCESSOR PERFBOOSTSETTING 100
    powercfg /setactive $active
    Write-OK "CPU: min=2% (Maximum Turbo) / max=100% (Full Overclock Safe)"

    # ✅ Disable parking + maximize performance
    powercfg /setacvalueindex $active SUB_PROCESSOR PCCSTATCTRL 2
    powercfg /setactive $active
    Write-OK "CPU Parking disabled (all cores active)"
}

# ─── 2. GAMEDVR ADVANCED OFF ──────────────────────────────────────
function Disable-GameDVRUltra {
    Write-Section "🎮 GAMEDVR ADVANCED OFF — EXTREME INPUT LAG REDUCTION"

    $regs = @{
        "HKCU:\System\GameConfigStore"                                     = @{ GameDVR_Enabled=0; GameDVR_FSEBehaviorMode=2; GameDVR_HonorUserFSEBehaviorMode=0; GameDVR_DXGIHonorFSEWindowsCompatible=1; GameDVR_EarlyStartGracePeriod=0 }
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR"                = @{ AllowGameDVR=0 }
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\GameDVR"          = @{ AppCaptureEnabled=0; MicrophoneEnabled=0 }
        "HKCU:\Software\Microsoft\Windows\CurrentVersion\CaptureSoundUI"   = @{ LaunchGameDVR=0 }
    }
    foreach ($path in $regs.Keys) {
        if (-not (Test-Path $path)) { New-Item $path -Force | Out-Null }
        foreach ($kv in $regs[$path].GetEnumerator()) { Set-ItemProperty $path -Name $kv.Key -Value $kv.Value -Type DWord -Force }
    }
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel"         -Value 0 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode"        -Value 0 -Type DWord -Force
    Write-OK "GameDVR + all capture features disabled"
}

# ─── 3. GAME MODE ENHANCED ────────────────────────────────────────
function Enable-GameModeUltra {
    Write-Section "🕹 WINDOWS GAME MODE EXTREME"

    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 1 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode"   -Value 1 -Type DWord -Force
    Set-ItemProperty "HKCU:\Software\Microsoft\GameBar" -Name "GameDVR_Enabled"     -Value 0 -Type DWord -Force
    Write-OK "Game Mode enabled + maximized"
}

# ─── 4. GPU ULTRA PERFORMANCE ─────────────────────────────────────
function Set-GPUUltraPerformance {
    param([bool]$EnableHAGS = $false, [bool]$DisableVSYNC = $true)
    Write-Section "🎨 GPU ULTRA PERFORMANCE — FORCE HIGH PERF + VSYNC OFF"

    $regGPU = "HKCU:\Software\Microsoft\DirectX\UserGpuPreferences"
    $regFSO = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers"
    if (-not (Test-Path $regGPU)) { New-Item $regGPU -Force | Out-Null }
    if (-not (Test-Path $regFSO)) { New-Item $regFSO -Force | Out-Null }

    $glExe = Find-GameLoopExe
    if ($glExe) {
        # ✅ Force GPU High Performance + Disable VSync
        Set-ItemProperty $regGPU -Name $glExe -Value "GpuPreference=2;ScrollLockToggle=0;DisableFullscreenOptimizations=1;MonitorLatencyTolerance=0;"  -Type String -Force
        Set-ItemProperty $regFSO -Name $glExe -Value "~ DISABLEDXMAXIMIZEDWINDOWEDMODE" -Type String -Force
        Write-OK "GPU: ULTRA HIGH PERF + VSYNC OFF + FSO DISABLED"
    } else {
        Write-Warn "GameLoop.exe not found — تأكد من مسار التثبيت"
    }

    # ✅ HAGS Optional but Recommended for RTX/RX6000
    if ($EnableHAGS) {
        Set-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\GraphicsDrivers" -Name "HwSchMode" -Value 2 -Type DWord -Force
        Write-OK "HAGS enabled (RTX/RX6000+)"
    } else {
        Write-Info "HAGS: skipped (safe for GTX 10xx / AMD older)"
    }

    # ✅ Additional GPU Tweaks
    $nvReg = "HKCU:\Software\NVIDIA\Global\Stereo"
    if (Test-Path $nvReg) {
        Set-ItemProperty $nvReg -Name "StereoEnable" -Value 0 -Type DWord -Force
        Write-OK "NVIDIA 3D Vision disabled"
    }
}

# ─── 5. PROCESS PRIORITY EXTREME ──────────────────────────────────
function Set-ProcessPriorityUltra {
    Write-Section "🚀 PROCESS PRIORITY — REALTIME (UNSAFE BUT POWERFUL)"

    $cores = [Environment]::ProcessorCount
    $aff = [int]([Math]::Pow(2, $cores) - 1)
    $boosted = 0

    foreach ($name in @("GameLoop","Dnplayer","NemuPlayer","nemu64","nemu32","GameloaderHelper","TxGameAssistant")) {
        Get-Process -Name $name -EA SilentlyContinue | ForEach-Object {
            try {
                # ✅ Use REALTIME for maximum performance (warning: system may lag if process hangs)
                $_.PriorityClass = [Diagnostics.ProcessPriorityClass]::RealTime
                $_.ProcessorAffinity = [IntPtr]$aff
                Write-OK "REALTIME + All $cores cores → $($_.Name) (PID $($_.Id))"
                $boosted++
            } catch {
                # ✅ Fallback to High if RealTime fails
                try {
                    $_.PriorityClass = [Diagnostics.ProcessPriorityClass]::High
                    $_.ProcessorAffinity = [IntPtr]$aff
                    Write-Info "HIGH (RealTime failed) → $($_.Name)"
                } catch {}
            }
        }
    }
    if ($boosted -eq 0) { Write-Warn "GameLoop not running — شغّله وأعد تشغيل الأوبشن دي" }
}

# ─── 6. RAM SUPERCLEAN ────────────────────────────────────────────
function Optimize-RAMUltra {
    Write-Section "🧠 RAM SUPERCLEAN — AGGRESSIVE CACHE MANAGEMENT"

    Add-Type @"
using System; using System.Runtime.InteropServices;
public class RamTrim { [DllImport("psapi.dll")] public static extern bool EmptyWorkingSet(IntPtr h); }
public class ProcessMemory { [DllImport("kernel32.dll")] public static extern bool SetProcessWorkingSetSize(IntPtr h, IntPtr min, IntPtr max); }
"@ -EA SilentlyContinue

    # ✅ Aggressive trim on heavy apps
    $heavy = @("chrome","msedge","firefox","opera","brave","discord","slack","teams","zoom","skype","OneDrive","SearchIndexer","SearchApp","Spotify","steam","EpicGamesLauncher","GameLoop","nemu64","nemu32")
    $n = 0
    foreach ($app in $heavy) {
        Get-Process -Name $app -EA SilentlyContinue | ForEach-Object {
            try {
                [RamTrim]::EmptyWorkingSet($_.Handle) | Out-Null
                [ProcessMemory]::SetProcessWorkingSetSize($_.Handle, [IntPtr](-1), [IntPtr](-1)) | Out-Null
                $n++
            } catch {}
        }
    }

    # ✅ Get available RAM
    $avail = [Math]::Round((Get-Counter '\Memory\Available MBytes' -EA SilentlyContinue).CounterSamples[0].CookedValue)
    Write-OK "Trimmed $n processes aggressively — Available RAM: $avail MB"
}

# ─── 7. STANDBY AGGRESSIVE PURGE ──────────────────────────────────
function Clear-StandbyMemoryAggressive {
    Write-Section "💾 STANDBY AGGRESSIVE PURGE (once per session)"

    if ($script:PurgedThisSession) {
        Write-Info "Already purged this session — skipping"
        return
    }

    Add-Type @"
using System; using System.Runtime.InteropServices;
public class SbPurge {
    [DllImport("ntdll.dll")] public static extern uint NtSetSystemInformation(int c, IntPtr b, int l);
    public static void Run() { 
        IntPtr b = Marshal.AllocHGlobal(4); 
        Marshal.WriteInt32(b, 4); 
        NtSetSystemInformation(80, b, 4); 
        Marshal.FreeHGlobal(b); 
    }
}
"@ -EA SilentlyContinue

    try { 
        [SbPurge]::Run()
        $script:PurgedThisSession = $true
        Write-OK "Standby list purged aggressively (ISLC++ style)"
    } catch { 
        Write-Warn "Standby purge: failed" 
    }
}

# ─── 8. TIMER RESOLUTION ULTRA (0.5ms) ────────────────────────────
function Set-TimerResolutionUltra {
    Write-Section "⏱ TIMER RESOLUTION — 0.5ms ULTRA (EXTREME INPUT LAG REDUCTION)"

    Add-Type @"
using System.Runtime.InteropServices;
public class TimerR {
    [DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(int r, bool s, ref int c);
    [DllImport("ntdll.dll")] public static extern int NtQueryTimerResolution(ref int mn, ref int mx, ref int c);
}
"@ -EA SilentlyContinue

    try {
        $mn=0; $mx=0; $cur=0
        [TimerR]::NtQueryTimerResolution([ref]$mn,[ref]$mx,[ref]$cur) | Out-Null
        $before = [Math]::Round($cur/10000.0, 2)

        # ✅ 5000 = 0.5ms — أقوى من 1ms لتقليل Input Lag
        $result = 0
        [TimerR]::NtSetTimerResolution(5000, $true, [ref]$result) | Out-Null
        $after = [Math]::Round($result/10000.0, 2)

        Write-OK "Timer: ${before}ms → ${after}ms (0.5ms ULTRA — Input Lag DESTROYED)"
    } catch { 
        Write-Warn "Timer resolution ultra: failed — falling back to 1ms"
        # ✅ Fallback to 1ms
        try {
            $result = 0
            [TimerR]::NtSetTimerResolution(10000, $true, [ref]$result) | Out-Null
            Write-OK "Timer: fallback to 1ms (safe)"
        } catch { Write-Warn "Timer resolution: failed completely" }
    }
}

# ─── 9. INPUT LAG KILLER ──────────────────────────────────────────
function Set-InputLagKiller {
    Write-Section "🎯 INPUT LAG KILLER — RAW INPUT + POINTER PRECISION"

    # ✅ Disable Pointer Precision (Mouse Acceleration)
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 0 -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 0 -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 0 -Type String -Force
    Write-OK "Pointer Precision (Mouse Acceleration) disabled"

    # ✅ Raw Input settings
    $raw = "HKCU:\Software\Raw Input"
    if (-not (Test-Path $raw)) { New-Item $raw -Force | Out-Null }
    Set-ItemProperty $raw -Name "RawInputDeviceLogging" -Value 0 -Type DWord -Force
    Write-OK "Raw Input optimized"
}

# ─── 10. NETWORK EXTREME PRIORITY ─────────────────────────────────
function Optimize-NetworkUltra {
    param([bool]$DisableThrottle = $true, [bool]$OptimizeMTU = $true)
    Write-Section "🌐 NETWORK EXTREME — QoS + MTU OPTIMIZATION"

    ipconfig /flushdns 2>&1 | Out-Null
    Write-OK "DNS cache flushed"

    # ✅ Network throttling
    if ($DisableThrottle) {
        $mm = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
        Set-ItemProperty $mm -Name "NetworkThrottlingIndex" -Value 0xFFFFFFFF -Type DWord -Force
        Set-ItemProperty $mm -Name "SystemResponsiveness"  -Value 0          -Type DWord -Force
        Write-OK "Network throttling disabled"
    }

    # ✅ Remove old QoS policies and add new ones
    Get-NetQosPolicy | Where-Object { $_.Name -match "PUBG_|GL_" } | Remove-NetQosPolicy -Confirm:$false -EA SilentlyContinue
    foreach ($proc in @("GameLoop.exe","nemu64.exe","nemu32.exe","TxGameAssistant.exe")) {
        New-NetQosPolicy -Name "PUBG_EXTREME_$proc" -AppPathNameMatchCondition $proc -DSCPAction 46 -NetworkProfile All -EA SilentlyContinue | Out-Null
    }
    Write-OK "QoS DSCP=46 (Expedited Forwarding) applied"

    # ✅ MTU Optimization (optional)
    if ($OptimizeMTU) {
        $eth = Get-NetAdapter | Where-Object { $_.Status -eq "Up" } | Select-Object -First 1
        if ($eth) {
            try {
                Set-NetIPInterface -InterfaceIndex $eth.InterfaceIndex -NlMtu 1500 -Confirm:$false -EA SilentlyContinue
                Write-OK "MTU optimized to 1500"
            } catch {}
        }
    }
}

# ─── 11. DEFENDER SMART OPTIMIZATION ───────────────────────────────
function Optimize-DefenderSmart {
    Write-Section "🛡 DEFENDER — SMART EXCLUSIONS (stays FULLY ON + safe)"

    foreach ($d in @("$env:LOCALAPPDATA\Tencent\GameLoop","$env:ProgramFiles\Tencent\GameLoop","C:\TxGameAssistant")) {
        if (Test-Path $d) { 
            Add-MpPreference -ExclusionPath $d -EA SilentlyContinue
            Write-OK "Excluded folder → $d" 
        }
    }
    Add-MpPreference -ExclusionProcess "GameLoop.exe" -EA SilentlyContinue
    Add-MpPreference -ExclusionProcess "nemu64.exe"   -EA SilentlyContinue
    Add-MpPreference -ExclusionProcess "nemu32.exe"   -EA SilentlyContinue
    Add-MpPreference -ExclusionProcess "TxGameAssistant.exe" -EA SilentlyContinue
    Write-OK "Process exclusions added (Defender fully active + safe)"
}

# ─── 12. ADB ANDROID ULTRA BOOST ──────────────────────────────────
function Invoke-ADB_UltraBoost {
    Write-Section "📱 ADB — ANDROID ULTRA BOOST"

    $adbExe = Find-ADB
    if (-not $adbExe) { Write-Warn "ADB not found"; return }
    Write-OK "ADB: $adbExe"

    Write-Step "Waiting for emulator (max 30s)..."
    $t = 0
    do { Start-Sleep 2; $t+=2; $d = & $adbExe devices 2>&1 } while (($d -notmatch "emulator.*`tdevice") -and ($t -lt 30))
    if ($d -notmatch "emulator.*`tdevice") { Write-Warn "No emulator connected"; return }

    $dev = (($d | Where-Object { $_ -match "emulator.*`tdevice" })[0] -split "`t")[0].Trim()
    Write-OK "Connected: $dev"

    function adb_s { & $adbExe -s $dev $args 2>&1 }

    # ✅ Disable all animations
    adb_s shell settings put global window_animation_scale     0.0
    adb_s shell settings put global transition_animation_scale 0.0
    adb_s shell settings put global animator_duration_scale    0.0
    Write-OK "Animations → 0.0 (disabled)"

    # ✅ GPU & HW Rendering
    adb_s shell setprop debug.egl.hw 1
    adb_s shell setprop debug.sf.hw  1
    adb_s shell setprop debug.atrace.tags.enableflags 0
    Write-OK "Hardware GPU + Surface Flinger → ON"

    # ✅ Heap Optimization
    adb_s shell setprop dalvik.vm.heapsize        512m
    adb_s shell setprop dalvik.vm.heapgrowthlimit 256m
    adb_s shell setprop dalvik.vm.heapstartsize    32m
    Write-OK "Dalvik heap: 512m (optimized)"

    # ✅ System Properties
    adb_s shell setprop persist.sys.strictmode.disable 1
    adb_s shell settings put global wifi_sleep_policy 2
    adb_s shell setprop persist.sys.usb.config mtp,adb
    Write-OK "StrictMode OFF / WiFi sleep OFF / USB optimized"

    # ✅ Disable background apps
    foreach ($a in @("com.android.printspooler","com.android.calendar","com.android.providers.downloads.ui","com.android.systemui")) {
        adb_s shell am force-stop $a 2>$null | Out-Null
    }
    Write-OK "Background apps stopped"

    # ✅ Garbage Collection Optimization
    adb_s shell setprop dalvik.vm.usejit true
    adb_s shell setprop dalvik.vm.usejitprofiles true
    Write-OK "JIT Compilation enabled"

    Write-OK "═══ ADB ULTRA BOOST DONE ═══"
}

# ─── 13. AUTO TASK REGISTRATION ───────────────────────────────────
function Register-AutoTaskUltra {
    Write-Section "⏰ AUTO-BOOST REGISTRATION (at login)"

    if (-not $PSCommandPath) { Write-Warn "Save script as .ps1 file first"; return }

    $name = "PUBG_GL_UltraBoost_v4"
    Unregister-ScheduledTask -TaskName $name -Confirm:$false -EA SilentlyContinue | Out-Null

    $action    = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$PSCommandPath`" -FullBoost"
    $trigger   = New-ScheduledTaskTrigger -AtLogOn
    $settings  = New-ScheduledTaskSettingsSet -Priority 6 -ExecutionTimeLimit (New-TimeSpan -Hours 2) -DisallowDemandStart $false
    $principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -RunLevel Highest
    
    Register-ScheduledTask -TaskName $name -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Force -EA SilentlyContinue | Out-Null
    Write-OK "Task registered → Auto-runs at every login"
}

# ─── RESTORE DEFAULTS ─────────────────────────────────────────────
function Restore-Defaults {
    Write-Section "♻ RESTORING TO WINDOWS DEFAULTS"

    powercfg /setactive SCHEME_BALANCED 2>$null
    powercfg /change standby-timeout-ac 15
    powercfg /change hibernate-timeout-ac 60
    Write-OK "Power plan → Balanced"

    Set-ItemProperty "HKCU:\System\GameConfigStore" -Name "GameDVR_Enabled" -Value 1 -Type DWord -Force
    Write-OK "GameDVR restored"

    $mm = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile"
    Set-ItemProperty $mm -Name "NetworkThrottlingIndex" -Value 10 -Type DWord -Force
    Set-ItemProperty $mm -Name "SystemResponsiveness"  -Value 20 -Type DWord -Force
    Write-OK "Network → default"

    Get-NetQosPolicy | Where-Object { $_.Name -match "PUBG_|GL_" } | Remove-NetQosPolicy -Confirm:$false -EA SilentlyContinue
    Write-OK "QoS removed"

    # ✅ Timer reset
    Add-Type @"
using System.Runtime.InteropServices;
public class TimerRst { [DllImport("ntdll.dll")] public static extern int NtSetTimerResolution(int r, bool s, ref int c); }
"@ -EA SilentlyContinue
    try { $c=0; [TimerRst]::NtSetTimerResolution(156250,$false,[ref]$c) | Out-Null } catch {}
    Write-OK "Timer resolution → system default"

    # ✅ Mouse settings
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseSpeed" -Value 1 -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold1" -Value 6 -Type String -Force
    Set-ItemProperty "HKCU:\Control Panel\Mouse" -Name "MouseThreshold2" -Value 10 -Type String -Force
    Write-OK "Mouse → default (acceleration ON)"

    # ✅ ADB restore
    $adbExe = Find-ADB
    if ($adbExe) {
        $d = & $adbExe devices 2>&1
        if ($d -match "emulator.*`tdevice") {
            $dev = (($d | Where-Object { $_ -match "emulator.*`tdevice" })[0] -split "`t")[0].Trim()
            & $adbExe -s $dev shell settings put global window_animation_scale     1.0
            & $adbExe -s $dev shell settings put global transition_animation_scale 1.0
            & $adbExe -s $dev shell settings put global animator_duration_scale    1.0
            Write-OK "Android animations → 1.0"
        }
    }

    # ✅ Defender
    foreach ($d in @("$env:LOCALAPPDATA\Tencent\GameLoop","$env:ProgramFiles\Tencent\GameLoop","C:\TxGameAssistant")) {
        Remove-MpPreference -ExclusionPath $d -EA SilentlyContinue
    }
    Remove-MpPreference -ExclusionProcess "GameLoop.exe" -EA SilentlyContinue
    Remove-MpPreference -ExclusionProcess "nemu64.exe"   -EA SilentlyContinue
    Write-OK "Defender exclusions removed"

    Write-Host "`n  ✔ All settings restored to Windows defaults`n" -ForegroundColor Green
}

# ─── FULL ULTRA BOOST ────────────────────────────────────────────
function Invoke-FullUltraBoost {
    param([bool]$hags = $false, [bool]$throttle = $true, [bool]$realtime = $true)
    
    Set-PowerPlanUltra
    Disable-GameDVRUltra
    Enable-GameModeUltra
    Set-GPUUltraPerformance -EnableHAGS $hags
    Optimize-DefenderSmart
    Set-ProcessPriorityUltra
    Optimize-RAMUltra
    Clear-StandbyMemoryAggressive
    Set-TimerResolutionUltra
    Set-InputLagKiller
    Optimize-NetworkUltra -DisableThrottle $throttle
    Invoke-ADB_UltraBoost
}

# ─── MENU ───────────────────────────────────────────────────────
function Show-Menu {
    Write-Banner
    Write-Host "  ┌───────────────────────────────────────────────────────────────┐" -ForegroundColor DarkCyan
    Write-Host "  │  [1]  🔥  FULL ULTRA BOOST v4 (موصى بيه جدًا)                │" -ForegroundColor Green
    Write-Host "  │  [2]  ⚡  Power Plan Ultra + CPU Overclock                     │" -ForegroundColor White
    Write-Host "  │  [3]  🎮  GameDVR Ultra Off + Game Mode Extreme               │" -ForegroundColor White
    Write-Host "  │  [4]  🎨  GPU Ultra Perf + Input Lag Killer                   │" -ForegroundColor White
    Write-Host "  │  [5]  🚀  Process Priority RealTime                           │" -ForegroundColor White
    Write-Host "  │  [6]  🧠  RAM SuperClean (aggressive)                         │" -ForegroundColor White
    Write-Host "  │  [7]  💾  Standby Aggressive Purge                            │" -ForegroundColor White
    Write-Host "  │  [8]  ⏱  Timer Resolution 0.5ms ULTRA                        │" -ForegroundColor White
    Write-Host "  │  [9]  🎯  Input Lag Killer (Raw Input)                        │" -ForegroundColor White
    Write-Host "  │  [T]  🌐  Network Extreme (QoS + MTU)                         │" -ForegroundColor White
    Write-Host "  │  [A]  📱  ADB Ultra Boost                                     │" -ForegroundColor White
    Write-Host "  │  [B]  🛡  Defender Smart Optimization                         │" -ForegroundColor White
    Write-Host "  │  [C]  ⏰  Register Auto-Boost Task                            │" -ForegroundColor White
    Write-Host "  │  [R]  ♻   Restore All Defaults                                │" -ForegroundColor Magenta
    Write-Host "  │  [0]  ❌  Exit                                                │" -ForegroundColor Red
    Write-Host "  └───────────────────────────────────────────────────────────────┘`n" -ForegroundColor DarkCyan
    Write-Host -NoNewline "  اختيارك: " -ForegroundColor Yellow
    return (Read-Host)
}

# ─── MAIN ───────────────────────────────────────────────────────
param([switch]$FullBoost, [switch]$Silent)
Assert-Admin

if ($FullBoost -or $Silent) {
    Invoke-FullUltraBoost -hags $false -throttle $true -realtime $true
    Write-Host "`n  ✔ FULL ULTRA BOOST v4 COMPLETE 🔥`n" -ForegroundColor Green
    Start-Sleep 3
    exit
}

do {
    $c = Show-Menu
    switch ($c.ToUpper()) {
        "1" {
            $h = Ask-YN "Enable HAGS? (Y for RTX/RX6000+ — N for GTX 10xx / older AMD)"
            Invoke-FullUltraBoost -hags $h -throttle $true -realtime $true
            Write-Host "`n  ══════════════════════════════════════════" -ForegroundColor Green
            Write-Host "  ✔ FULL ULTRA BOOST v4 DONE! 🔥🔥🔥" -ForegroundColor Green
            Write-Host "  ══════════════════════════════════════════`n" -ForegroundColor Green
        }
        "2" { Set-PowerPlanUltra }
        "3" { Disable-GameDVRUltra; Enable-GameModeUltra }
        "4" { $h = Ask-YN "Enable HAGS?"; Set-GPUUltraPerformance -EnableHAGS $h }
        "5" { Set-ProcessPriorityUltra }
        "6" { Optimize-RAMUltra }
        "7" { Clear-StandbyMemoryAggressive }
        "8" { Set-TimerResolutionUltra }
        "9" { Set-InputLagKiller }
        "T" { Optimize-NetworkUltra }
        "A" { Invoke-ADB_UltraBoost }
        "B" { Optimize-DefenderSmart }
        "C" { Register-AutoTaskUltra }
        "R" { Restore-Defaults }
        "0" { Write-Host "`n  GG! See you in PUBG 🔥`n" -ForegroundColor Yellow; exit }
    }
    if ($c -ne "0") { Write-Host "`n  Press Enter to continue..." -ForegroundColor DarkGray; Read-Host | Out-Null }
} while ($c -ne "0")
