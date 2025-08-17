build-caddy:
	@echo "Building Caddy FULL image"
	docker build -t ghcr.io/elagala/server-initializer/caddy-waf-crowdsec:latest -f images/caddy_full/Dockerfile .
	docker push ghcr.io/elagala/server-initializer/caddy-waf-crowdsec:latest

dev: clean build
	echo "Running container and testing install script..."
	docker run -it --rm server-initializer /bin/bash -c "cd /server-initializer/src && ./install.sh agala --development"

dev-keep-alive: clean build
	echo "Running install script and keeping container alive for testing..."
	docker run -it --name server-initializer-test server-initializer /bin/bash -c "cd /server-initializer/src && ./install.sh agala --development && echo 'Setup complete! Starting interactive shell...' && exec /bin/bash"

build:
	echo "Building Ubuntu test container..."
	docker build -t server-initializer .

clean:
	echo "Cleaning up containers and images..."
	docker rm -f server-initializer-test 2>/dev/null || true
	docker rmi server-initializer 2>/dev/null || true
