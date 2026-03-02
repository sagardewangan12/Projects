#!/bin/bash

echo "==============================="
echo "      User Management Menu     "
echo "==============================="
echo "1. Add User"
echo "2. Delete User"
echo "3. Add User to Group"
echo "4. List All Users"
echo "5. Exit"
echo "==============================="

read -p "Enter choice: " choice

case $choice in

  1)  read -p "Enter username: " user

      # Check if user already exists
      if id "$user" &>/dev/null; then
          echo "User '$user' already exists!"
      else
          useradd "$user"
          echo "User '$user' created successfully."
      fi
      ;;

  2)  read -p "Enter username: " user
      if id "$user" &>/dev/null; then
          userdel -r "$user"
          echo "User '$user' deleted."
      else
          echo "User '$user' does not exist."
      fi
      ;;

  3)  read -p "Enter username: " user
      read -p "Enter group: " grp
      if ! id "$user" &>/dev/null; then
          echo "User '$user' does not exist. Create user first."
      else
          # create group if not exists
          if ! getent group "$grp" >/dev/null; then
              groupadd "$grp"
              echo "Group '$grp' created."
          fi
          usermod -aG "$grp" "$user"
          echo "Added '$user' to group '$grp'"
      fi
      ;;

  4)  echo "------ List of All Users ------"
      cut -d: -f1 /etc/passwd
      echo "--------------------------------"
      ;;

  5)  echo "Exiting..."
      exit
      ;;

  *)  echo "Invalid option, try again!"
      ;;

esac

