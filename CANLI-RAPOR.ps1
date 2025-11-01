# =============================================
# CANLI MESAJ RAPORU - SIFRE KORUMALI
# =============================================

param(
    [int]$IntervalSeconds = 30
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CANLI MESAJ RAPORU" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Guncelleme: Her $IntervalSeconds saniye" -ForegroundColor Yellow
Write-Host "Sifre: Admin@2024!Guclu" -ForegroundColor Yellow
Write-Host ""

$reportFile = "exports\live-report.html"
$iteration = 0

# Export klasoru olustur
if (!(Test-Path "exports")) {
    New-Item -ItemType Directory -Path "exports" | Out-Null
}

while ($true) {
    $iteration++
    $updateTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    
    Write-Host "[$updateTime] Guncelleme #$iteration" -ForegroundColor Cyan
    
    # Mesajlari cek
    $sql = @"
SELECT 
    to_timestamp(e.origin_server_ts/1000) as timestamp,
    e.sender,
    e.room_id,
    ej.json::json->'content'->>'body' as message
FROM events e
JOIN event_json ej ON e.event_id = ej.event_id
WHERE e.type = 'm.room.message'
ORDER BY e.origin_server_ts DESC
LIMIT 100;
"@
    
    try {
        $result = docker exec matrix-postgres psql -U synapse_user -d synapse -t -A -F "|" -c $sql 2>$null
        
        $messages = @()
        foreach ($line in $result) {
            if ($line -match '^([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)') {
                $messages += [PSCustomObject]@{
                    Timestamp = $matches[1].Trim()
                    Sender = $matches[2].Trim()
                    RoomId = $matches[3].Trim()
                    Message = $matches[4].Trim()
                }
            }
        }
        
        $uniqueSenders = ($messages | Select-Object -ExpandProperty Sender -Unique).Count
        $uniqueRooms = ($messages | Select-Object -ExpandProperty RoomId -Unique).Count
        
        # HTML olustur
        $html = @"
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="$IntervalSeconds">
    <title>Matrix Admin - Canli Rapor</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Segoe UI', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        #loginScreen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        .login-box {
            background: white;
            padding: 50px;
            border-radius: 15px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.3);
            text-align: center;
            min-width: 400px;
        }
        .login-box h2 { color: #333; margin: 20px 0; font-size: 24px; }
        .login-box p { color: #666; margin-bottom: 30px; }
        .login-box input {
            width: 100%;
            padding: 15px;
            border: 2px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            margin-bottom: 20px;
        }
        .login-box input:focus {
            outline: none;
            border-color: #667eea;
        }
        .login-box button {
            width: 100%;
            padding: 15px;
            background: #667eea;
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }
        .login-box button:hover { background: #5568d3; }
        .error-msg {
            color: #f44336;
            margin-top: 15px;
            display: none;
            font-weight: bold;
        }
        #mainContent { display: none; }
        .container { max-width: 1400px; margin: 0 auto; }
        .header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .header h1 { color: #333; margin-bottom: 10px; }
        .header p { color: #666; }
        .live-dot {
            display: inline-block;
            width: 12px;
            height: 12px;
            background: #4CAF50;
            border-radius: 50%;
            animation: pulse 1.5s infinite;
            margin-right: 10px;
        }
        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.3; }
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card h3 { color: #666; font-size: 14px; margin-bottom: 10px; }
        .stat-card .value { font-size: 36px; font-weight: bold; color: #667eea; }
        .messages {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .messages h2 { color: #333; margin-bottom: 15px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        thead { background: #667eea; color: white; }
        th { padding: 12px; text-align: left; font-weight: 600; }
        td { padding: 12px; border-bottom: 1px solid #f0f0f0; }
        tr:hover { background: #f8f9fa; }
        .sender { color: #2196F3; font-weight: bold; }
        .timestamp { color: #999; font-size: 12px; }
        .room { color: #FF9800; font-size: 11px; }
    </style>
</head>
<body>
    <div id="loginScreen">
        <div class="login-box">
            <div style="font-size: 72px; margin-bottom: 20px;">&#128274;</div>
            <h2>Admin Girisi</h2>
            <p>Mesaj raporunu goruntuleme yetkiniz gerekli</p>
            <input type="password" id="passInput" placeholder="Admin Sifresi" onkeypress="if(event.key==='Enter') login()">
            <button onclick="login()">Giris Yap</button>
            <div class="error-msg" id="errMsg">Yanlis sifre!</div>
        </div>
    </div>
    
    <div id="mainContent">
        <div class="container">
            <div class="header">
                <h1><span class="live-dot"></span>Matrix Canli Mesaj Raporu</h1>
                <p>Otomatik guncelleme: Her $IntervalSeconds saniye | Son: <strong>$updateTime</strong></p>
            </div>
            
            <div class="stats">
                <div class="stat-card">
                    <h3>Toplam Mesaj</h3>
                    <div class="value">$($messages.Count)</div>
                </div>
                <div class="stat-card">
                    <h3>Kullanici</h3>
                    <div class="value">$uniqueSenders</div>
                </div>
                <div class="stat-card">
                    <h3>Oda</h3>
                    <div class="value">$uniqueRooms</div>
                </div>
                <div class="stat-card">
                    <h3>Guncelleme</h3>
                    <div class="value" style="font-size: 24px;">#$iteration</div>
                </div>
            </div>
            
            <div class="messages">
                <h2>Son 100 Mesaj</h2>
                <table>
                    <thead>
                        <tr>
                            <th>Tarih/Saat</th>
                            <th>Gonderen</th>
                            <th>Oda ID</th>
                            <th>Mesaj</th>
                        </tr>
                    </thead>
                    <tbody>
"@
        
        foreach ($msg in $messages) {
            $html += @"
                        <tr>
                            <td class="timestamp">$($msg.Timestamp)</td>
                            <td class="sender">$($msg.Sender)</td>
                            <td class="room">$($msg.RoomId)</td>
                            <td>$($msg.Message)</td>
                        </tr>
"@
        }
        
        $html += @"
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        const PASS = 'Admin@2024!Guclu';
        function login() {
            const input = document.getElementById('passInput').value;
            if (input === PASS) {
                document.getElementById('loginScreen').style.display = 'none';
                document.getElementById('mainContent').style.display = 'block';
                sessionStorage.setItem('auth', 'ok');
            } else {
                document.getElementById('errMsg').style.display = 'block';
                document.getElementById('passInput').value = '';
            }
        }
        window.onload = function() {
            if (sessionStorage.getItem('auth') === 'ok') {
                document.getElementById('loginScreen').style.display = 'none';
                document.getElementById('mainContent').style.display = 'block';
            } else {
                document.getElementById('passInput').focus();
            }
        };
    </script>
</body>
</html>
"@
        
        $html | Out-File -FilePath $reportFile -Encoding UTF8
        
        Write-Host "              OK Guncellendi ($($messages.Count) mesaj)" -ForegroundColor Green
        
        if ($iteration -eq 1) {
            Start-Process $reportFile
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "  TARAYICIDA ACILDI!" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "Sifre: Admin@2024!Guclu" -ForegroundColor Yellow
            Write-Host "Her $IntervalSeconds saniyede guncellenir" -ForegroundColor Cyan
            Write-Host ""
        }
        
    } catch {
        Write-Host "              HATA: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds $IntervalSeconds
}
