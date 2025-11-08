#!/usr/bin/env python3
import psycopg2
import sys

# Railway PostgreSQL
DB_CONFIG = {
    'host': 'switchyard.proxy.rlwy.net',
    'port': 33707,
    'user': 'postgres',
    'password': 'fzxOiBSFhSVzABvXQTYUplJbrlwyEBUh',
    'database': 'railway'
}

# Kullanici secin (degistirin!)
USERNAME = "1canli"  # veya "zohan"

full_user_id = f"@{USERNAME}:cravex1-production.up.railway.app"

print(f"\nMaking {USERNAME} admin...\n")

try:
    conn = psycopg2.connect(**DB_CONFIG)
    cur = conn.cursor()
    
    # Make admin
    cur.execute("UPDATE users SET admin = 1 WHERE name = %s;", (full_user_id,))
    conn.commit()
    
    # Verify
    cur.execute("SELECT name, admin FROM users WHERE name = %s;", (full_user_id,))
    user = cur.fetchone()
    
    if user and user[1] == 1:
        print("=" * 80)
        print("SUCCESS! User is now ADMIN!")
        print("=" * 80)
        print()
        print(f"User: {full_user_id}")
        print(f"Admin: YES")
        print()
        print("Login to Synapse Admin:")
        print("URL: https://cravex-admin.netlify.app")
        print("Homeserver: https://cravex1-production.up.railway.app")
        print(f"Username: {USERNAME}")
        print("Password: [Your Element Web password]")
        print()
    else:
        print("ERROR: Could not verify admin status")
    
    cur.close()
    conn.close()
    
except Exception as e:
    print(f"ERROR: {e}")
    import traceback
    traceback.print_exc()




