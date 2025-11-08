# =============================================
# MATRIX ADMIN DASHBOARD - PROFESYONEL
# =============================================
# Kurumsal admin paneli - Gerçek zamanlı
# =============================================

param(
    [int]$RefreshSeconds = 10  # Daha sık güncelleme
)

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  MATRIX ADMIN DASHBOARD" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Guncelleme: Her $RefreshSeconds saniye" -ForegroundColor Yellow
Write-Host "Port: HTML dosyasi (file://)" -ForegroundColor Yellow
Write-Host ""

$dashboardFile = "exports\admin-dashboard.html"
$iteration = 0

if (!(Test-Path "exports")) {
    New-Item -ItemType Directory -Path "exports" | Out-Null
}

while ($true) {
    $iteration++
    $updateTime = Get-Date -Format "dd.MM.yyyy HH:mm:ss"
    
    Write-Host "[$updateTime] Dashboard guncelleniyor... #$iteration" -ForegroundColor Cyan
    
    try {
        # TÜM MESAJLARI ÇEK (JSON formatında)
        $sqlMessages = @"
SELECT 
    to_timestamp(e.origin_server_ts/1000) as timestamp,
    e.sender,
    e.room_id,
    ej.json::json->'content'->>'body' as message,
    ej.json::json->'content'->>'msgtype' as msgtype
FROM events e
JOIN event_json ej ON e.event_id = ej.event_id
WHERE e.type = 'm.room.message'
ORDER BY e.origin_server_ts DESC
LIMIT 500;
"@
        
        # İSTATİSTİKLER
        $sqlStats = @"
SELECT 
    (SELECT COUNT(*) FROM events WHERE type = 'm.room.message') as total_messages,
    (SELECT COUNT(*) FROM rooms) as total_rooms,
    (SELECT COUNT(*) FROM users) as total_users,
    (SELECT COUNT(DISTINCT sender) FROM events WHERE type = 'm.room.message') as active_users,
    (SELECT COUNT(*) FROM events WHERE type = 'm.room.encrypted') as encrypted_count;
"@
        
        # Mesajları al
        $msgResult = docker exec matrix-postgres psql -U synapse_user -d synapse -t -A -F "|" -c $sqlMessages 2>$null
        
        $messages = @()
        foreach ($line in $msgResult) {
            if ($line -match '^([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)') {
                $messages += [PSCustomObject]@{
                    Timestamp = $matches[1].Trim()
                    Sender = $matches[2].Trim()
                    RoomId = $matches[3].Trim()
                    Message = $matches[4].Trim()
                    MsgType = $matches[5].Trim()
                }
            }
        }
        
        # İstatistikleri al
        $statsResult = docker exec matrix-postgres psql -U synapse_user -d synapse -t -A -F "|" -c $sqlStats 2>$null
        
        $stats = @{
            TotalMessages = 0
            TotalRooms = 0
            TotalUsers = 0
            ActiveUsers = 0
            EncryptedCount = 0
        }
        
        if ($statsResult -match '^([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)\|([^|]*)') {
            $stats.TotalMessages = $matches[1].Trim()
            $stats.TotalRooms = $matches[2].Trim()
            $stats.TotalUsers = $matches[3].Trim()
            $stats.ActiveUsers = $matches[4].Trim()
            $stats.EncryptedCount = $matches[5].Trim()
        }
        
        # Mesajları JSON'a çevir (JavaScript için)
        $messagesJson = $messages | ConvertTo-Json -Depth 5 -Compress
        $messagesJson = $messagesJson -replace "'", "\'"
        
        # HTML OLUŞTUR
        $html = @"
<!DOCTYPE html>
<html lang="tr">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="refresh" content="$RefreshSeconds">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Matrix Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            background: #0f172a;
            color: #e2e8f0;
            min-height: 100vh;
        }
        
        /* Login Screen */
        #loginScreen {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
        }
        
        .login-container {
            background: #1e293b;
            padding: 50px;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.5);
            border: 1px solid #334155;
            text-align: center;
            min-width: 450px;
        }
        
        .login-container .logo {
            font-size: 80px;
            margin-bottom: 20px;
            filter: drop-shadow(0 0 20px rgba(99, 102, 241, 0.5));
        }
        
        .login-container h1 {
            color: #f1f5f9;
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 10px;
        }
        
        .login-container p {
            color: #94a3b8;
            margin-bottom: 40px;
            font-size: 14px;
        }
        
        .login-container input {
            width: 100%;
            padding: 16px 20px;
            background: #0f172a;
            border: 2px solid #334155;
            border-radius: 12px;
            color: #e2e8f0;
            font-size: 16px;
            transition: all 0.3s;
            margin-bottom: 20px;
        }
        
        .login-container input:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        
        .login-container button {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            border: none;
            border-radius: 12px;
            color: white;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
        }
        
        .login-container button:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 30px rgba(99, 102, 241, 0.4);
        }
        
        .error-msg {
            color: #ef4444;
            margin-top: 20px;
            display: none;
            font-weight: 500;
        }
        
        /* Main Dashboard */
        #mainContent {
            display: none;
            min-height: 100vh;
        }
        
        .header {
            background: linear-gradient(135deg, #1e293b 0%, #0f172a 100%);
            padding: 30px 40px;
            border-bottom: 1px solid #334155;
            position: sticky;
            top: 0;
            z-index: 100;
            backdrop-filter: blur(10px);
        }
        
        .header-content {
            max-width: 1600px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header h1 {
            font-size: 28px;
            font-weight: 700;
            color: #f1f5f9;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .live-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(34, 197, 94, 0.1);
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            color: #22c55e;
            border: 1px solid rgba(34, 197, 94, 0.2);
        }
        
        .live-dot {
            width: 8px;
            height: 8px;
            background: #22c55e;
            border-radius: 50%;
            animation: pulse 2s infinite;
        }
        
        @keyframes pulse {
            0%, 100% { opacity: 1; box-shadow: 0 0 0 0 rgba(34, 197, 94, 0.7); }
            50% { opacity: 0.7; box-shadow: 0 0 0 10px rgba(34, 197, 94, 0); }
        }
        
        .update-time {
            font-size: 13px;
            color: #94a3b8;
            font-weight: 500;
        }
        
        .container {
            max-width: 1600px;
            margin: 0 auto;
            padding: 30px 40px;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: #1e293b;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid #334155;
            transition: all 0.3s;
        }
        
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            border-color: #6366f1;
        }
        
        .stat-card h3 {
            color: #94a3b8;
            font-size: 13px;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 12px;
        }
        
        .stat-card .value {
            font-size: 42px;
            font-weight: 700;
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }
        
        .stat-card .label {
            color: #64748b;
            font-size: 12px;
            margin-top: 8px;
        }
        
        /* Filters */
        .filters-card {
            background: #1e293b;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid #334155;
            margin-bottom: 30px;
        }
        
        .filters-card h2 {
            color: #f1f5f9;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .filters-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .filter-group label {
            display: block;
            color: #94a3b8;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .filter-group input,
        .filter-group select {
            width: 100%;
            padding: 12px 16px;
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 10px;
            color: #e2e8f0;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .filter-group input:focus,
        .filter-group select:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        
        .filter-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }
        
        button {
            padding: 12px 24px;
            border: none;
            border-radius: 10px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-primary {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
            color: white;
        }
        
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(99, 102, 241, 0.4);
        }
        
        .btn-success {
            background: #22c55e;
            color: white;
        }
        
        .btn-success:hover {
            background: #16a34a;
        }
        
        .btn-warning {
            background: #f59e0b;
            color: white;
        }
        
        .btn-secondary {
            background: #334155;
            color: #e2e8f0;
        }
        
        /* Messages Table */
        .messages-card {
            background: #1e293b;
            padding: 25px;
            border-radius: 16px;
            border: 1px solid #334155;
        }
        
        .messages-card h2 {
            color: #f1f5f9;
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        
        .search-box {
            padding: 12px 20px;
            background: #0f172a;
            border: 1px solid #334155;
            border-radius: 10px;
            color: #e2e8f0;
            font-size: 14px;
            width: 100%;
            margin-bottom: 20px;
            transition: all 0.3s;
        }
        
        .search-box:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
        }
        
        .table-container {
            overflow-x: auto;
            border-radius: 12px;
            border: 1px solid #334155;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: #0f172a;
        }
        
        thead {
            background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%);
        }
        
        th {
            padding: 16px;
            text-align: left;
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            color: white;
        }
        
        td {
            padding: 16px;
            border-bottom: 1px solid #1e293b;
            font-size: 14px;
        }
        
        tbody tr {
            transition: all 0.2s;
        }
        
        tbody tr:hover {
            background: #1e293b;
        }
        
        .sender {
            color: #60a5fa;
            font-weight: 600;
        }
        
        .timestamp {
            color: #94a3b8;
            font-size: 12px;
            font-family: 'Courier New', monospace;
        }
        
        .room-id {
            color: #f59e0b;
            font-size: 11px;
            font-family: 'Courier New', monospace;
        }
        
        .message-text {
            color: #e2e8f0;
            max-width: 400px;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .no-data {
            text-align: center;
            padding: 60px;
            color: #64748b;
        }
        
        .badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 600;
        }
        
        .badge-success {
            background: rgba(34, 197, 94, 0.1);
            color: #22c55e;
            border: 1px solid rgba(34, 197, 94, 0.2);
        }
        
        .badge-info {
            background: rgba(59, 130, 246, 0.1);
            color: #3b82f6;
            border: 1px solid rgba(59, 130, 246, 0.2);
        }
        
        .pagination {
            display: flex;
            gap: 10px;
            justify-content: center;
            margin-top: 20px;
        }
        
        .pagination button {
            padding: 8px 16px;
            background: #334155;
            color: #e2e8f0;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 13px;
        }
        
        .pagination button:hover {
            background: #475569;
        }
        
        .pagination button.active {
            background: #6366f1;
        }
        
        .result-info {
            color: #94a3b8;
            font-size: 13px;
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <!-- Login Screen -->
    <div id="loginScreen">
        <div class="login-container">
            <div class="logo">&#128274;</div>
            <h1>Matrix Admin Dashboard</h1>
            <p>Yetkili giris gerekli</p>
            <input type="password" id="passInput" placeholder="Admin Sifresi" 
                   onkeypress="if(event.key==='Enter') login()" autocomplete="off">
            <button class="btn-primary" onclick="login()" style="width: 100%;">
                Giris Yap
            </button>
            <div class="error-msg" id="errMsg">Yanlis sifre. Tekrar deneyin.</div>
        </div>
    </div>
    
    <!-- Main Dashboard -->
    <div id="mainContent">
        <!-- Header -->
        <div class="header">
            <div class="header-content">
                <div>
                    <h1>Matrix Admin Dashboard</h1>
                    <div class="update-time">Son guncelleme: $updateTime</div>
                </div>
                <div class="live-badge">
                    <span class="live-dot"></span>
                    CANLI - Her ${RefreshSeconds}s
                </div>
            </div>
        </div>
        
        <div class="container">
            <!-- Stats -->
            <div class="stats-grid">
                <div class="stat-card">
                    <h3>Toplam Mesaj</h3>
                    <div class="value">$($stats.TotalMessages)</div>
                    <div class="label">Sifresiz mesajlar</div>
                </div>
                <div class="stat-card">
                    <h3>Toplam Oda</h3>
                    <div class="value">$($stats.TotalRooms)</div>
                    <div class="label">Aktif odalar</div>
                </div>
                <div class="stat-card">
                    <h3>Kullanicilar</h3>
                    <div class="value">$($stats.TotalUsers)</div>
                    <div class="label">Kayitli kullanici</div>
                </div>
                <div class="stat-card">
                    <h3>Aktif Kullanici</h3>
                    <div class="value">$($stats.ActiveUsers)</div>
                    <div class="label">Mesaj gonderen</div>
                </div>
                <div class="stat-card">
                    <h3>Guncelleme</h3>
                    <div class="value" style="font-size: 28px;">#$iteration</div>
                    <div class="label">Otomatik refresh</div>
                </div>
            </div>
            
            <!-- Filters -->
            <div class="filters-card">
                <h2>&#128269; Filtreler ve Arama</h2>
                <div class="filters-grid">
                    <div class="filter-group">
                        <label>Oda ID</label>
                        <input type="text" id="filterRoom" placeholder="!abc:localhost" onkeyup="applyFilters()">
                    </div>
                    <div class="filter-group">
                        <label>Kullanici</label>
                        <input type="text" id="filterSender" placeholder="@user:localhost" onkeyup="applyFilters()">
                    </div>
                    <div class="filter-group">
                        <label>Tarih (Baslangic)</label>
                        <input type="datetime-local" id="filterStartDate" onchange="applyFilters()">
                    </div>
                    <div class="filter-group">
                        <label>Tarih (Bitis)</label>
                        <input type="datetime-local" id="filterEndDate" onchange="applyFilters()">
                    </div>
                </div>
                <div class="filter-actions">
                    <button class="btn-primary" onclick="applyFilters()">&#128269; Filtrele</button>
                    <button class="btn-success" onclick="exportJSON()">&#128190; JSON Indir</button>
                    <button class="btn-success" onclick="exportCSV()">&#128203; CSV Indir</button>
                    <button class="btn-secondary" onclick="clearFilters()">&#128260; Temizle</button>
                </div>
            </div>
            
            <!-- Messages -->
            <div class="messages-card">
                <h2>
                    <span>&#128172; Mesajlar</span>
                    <span class="badge badge-success" id="resultCount">$($messages.Count) mesaj</span>
                </h2>
                
                <input type="text" class="search-box" id="searchBox" 
                       placeholder="Mesajlarda ara (gerçek zamanli)..." 
                       onkeyup="searchMessages()">
                
                <div class="result-info" id="resultInfo">
                    Toplam $($messages.Count) mesaj yuklendi. Filtreleme yapmak icin yukardaki alanlari kullanin.
                </div>
                
                <div class="table-container">
                    <table id="messagesTable">
                        <thead>
                            <tr>
                                <th style="width: 180px;">Tarih/Saat</th>
                                <th style="width: 200px;">Gonderen</th>
                                <th style="width: 250px;">Oda ID</th>
                                <th>Mesaj</th>
                            </tr>
                        </thead>
                        <tbody id="messagesBody">
                            <!-- JavaScript ile doldurulacak -->
                        </tbody>
                    </table>
                </div>
                
                <div class="pagination" id="pagination"></div>
            </div>
        </div>
    </div>
    
    <script>
        const ADMIN_PASS = 'Admin@2024!Guclu';
        let allMessages = $messagesJson;
        let filteredMessages = allMessages;
        let currentPage = 1;
        const messagesPerPage = 50;
        
        // Login
        function login() {
            const pass = document.getElementById('passInput').value;
            if (pass === ADMIN_PASS) {
                document.getElementById('loginScreen').style.display = 'none';
                document.getElementById('mainContent').style.display = 'block';
                sessionStorage.setItem('adminAuth', 'true');
                displayMessages();
            } else {
                document.getElementById('errMsg').style.display = 'block';
                document.getElementById('passInput').value = '';
            }
        }
        
        // Filtreleme
        function applyFilters() {
            const roomFilter = document.getElementById('filterRoom').value.toLowerCase();
            const senderFilter = document.getElementById('filterSender').value.toLowerCase();
            const startDate = document.getElementById('filterStartDate').value;
            const endDate = document.getElementById('filterEndDate').value;
            
            filteredMessages = allMessages.filter(msg => {
                let match = true;
                
                if (roomFilter && !msg.RoomId.toLowerCase().includes(roomFilter)) {
                    match = false;
                }
                if (senderFilter && !msg.Sender.toLowerCase().includes(senderFilter)) {
                    match = false;
                }
                if (startDate) {
                    const msgDate = new Date(msg.Timestamp);
                    const filterDate = new Date(startDate);
                    if (msgDate < filterDate) match = false;
                }
                if (endDate) {
                    const msgDate = new Date(msg.Timestamp);
                    const filterDate = new Date(endDate);
                    if (msgDate > filterDate) match = false;
                }
                
                return match;
            });
            
            currentPage = 1;
            displayMessages();
            updateResultInfo();
        }
        
        // Arama
        function searchMessages() {
            const query = document.getElementById('searchBox').value.toLowerCase();
            
            if (!query) {
                applyFilters();
                return;
            }
            
            filteredMessages = allMessages.filter(msg => {
                return msg.Message && msg.Message.toLowerCase().includes(query);
            });
            
            currentPage = 1;
            displayMessages();
            updateResultInfo();
        }
        
        // Mesajlari goruntule
        function displayMessages() {
            const start = (currentPage - 1) * messagesPerPage;
            const end = start + messagesPerPage;
            const pageMessages = filteredMessages.slice(start, end);
            
            const tbody = document.getElementById('messagesBody');
            tbody.innerHTML = '';
            
            if (pageMessages.length === 0) {
                tbody.innerHTML = '<tr><td colspan="4" class="no-data">Mesaj bulunamadi</td></tr>';
                return;
            }
            
            pageMessages.forEach(msg => {
                const row = tbody.insertRow();
                row.innerHTML = \`
                    <td class="timestamp">\${msg.Timestamp}</td>
                    <td class="sender">\${msg.Sender}</td>
                    <td class="room-id">\${msg.RoomId}</td>
                    <td class="message-text" title="\${msg.Message}">\${msg.Message || '-'}</td>
                \`;
            });
            
            updatePagination();
        }
        
        // Sayfalama
        function updatePagination() {
            const totalPages = Math.ceil(filteredMessages.length / messagesPerPage);
            const pagination = document.getElementById('pagination');
            pagination.innerHTML = '';
            
            if (totalPages <= 1) return;
            
            for (let i = 1; i <= Math.min(totalPages, 10); i++) {
                const btn = document.createElement('button');
                btn.textContent = i;
                btn.className = i === currentPage ? 'active' : '';
                btn.onclick = () => {
                    currentPage = i;
                    displayMessages();
                };
                pagination.appendChild(btn);
            }
        }
        
        // Sonuc bilgisi
        function updateResultInfo() {
            const info = document.getElementById('resultInfo');
            const count = document.getElementById('resultCount');
            info.textContent = \`\${filteredMessages.length} mesaj gosteriliyor (Toplam: \${allMessages.length})\`;
            count.textContent = \`\${filteredMessages.length} mesaj\`;
        }
        
        // Filtreleri temizle
        function clearFilters() {
            document.getElementById('filterRoom').value = '';
            document.getElementById('filterSender').value = '';
            document.getElementById('filterStartDate').value = '';
            document.getElementById('filterEndDate').value = '';
            document.getElementById('searchBox').value = '';
            applyFilters();
        }
        
        // Export
        function exportJSON() {
            const data = JSON.stringify(filteredMessages, null, 2);
            const blob = new Blob([data], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'messages_' + new Date().getTime() + '.json';
            a.click();
        }
        
        function exportCSV() {
            let csv = 'Timestamp,Sender,RoomId,Message\\n';
            filteredMessages.forEach(msg => {
                csv += \`"\${msg.Timestamp}","\${msg.Sender}","\${msg.RoomId}","\${msg.Message}"\\n\`;
            });
            const blob = new Blob([csv], { type: 'text/csv' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'messages_' + new Date().getTime() + '.csv';
            a.click();
        }
        
        // Sayfa yukleme
        window.onload = function() {
            if (sessionStorage.getItem('adminAuth') === 'true') {
                document.getElementById('loginScreen').style.display = 'none';
                document.getElementById('mainContent').style.display = 'block';
                displayMessages();
            } else {
                document.getElementById('passInput').focus();
            }
        };
    </script>
</body>
</html>
"@
        
        $html | Out-File -FilePath $dashboardFile -Encoding UTF8
        
        Write-Host "              OK - $($messages.Count) mesaj" -ForegroundColor Green
        
        if ($iteration -eq 1) {
            Start-Process $dashboardFile
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "  DASHBOARD ACILDI!" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "Sifre: Admin@2024!Guclu" -ForegroundColor Yellow
            Write-Host "Dosya: $dashboardFile" -ForegroundColor Gray
            Write-Host "Guncelleme: Her $RefreshSeconds saniye" -ForegroundColor Cyan
            Write-Host ""
        }
        
    } catch {
        Write-Host "              HATA: $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Start-Sleep -Seconds $RefreshSeconds
}





