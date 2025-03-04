# Build stage with xcaddy
FROM caddy:builder AS builder

# Install xcaddy and build Caddy with plugins
RUN xcaddy build \
  --with github.com/corazawaf/coraza-caddy/v2@v2.0.0 \
  --with github.com/hslatman/caddy-crowdsec-bouncer/http@v0.8.1 \
  --with github.com/mholt/caddy-l4

# Stage to download OWASP CRS
FROM alpine:latest AS crs
RUN apk add --no-cache git && \
  git clone --depth 1 --branch v4.0.0 \
  https://github.com/coreruleset/coreruleset.git /coreruleset && \
  mv /coreruleset/crs-setup.conf.example /coreruleset/crs-setup.conf

# Final stage
FROM caddy:latest

# Copy custom Caddy binary
COPY --from=builder /usr/bin/caddy /usr/bin/caddy

# Copy OWASP CRS from the crs stage
COPY --from=crs /coreruleset /etc/caddy/coreruleset
