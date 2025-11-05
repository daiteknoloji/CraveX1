# Git Update - Manuel Komutlar (PowerShell)

## Railway'e Push Etmek İçin (CraveX1 Repo)

### Adım 1: Durumu Kontrol Et
```powershell
cd "C:\Users\Can Cakir\Desktop\www-backup"
git status
```

### Adım 2: Değişiklikleri Kaydet (Eğer varsa)
```powershell
# Working directory'deki değişiklikleri stash et
git stash save "Local changes before push"
```

### Adım 3: Remote'taki Değişiklikleri Çek
```powershell
# CraveX1 remote'undan değişiklikleri çek
git fetch cravex1
```

### Adım 4: Durumu Kontrol Et
```powershell
# Local ve remote arasındaki farkları gör
git log --oneline --graph --all -10
```

### Adım 5A: Force Push (Hızlı - Remote'taki değişiklikleri silebilir)
```powershell
# Force push yap (DİKKAT: Remote'taki commit'leri silebilir!)
git push cravex1 main --force
```

### Adım 5B: Merge Sonra Push (Güvenli - Önerilen)
```powershell
# Remote'taki değişiklikleri merge et
git pull cravex1 main --no-rebase

# Eğer conflict varsa çöz, sonra:
git add .
git commit -m "Merge remote changes"

# Push et
git push cravex1 main
```

### Adım 6: Kontrol Et
```powershell
# Push başarılı mı kontrol et
git log --oneline -5
git remote -v
```

## Hızlı Komut (Tek Satır)

### Force Push (En Hızlı):
```powershell
cd "C:\Users\Can Cakir\Desktop\www-backup"; git push cravex1 main --force
```

### Güvenli Push (Merge ile):
```powershell
cd "C:\Users\Can Cakir\Desktop\www-backup"; git pull cravex1 main --no-rebase; git push cravex1 main
```

## Railway Otomatik Deploy

Push yaptıktan sonra:
1. Railway Dashboard'a git: https://railway.app/dashboard
2. Servisleri kontrol et (otomatik deploy başlamalı)
3. Eğer başlamazsa, manuel "Redeploy" yap

## Notlar

- `--force` kullanmadan önce remote'taki değişiklikleri kontrol et
- Railway otomatik deploy için `cravex1` remote'una push yapmalısın
- Her push sonrası Railway loglarını kontrol et

