# Makefile for managing Caddy

.PHONY: caddy\:restart caddy\:update-api-key caddy\:logs

caddy\:restart:
	@echo "Formatting and reloading Caddy configuration..."
	docker exec caddy caddy fmt --overwrite --config /etc/caddy/Caddyfile
	docker exec caddy caddy reload --config /etc/caddy/Caddyfile
	@echo "Caddy configuration reloaded successfully."

caddy\:crowdsec-key:
	@echo "Generating new CrowdSec API key..."
	docker exec crowdsec cscli bouncers add caddy-bouncer
	@echo "\n=== IMPORTANT ===\nCopy the API_KEY from the output above and replace the value of CROWDSEC_API_KEY in your .env file."

caddy\:generate-password:
	@echo "Generating new password hash..."
	docker exec -it caddy caddy hash-password
	@echo "\n=== IMPORTANT ===\nCopy the password hash from the output above and replace the value of PROMETHEUS_PASSWORD or LOKI_PASSWORD in your .env file."

caddy\:logs:
	@echo "Showing Caddy logs..."
	docker compose logs -f caddy
