-- =============================================
-- CRAVEX MATRIX SUNUCUSU TEMİZLİK SCRIPTI (DÜZELTİLMİŞ)
-- =============================================
-- Bu script zohan ve admin kullanıcıları HARİÇ
-- tüm kullanıcıları, odaları ve mesajları siler.
-- =============================================
-- NOT: Synapse'de user_id kolonu yerine 'name' kolonu kullanılır!
-- =============================================

-- ADIM 1: Silinecek kullanıcıları listele (ÖNCE KONTROL ET!)
-- =============================================
SELECT 
    name as "Silinecek Kullanıcılar",
    displayname as "İsim",
    admin as "Admin mi?"
FROM users 
WHERE name NOT LIKE '%zohan%' 
  AND name NOT LIKE '%admin%'
ORDER BY name;

-- ADIM 2: Kaç oda silinecek? (KONTROL ET!)
-- =============================================
SELECT COUNT(DISTINCT room_id) as "Silinecek Oda Sayısı"
FROM rooms;

-- =============================================
-- YUKARIDAKI SORGULARI ÇALIŞTIR VE KONTROL ET!
-- EĞER DOĞRUYSA, AŞAĞIDAKİ SİLME KOMUTLARINI ÇALIŞTIR
-- =============================================

-- =============================================
-- ADIM 3: KULLANICILARI SİL (zohan ve admin hariç)
-- =============================================

-- 3.1: Access tokens sil
DELETE FROM access_tokens 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 3.2: User directory sil
DELETE FROM user_directory 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 3.3: User directory search sil
DELETE FROM user_directory_search 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 3.4: Profiles sil
DELETE FROM profiles 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%'
  AND full_user_id NOT LIKE '%zohan%'
  AND full_user_id NOT LIKE '%admin%';

-- 3.5: Devices sil
DELETE FROM devices 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 3.6: Room memberships sil (zohan ve admin olmayan kullanıcıların)
DELETE FROM room_memberships 
WHERE user_id NOT LIKE '%zohan%' 
  AND user_id NOT LIKE '%admin%';

-- 3.7: Users tablosundan sil
DELETE FROM users 
WHERE name NOT LIKE '%zohan%' 
  AND name NOT LIKE '%admin%';


-- =============================================
-- ADIM 4: TÜM ODALARI SİL
-- =============================================
-- NOT: Zohan ve admin'in olduğu odalar da SİLİNECEK!
-- Eğer zohan/admin'in odalarını KORUMAK istiyorsan,
-- aşağıdaki bölümü ATLAYIP ADIM 5'e geç.

-- 4.1: Önce tüm oda ID'lerini al
CREATE TEMP TABLE all_rooms_to_delete AS
SELECT DISTINCT room_id FROM rooms;

-- 4.2: Events tablosundan mesajları sil
DELETE FROM events 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.3: Event_json tablosundan sil
DELETE FROM event_json 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.4: Room memberships sil
DELETE FROM room_memberships 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.5: State events sil
DELETE FROM state_events 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.6: Current state events sil
DELETE FROM current_state_events 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.7: Room stats sil
DELETE FROM room_stats_state 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

DELETE FROM room_stats_current 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.8: Rooms tablosundan sil
DELETE FROM rooms 
WHERE room_id IN (SELECT room_id FROM all_rooms_to_delete);

-- 4.9: Temp table temizle
DROP TABLE all_rooms_to_delete;


-- =============================================
-- ADIM 5 (OPSIYONEL): SADECE ZOHAN/ADMIN OLMAYAN ODALARI SİL
-- =============================================
-- Eğer zohan/admin'in üye olduğu odaları KORUMAK istiyorsan,
-- ADIM 4'ü ATLAYIP bu adımı kullan:

/*
-- 5.1: Zohan ve admin'in olmadığı odaları al
CREATE TEMP TABLE rooms_to_delete AS
SELECT DISTINCT room_id 
FROM rooms
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

-- 5.5: State events sil
DELETE FROM state_events 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.6: Current state events sil
DELETE FROM current_state_events 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.7: Room stats sil
DELETE FROM room_stats_state 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

DELETE FROM room_stats_current 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.8: Rooms tablosundan sil
DELETE FROM rooms 
WHERE room_id IN (SELECT room_id FROM rooms_to_delete);

-- 5.9: Temp table temizle
DROP TABLE rooms_to_delete;
*/


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
    name as "Korunan Kullanıcılar",
    displayname as "İsim",
    admin as "Admin?"
FROM users 
ORDER BY name;


