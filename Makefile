build_librespot: build_librespot_compiler
	docker-compose build app

build_librespot_compiler: clone_librespot_repo
	docker-compose build compiler

clone_librespot_repo:
	git clone --depth 1 --branch master https://github.com/librespot-org/librespot.git || echo "git repo exists"

cleanup: build_librespot
	rm -rf librespot
