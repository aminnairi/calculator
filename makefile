.PHONY: start docs stop restart format install

docs: docs/calculator.js docs/index.html docs/manifest.webmanifest docs/robots.txt
	docker-compose run --rm yarn gulp images

docs/calculator.js: src/Calculator.elm
	docker-compose run --rm elm make --optimize --output $@ $<
	docker-compose run --rm yarn terser --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" --output $@ $@
	docker-compose run --rm yarn terser --mangle --output $@ $@

docs/index.html: src/index.html
	docker-compose run --rm node tools/minify/html.mjs $< $@

docs/manifest.webmanifest: src/assets/manifest.webmanifest
	docker-compose run --rm node tools/minify/manifest.mjs $< $@

docs/robots.txt: src/assets/robots.txt
	docker-compose run --rm node tools/copy.mjs $< $@

start:
	docker-compose up --detach nginx

stop:
	docker-compose down --remove-orphans --volumes

restart: stop start

install:
	docker-compose run --rm yarn
