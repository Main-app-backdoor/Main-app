import os
import subprocess
import plistlib
from datetime import datetime

# Directory containing .mobileprovision files (relative to repo root)
PROVISION_DIR = "provision"

# Current date (hardcoded to April 06, 2025, for this example; adjust as needed)
CURRENT_DATE = datetime(2025, 4, 6)

def decode_mobileprovision(file_path, output_path):
    """Decode a .mobileprovision file into a .plist file using the security command."""
    try:
        subprocess.run(
            ["security", "cms", "-D", "-i", file_path, "-o", output_path],
            check=True,
            capture_output=True,
            text=True
        )
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error decoding {file_path}: {e.stderr}")
        return False

def check_expiry(file_path):
    """Check if a .mobileprovision file is expired."""
    temp_plist = f"{file_path}.plist"
    
    # Decode the .mobileprovision file
    if not decode_mobileprovision(file_path, temp_plist):
        print(f"{file_path}: Failed to decode")
        return
    
    # Parse the plist file
    try:
        with open(temp_plist, "rb") as f:
            plist_data = plistlib.load(f)
            expiration_date = plist_data.get("ExpirationDate")
            
            if not expiration_date:
                print(f"{file_path}: No expiration date found")
                return
            
            # Compare with current date
            is_expired = expiration_date < CURRENT_DATE
            status = "EXPIRED" if is_expired else "VALID"
            print(f"{file_path}: {status} (Expires: {expiration_date})")
    
    except Exception as e:
        print(f"{file_path}: Error processing - {str(e)}")
    
    finally:
        # Clean up temporary plist file
        if os.path.exists(temp_plist):
            os.remove(temp_plist)

def main():
    # Ensure the provision directory exists
    if not os.path.exists(PROVISION_DIR):
        print(f"Error: Directory '{PROVISION_DIR}' not found.")
        return
    
    # Process all .mobileprovision files
    for filename in os.listdir(PROVISION_DIR):
        if filename.endswith(".mobileprovision"):
            file_path = os.path.join(PROVISION_DIR, filename)
            check_expiry(file_path)

if __name__ == "__main__":
    main()