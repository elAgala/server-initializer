# server-initializer

## Installation

```bash
export ADMIN_SSH_KEY='ssh-ed25519 AAAA...'
export DEPLOY_SSH_KEY='ssh-ed25519 AAAA...'
curl -fsSL https://raw.githubusercontent.com/elAgala/server-initializer/main/index.sh | bash -s <username>
```

Or remotely via SSH:

```bash
ssh root@<host> \
  "export ADMIN_SSH_KEY='ssh-ed25519 AAAA...' && \
   export DEPLOY_SSH_KEY='ssh-ed25519 AAAA...' && \
   curl -fsSL https://raw.githubusercontent.com/elAgala/server-initializer/main/index.sh | bash -s -- <username>"
```


## Included
- Server update
- User creation (admin + deploy)
- SSH key configuration (AllowUser, disable root login)
- Docker installation and network setup
- Caddy web server with WAF (Coraza) and CrowdSec
- UFW firewall
- Utilities (vim, zsh, make)
