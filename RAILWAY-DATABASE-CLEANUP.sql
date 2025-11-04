-- =============================================
-- RAILWAY DATABASE FULL CLEANUP
-- =============================================
-- SADECE ADMIN KULLANICISI KALACAK
-- DİĞER HER ŞEY SİLİNECEK!
-- =============================================
-- UYARI: Bu script GERİ ALINAMAZ! Dikkatli kullanın!
-- =============================================

-- ADIM 0: MEVCUT DURUM KONTROLÜ (ÖNCE BU SORGUYU ÇALIŞTIRIN!)
-- =============================================

SELECT 
    '=== MEVCUT KULLANICILAR ===' as "Bilgi";

SELECT 
    name as "Kullanıcı",
    displayname as "İsim",
    admin as "Admin?",
    creation_ts as "Oluşturulma"
FROM users 
ORDER BY name;

SELECT 
    '=== MEVCUT ODALAR ===' as "Bilgi";

SELECT 
    COUNT(*) as "Toplam Oda Sayısı"
FROM rooms;

SELECT 
    '=== MEVCUT MESAJLAR ===' as "Bilgi";

SELECT 
    COUNT(*) as "Toplam Mesaj Sayısı"
FROM events 
WHERE type = 'm.room.message';

-- =============================================
-- YUKARIDAKI KONTROL SORGULARINI ÇALIŞTIR!
-- EĞER SONUÇLAR DOĞRUYSA, AŞAĞIDAKİ BLOĞU ÇALIŞTIR
-- =============================================

-- =============================================
-- ADIM 1: TÜM ODALARI SİL
-- =============================================

-- 1.1: Room memberships sil
DELETE FROM room_memberships;

-- 1.2: Room aliases sil
DELETE FROM room_aliases;

-- 1.3: Room stats sil
DELETE FROM room_stats_state;
DELETE FROM room_stats_current;
DELETE FROM room_stats_historical;

-- 1.4: Room state sil
DELETE FROM current_state_events;
DELETE FROM state_events;

-- 1.5: Room events sil (TÜM MESAJLAR)
DELETE FROM events;
DELETE FROM event_json;

-- 1.6: Room topics sil
DELETE FROM topics;

-- 1.7: Rooms tablosunu temizle
DELETE FROM rooms;

-- =============================================
-- ADIM 2: ADMIN DIŞINDA TÜM KULLANICILARI SİL
-- =============================================

-- 2.1: Access tokens sil (admin hariç)
DELETE FROM access_tokens 
WHERE user_id NOT LIKE '%admin%';

-- 2.2: Refresh tokens sil
DELETE FROM refresh_tokens 
WHERE user_id NOT LIKE '%admin%';

-- 2.3: User directory sil
DELETE FROM user_directory 
WHERE user_id NOT LIKE '%admin%';

-- 2.4: User directory search sil
DELETE FROM user_directory_search 
WHERE user_id NOT LIKE '%admin%';

-- 2.5: Profiles sil
DELETE FROM profiles 
WHERE user_id NOT LIKE '%admin%';

-- 2.6: User filters sil
DELETE FROM user_filters 
WHERE user_id NOT LIKE '%admin%';

-- 2.7: Devices sil
DELETE FROM devices 
WHERE user_id NOT LIKE '%admin%';

-- 2.8: Pushers sil
DELETE FROM pushers 
WHERE user_id NOT LIKE '%admin%';

-- 2.9: Receipts sil
DELETE FROM receipts_linearized 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM receipts_graph 
WHERE user_id NOT LIKE '%admin%';

-- 2.10: User threepids sil (email, phone)
DELETE FROM user_threepids 
WHERE user_id NOT LIKE '%admin%';

-- 2.11: User stats sil
DELETE FROM user_stats_current 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM user_stats_historical 
WHERE user_id NOT LIKE '%admin%';

-- 2.12: Presence sil
DELETE FROM presence_list 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM presence_stream 
WHERE user_id NOT LIKE '%admin%';

-- 2.13: Account data sil
DELETE FROM account_data 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM room_account_data 
WHERE user_id NOT LIKE '%admin%';

-- 2.14: E2E encryption keys sil
DELETE FROM e2e_device_keys_json 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM e2e_one_time_keys_json 
WHERE user_id NOT LIKE '%admin%';

DELETE FROM e2e_cross_signing_keys 
WHERE user_id NOT LIKE '%admin%';

-- 2.15: User external IDs sil
DELETE FROM user_external_ids 
WHERE user_id NOT LIKE '%admin%';

-- 2.16: SON OLARAK: Users tablosundan sil
DELETE FROM users 
WHERE name NOT LIKE '%admin%';

-- =============================================
-- ADIM 3: ORPHAN KAYITLARI TEMİZLE
-- =============================================

-- 3.1: Media repository temizle
DELETE FROM local_media_repository;
DELETE FROM remote_media_cache;

-- 3.2: Redactions temizle
DELETE FROM redactions;

-- 3.3: Event relations temizle
DELETE FROM event_relations;

-- 3.4: Destinations temizle
DELETE FROM destinations;

-- 3.5: Event push actions temizle
DELETE FROM event_push_actions;
DELETE FROM event_push_summary;

-- =============================================
-- ADIM 4: VACUUM (Veritabanı Optimizasyonu)
-- =============================================

VACUUM FULL ANALYZE;

-- =============================================
-- ADIM 5: SON KONTROL
-- =============================================

SELECT 
    '=== TEMİZLİK SONRASI ===' as "Durum";

SELECT 
    name as "Kalan Kullanıcı",
    admin as "Admin?"
FROM users;

SELECT 
    'Toplam Oda: ' || COUNT(*) as "Durum"
FROM rooms;

SELECT 
    'Toplam Mesaj: ' || COUNT(*) as "Durum"
FROM events 
WHERE type = 'm.room.message';

-- =============================================
-- TAMAMLANDI! ✅
-- Sonuç: Sadece admin kullanıcısı kaldı
-- Tüm odalar, mesajlar, diğer kullanıcılar silindi
-- =============================================

