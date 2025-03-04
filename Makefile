build-caddy:
	@echo "Building Caddy FULL image"
	docker build -t ghcr.io/elagala/server-initializer/caddy-waf-crowdsec:latest -f images/caddy_full/Dockerfile .
	docker push ghcr.io/elagala/server-initializer/caddy-waf-crowdsec:latest
