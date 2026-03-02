#!/bin/bash
# Linux User & Access Management Automation

USER_FILE="users.txt"
GROUP="developers"
DEFAULT_PASS="Password@123"
INACTIVE_DAYS=30

# Function: Create group if not exists
create_group() {
    if ! getent group "$GROUP" > /dev/null; then
        sudo groupadd "$GROUP"
        echo "✅ Group '$GROUP' created"
    else
        echo "ℹ️ Group '$GROUP' already exists"
    fi
}

# Function: Create user with default settings
create_user() {
    local USER=$1
    if id "$USER" &>/dev/null; then
        echo "⚠️ User $USER already exists, skipping"
    else
        sudo useradd -m -s /bin/bash -g "$GROUP" "$USER"
        echo "$USER:$DEFAULT_PASS" | sudo chpasswd
        sudo chage -d 0 "$USER"     # Force password reset on first login
        sudo usermod -f "$INACTIVE_DAYS" "$USER"  # Lock inactive after 30 days
        echo "✅ User $USER created and added to $GROUP"
    fi
}

# Main Execution
create_group

while read -r USER; do
    create_user "$USER"
done < "$USER_FILE"

echo "🎯 User management automation complete!"
