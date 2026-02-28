# Skill Makefile — <skill-name>
#
# Targets for building, running, testing, and publishing skill images to GHCR.
# Replace <skill-name> with the actual skill name.

SKILL_NAME   := <skill-name>
REGISTRY     := ghcr.io/8r4n/deerflow-skills
IMAGE        := $(REGISTRY)/$(SKILL_NAME)
VERSION      := $(shell grep '^version:' skill.yaml | cut -d'"' -f2)
SHORT_SHA    := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")

.PHONY: build run test push clean audit-sbom audit-vuln audit

## build — Build the skill Docker image
build:
	docker build -t $(IMAGE):$(VERSION) -t $(IMAGE):latest .

## run — Run the skill container locally
run: build
	docker run --rm -p 8080:8080 $(IMAGE):latest

## test — Run contract tests inside Docker
test: build
	docker run --rm $(IMAGE):latest python -m pytest tests/ -v

## push — Push skill image to GHCR (requires prior `docker login ghcr.io`)
push: build
	docker push $(IMAGE):$(VERSION)
	docker push $(IMAGE):latest
	@echo "Pushed $(IMAGE):$(VERSION) and $(IMAGE):latest"

## tag-sha — Tag and push with the current git short SHA
tag-sha: build
	docker tag $(IMAGE):latest $(IMAGE):sha-$(SHORT_SHA)
	docker push $(IMAGE):sha-$(SHORT_SHA)
	@echo "Pushed $(IMAGE):sha-$(SHORT_SHA)"

## clean — Remove local images for this skill
clean:
	-docker rmi $(IMAGE):$(VERSION) $(IMAGE):latest $(IMAGE):sha-$(SHORT_SHA) 2>/dev/null

## audit-sbom — Generate a Software Bill of Materials (SBOM) using Syft
audit-sbom: build
	docker run --rm \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  anchore/syft:latest \
	  $(IMAGE):latest \
	  --output spdx-json \
	  > sbom-$(SKILL_NAME).spdx.json
	@echo "SBOM written to sbom-$(SKILL_NAME).spdx.json"

## audit-vuln — Scan the skill image for vulnerabilities using Grype
audit-vuln: build
	docker run --rm \
	  -v /var/run/docker.sock:/var/run/docker.sock \
	  anchore/grype:latest \
	  $(IMAGE):latest \
	  --fail-on critical
	@echo "Grype scan complete for $(IMAGE):latest"

## audit — Generate SBOM and run vulnerability scan (audit-sbom + audit-vuln)
audit: audit-sbom audit-vuln
