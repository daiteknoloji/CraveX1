-- =============================================
-- CRAVEX MATRIX SUNUCUSU TEMİZLİK SCRIPTI
-- =============================================
-- Bu script zohan ve admin kullanıcıları HARİÇ
-- tüm kullanıcıları, odaları ve mesajları siler.
-- =============================================

-- ADIM 1: Korunacak kullanıcıları belirle
-- =============================================
-- zohan ve admin ile başlayan tüm kullanıcılar korunacak

-- ADIM 2: Silinecek kullanıcıları listele (ÖNCE KONTROL ET!)
-- =============================================
SELECT 
    user_id as "Silinecek Kullanıcılar",
    displayname as "İsim"
FROM users 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%'
ORDER BY user_id;

-- ADIM 3: Silinecek odaları listele (ÖNCE KONTROL ET!)
-- =============================================
SELECT 
    room_id as "Silinecek Odalar",
    COUNT(*) as "Mesaj Sayısı"
FROM events 
WHERE room_id IN (
    SELECT DISTINCT room_id 
    FROM room_memberships 
    WHERE user_id NOT LIKE '%zohan%' 
      AND user_id NOT LIKE '%admin%'
)
GROUP BY room_id
ORDER BY room_id;

-- =============================================
-- YUKARIDAKI SORGULARI ÇALIŞTIR VE KONTROL ET!
-- EĞER DOĞRUYSA, AŞAĞIDAKİ SİLME KOMUTLARINI ÇALIŞTIR
-- =============================================

/*
-- ADIM 4: KULLANICILARI SİL (zohan ve admin hariç)
-- =============================================

-- 4.1: Access tokens sil
DELETE FROM access_tokens 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 4.2: User directory sil
DELETE FROM user_directory 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 4.3: User directory search sil
DELETE FROM user_directory_search 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 4.4: Profiles sil
DELETE FROM profiles 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%'
  AND full_user_id NOT LIKE '%zohan%'
  AND full_user_id NOT LIKE '%admin%';

-- 4.5: Devices sil
DELETE FROM devices 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 4.6: Room memberships sil (zohan ve admin olmayan kullanıcıların)
DELETE FROM room_memberships 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 4.7: Users tablosundan sil
DELETE FROM users 
WHERE name NOT LIKE '%zohan%' 
  AND name NOT LIKE '%admin%';


-- ADIM 5: ODALARI SİL
-- =============================================

-- 5.1: Önce silinecek oda ID'lerini al
CREATE TEMP TABLE rooms_to_delete AS
SELECT DISTINCT room_id 
FROM room_memberships 
WHERE room_id NOT IN (
    -- Zohan veya admin'in üye olduğu odalar HARİÇ
    SELECT DISTINCT room_id 
    FROM room_memberships 
    WHERE user_id LIKE '%zohan%' 
       OR user_id LIKE '%admin%'
);

-- 5.2: Events tablosundan mesajları sil
DELETE FROM events 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.3: Event_json tablosundan sil
DELETE FROM event_json 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.4: Room memberships sil
DELETE FROM room_memberships 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.5: Rooms tablosundan sil
DELETE FROM rooms 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.6: State events sil
DELETE FROM state_events 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.7: Current state events sil
DELETE FROM current_state_events 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.8: Room stats sil
DELETE FROM room_stats_state 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

DELETE FROM room_stats_current 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.9: Temp table temizle
DROP TABLE rooms_to_delete;


-- ADIM 6: MESAJ İSTATİSTİKLERİNİ SIFIRLA
-- =============================================

-- Event stream positions sıfırla (isteğe bağlı)
-- TRUNCATE event_push_actions_staging;
-- TRUNCATE event_push_summary;


-- =============================================
-- TEMİZLİK TAMAMLANDI!
-- =============================================
-- Şimdi kaç kullanıcı ve oda kaldı kontrol et:

SELECT 
    'KALAN KULLANICILAR' as "Tablo",
    COUNT(*) as "Sayı"
FROM users
UNION ALL
SELECT 
    'KALAN ODALAR' as "Tablo",
    COUNT(DISTINCT room_id) as "Sayı"
FROM rooms;

-- Kalan kullanıcıları göster:
SELECT 
    user_id as "Korunan Kullanıcılar",
    displayname as "İsim",
    admin as "Admin?"
FROM users 
ORDER BY user_id;

*/


