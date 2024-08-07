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

- Give user permissions for deployments:
  `sudo sudo chown -R agala: /var/www/static /var/www/apps`
  This command gives the user access to the deployment folders so scp file upload is posible

## 3. Configure SSH Access

- Switch to the New User:
  `su - newusername`
- Create SSH Directory and Authorized Keys:
  ```bash
  mkdir -p ~/.ssh
  chmod 700 ~/.ssh
  touch ~/.ssh/authorized_keys
  chmod 600 ~/.ssh/authorized_keys
  ```
- Add Your Public Key to authorized_keys:
  - Open authorized_keys in an editor:
    `vim ~/.ssh/authorized_keys`
  - Paste your SSH public key into the file

## 4. Configure SSH Access for New User

Ensure the new user can log in via SSH:

- Edit the SSH Configuration File (/etc/ssh/sshd_config):
  `sudo vim /etc/ssh/sshd_config`
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

## 6. Add Nginx user to new user group (Optional)

If we're trying to provide static content with nginx and the folder with it is inside another user folder (/home/user), you may need to provide the nginx
user with read access to that folder.

- Locate the user folder where the static content is located.
- Give access to the nginx user to all the users folders
```bash
gpasswd -a www-data username
```
- Restart nginx
```bash
sudo systemctl restart nginx
```

## 6. Add user to Docker group (to execute docker commands)

```bash
sudo usermod -aG docker agala
```
