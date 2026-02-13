# server-initializer

## Installation

```bash
export ADMIN_SSH_KEY='ssh-ed25519 AAAA...'
export DEPLOY_SSH_KEY='ssh-ed25519 AAAA...'
curl -fsSL https://raw.githubusercontent.com/elAgala/server-initializer/main/index.sh | bash -s <username>
```

Or remotely via SSH:

```bash
ssh root@<host> "ADMIN_SSH_KEY='ssh-ed25519 AAAA...' DEPLOY_SSH_KEY='ssh-ed25519 AAAA...' bash -c '\$(curl -fsSL https://raw.githubusercontent.com/elAgala/server-initializer/main/index.sh)' -- <username>"
```


## Included
- Server update
- User creation
- SSH key configuration (AllowUser, disable root login)
- 
