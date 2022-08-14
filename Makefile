include .env
export

# .ONESHELL:
.PHONY: create_dir copy_conf create_docker_things set_directory clean run build
.SILENT: create_dir copy_conf create_docker_things set_directory clean run build

ccend=$(shell tput sgr0)
ccbold=$(shell tput bold)
ccgreen=$(shell tput setaf 2)
ccso=$(shell tput smso)

# Create directory for docker volume
create_dir:
	@echo "$(ccso)--> Create directory for grafana service $(ccend)"
	@mkdir -p "${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/data" \
		"${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/config" \
		"${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/provisioning" \
		"${DEFAULT_CONTAINER_VOLUME_PATH}/postgresql/data"

# Copy configure file
copy_conf:
	@echo "$(ccso)--> Copy configure file $(ccend)"
	@cp ./workspace/grafana-postgres/grafana/config/grafana.ini "${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/config/"
	@cp -r ./workspace/grafana-postgres/grafana/provisioning/* "${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/provisioning/"
	@cp ./workspace/grafana-postgres/postgresql/init.sql "${DEFAULT_CONTAINER_VOLUME_PATH}/postgresql/"


# Create docker volume & network
create_docker_things:
	@echo "$(ccso)--> Create docker volume & network $(ccend)"
	@docker volume create -d local -o type=none -o o=bind -o device="${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/data" "${VOLUME_GRAFANA_DATA}"
	@docker volume create -d local -o type=none -o o=bind -o device="${DEFAULT_CONTAINER_VOLUME_PATH}/grafana/provisioning" "${VOLUME_GRAFANA_PROVISIONING}"
	@docker volume create -d local -o type=none -o o=bind -o device="${DEFAULT_CONTAINER_VOLUME_PATH}/postgresql/data" "${VOLUME_POSTGRESQL_DATA}"
	@docker network create "${NETWORK_GRAFANA}"

# Set directory owner & mode
set_directory:
	@echo "$(ccso)--> Set directory $(ccend)"
	@chown -R "${USER}:" "${DEFAULT_CONTAINER_VOLUME_PATH}"
	@chmod -R 755 "${DEFAULT_CONTAINER_VOLUME_PATH}"

# Clean grafana project
clean:
	@echo "$(ccso)--> Removing virtual environment $(ccend)"
	@docker compose --env-file ./.env -f ./workspace/grafana-postgres/docker-compose.yml down --remove-orphans
	@rm -rf ${DEFAULT_CONTAINER_VOLUME_PATH}
	@docker volume rm -f ${VOLUME_GRAFANA_DATA} ${VOLUME_GRAFANA_PROVISIONING} ${VOLUME_POSTGRESQL_DATA}
	@docker network rm ${NETWORK_GRAFANA}

# Build grafana project
build:
	@echo ""
	@echo "$(ccso)--> Build grafana project $(ccend)"
	$(MAKE) create_dir && \
	$(MAKE) copy_conf && \
	$(MAKE) create_docker_things && \
	$(MAKE) set_directory

# Run grafana using docker compose
run:
	@echo ""
	@echo "$(ccso)--> Run docker compose $(ccend)"
	@docker compose --env-file ./.env -f ./workspace/grafana-postgres/docker-compose.yml up

# Test
test:
	@echo ""
	@echo "$(ccso)--> Grafana Health Check $(ccend)"
	@curl -f "http://localhost:3000/api/health"; echo;
	@curl -f "http://localhost:8081"; echo;