## Creating and Using SSH Keys

### Understanding SSH Keys
SSH keys provide a secure method for authenticating to remote servers. They consist of a public key and a private key. The public key is shared with the server, while the private key remains on your local machine.

### Generating an SSH Key Pair

To generate a new SSH key pair, open your terminal and run the following command:
```bash
ssh-keygen -t ed25519 -C "your_email@example.com"
```
Replace your_email@example.com with your actual email address.
You will be prompted to enter a passphrase for added security. It's recommended to use a strong passphrase. Store this passphrase as it will be one of our login methods.

The generated keys will be stored in the following files:

Private key: ~/.ssh/id_ed25519
Public key: ~/.ssh/id_ed25519.pub

### Adding Your Public Key to the Server

1. Copy the contents of the public key file:

2. On your server, log in as the user you created.

3. Create the .ssh directory: mkdir -p ~/.ssh

4. Create the authorized_key file:touch ~/.ssh/authorized_keys

5. Set permissions:
```bash
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
```
