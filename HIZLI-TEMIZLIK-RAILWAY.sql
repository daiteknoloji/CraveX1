-- =============================================
-- HIZLI TEMİZLİK - RAILWAY WEB CONSOLE İÇİN
-- =============================================
-- Bu komutları Railway Dashboard → Postgres → Data sekmesinden çalıştırın
-- =============================================

-- ÖNCE KONTROL: Admin kullanıcısını görün
SELECT name, displayname, admin FROM users WHERE name LIKE '%admin%';

-- =============================================
-- TEMİZLİK BAŞLIYOR
-- =============================================

-- 1. TÜM ODALARI SİL
DELETE FROM room_memberships;
DELETE FROM current_state_events;
DELETE FROM state_events;
DELETE FROM events;
DELETE FROM event_json;
DELETE FROM rooms;

-- 2. ADMIN DIŞINDA TÜM KULLANICILARI SİL
DELETE FROM access_tokens WHERE user_id NOT LIKE '%admin%';
DELETE FROM devices WHERE user_id NOT LIKE '%admin%';
DELETE FROM profiles WHERE user_id NOT LIKE '%admin%';
DELETE FROM user_directory WHERE user_id NOT LIKE '%admin%';
DELETE FROM users WHERE name NOT LIKE '%admin%';

-- 3. TEMİZLİK
VACUUM ANALYZE;

-- 4. KONTROL: Sadece admin kaldı mı?
SELECT name, displayname, admin FROM users;
SELECT COUNT(*) as "Toplam Oda" FROM rooms;
SELECT COUNT(*) as "Toplam Mesaj" FROM events;

-- =============================================
-- TAMAMLANDI! ✅
-- =============================================

