.PHONY: start docs stop restart format install

docs:
	docker-compose run --rm yarn gulp
	docker-compose run --rm elm make --optimize --output docs/index.js src/Calculator.elm
	docker-compose run --rm yarn terser docs/index.js --compress "pure_funcs=[F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9],pure_getters,keep_fargs=false,unsafe_comps,unsafe" --output docs/index.js
	docker-compose run --rm yarn terser docs/index.js --mangle --output docs/index.js

start:
	docker-compose up --detach nginx

stop:
	docker-compose down --remove-orphans --volumes

restart: stop start

install:
	docker-compose run --rm yarn
