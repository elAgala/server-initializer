# Creating a new user on your Linux server and configuring it for administrative tasks

## 1. Create a New User

- Log in to Your Server as the root user or a user with sudo privileges.
- Add a New User:
  `sudo adduser newusername`
  Replace `newusername` with the desired username.
- Follow the prompts to set the user's password and provide additional information.

## 2. Grant Sudo Privileges (Optional)

If you need the new user to have administrative privileges, add the user to the sudo group:

- Add User to the Sudo Group:
  `sudo usermod -aG sudo newusername`
  This command adds the user to the sudo group, which grants administrative permissions.

## 3. Configure SSH Access

- Switch to the New User:
  `su - newusername`
- Create SSH Directory and Authorized Keys:
  `mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys`
- Add Your Public Key to authorized_keys:
  - Open authorized_keys in an editor:
    `vim ~/.ssh/authorized_keys`
  - Paste your SSH public key into the file

## 4. Configure SSH Access for New User

Ensure the new user can log in via SSH:

- Edit the SSH Configuration File (/etc/ssh/sshd_config):
  `sudo nano /etc/ssh/sshd_config`
- Verify or Add the Following Settings:
  `PermitRootLogin no
  AllowUsers newusername`
  `PermitRootLogin no` disables root login via SSH.
  `AllowUsers newusername` allows the new user to log in.
- Restart SSH Service:
  `sudo systemctl restart ssh`

## 5. Test SSH Access

- Log Out from the Root User or current session.
- Log In as the New User:
  `ssh newusername@your_server_ip`
- Verify that you can access the server with the new user.
