migrate:
ifndef changelog
	@echo 'Property "changelog" is not defined'
else ifndef liquibase
	@echo 'Property "liquibase" is not defined'
else
	docker run --rm \
		-v ./$(changelog):/liquibase/changelog \
		--add-host=host.docker.internal:host-gateway \
		liquibase/liquibase \
		--defaults-file=changelog/$(liquibase).properties \
		update
endif

rollback:
ifndef changelog
	@echo 'Property "changelog" is not defined'
else ifndef liquibase
	@echo 'Property "liquibase" is not defined'
else ifndef count
	@echo 'Property "count" is not defined'
else
	docker run --rm \
		-v ./$(changelog):/liquibase/changelog \
		--add-host=host.docker.internal:host-gateway \
		liquibase/liquibase \
		--defaults-file=changelog/$(liquibase).properties \
		rollback-count $(count)
endif
