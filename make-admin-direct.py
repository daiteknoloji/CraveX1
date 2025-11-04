#!/usr/bin/env python3
"""
Make User Admin on Railway PostgreSQL
"""
import psycopg2
import sys

# Railway PostgreSQL connection
DB_CONFIG = {
    'host': 'switchyard.proxy.rlwy.net',
    'port': 33707,
    'user': 'postgres',
    'password': 'fzxOiBSFhSVzABvXQTYUplJbrlwyEBUh',
    'database': 'railway'
}

def main():
    print("\nChecking users in database...\n")
    
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        cur = conn.cursor()
        
        # List all users
        cur.execute("SELECT name, admin FROM users ORDER BY name;")
        users = cur.fetchall()
        
        if not users:
            print("No users found in database!")
            print("Create a user in Element Web first:")
            print("https://vcravex1.netlify.app")
            return
        
        print("EXISTING USERS:")
        print("=" * 80)
        for i, (name, is_admin) in enumerate(users, 1):
            admin_status = "[ADMIN]" if is_admin == 1 else "[User]"
            print(f"{i}. {name} - {admin_status}")
        print("=" * 80)
        print()
        
        # Ask which user to make admin
        username_input = input("Enter username to make ADMIN (without @:domain): ").strip()
        
        if not username_input:
            print("❌ No username provided!")
            return
        
        # Build full user ID
        full_user_id = f"@{username_input}:cravex1-production.up.railway.app"
        
        # Check if user exists
        cur.execute("SELECT name, admin FROM users WHERE name = %s;", (full_user_id,))
        user = cur.fetchone()
        
        if not user:
            print(f"User '{full_user_id}' not found!")
            print("Create this user in Element Web first.")
            return
        
        if user[1] == 1:
            print(f"User '{full_user_id}' is already admin!")
            return
        
        # Make admin
        print(f"\nMaking '{username_input}' admin...")
        cur.execute("UPDATE users SET admin = 1 WHERE name = %s;", (full_user_id,))
        conn.commit()
        
        print()
        print("=" * 80)
        print("SUCCESS! User is now ADMIN!")
        print("=" * 80)
        print()
        print("LOGIN CREDENTIALS:")
        print()
        print("  Synapse Admin Panel:")
        print("  URL: https://cravex-admin.netlify.app")
        print("  Homeserver: https://cravex1-production.up.railway.app")
        print(f"  Username: {username_input}")
        print("  Password: [Your Element Web password]")
        print()
        print("=" * 80)
        print()
        
        cur.close()
        conn.close()
        
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback
        traceback.print_exc()

if __name__ == '__main__':
    main()

