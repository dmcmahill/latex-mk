# The directory that holds this file relative to $(top_srcdir)
BUILD_SCRIPT_DIR = build-helpers

# Check that package version matches git version before creating dist tarballs
# May want to add git-version-check-news back in.
dist-hook: git-version-check git-version-stamp
distcheck-hook: git-version-check

# Note: We cannot run autogen.sh from here, because we would need some way to
#       restart the whole dist process from the start and there is none.
PACKAGE_VERSION_SH = $(top_srcdir)/$(BUILD_SCRIPT_DIR)/package-version.sh
EXTRA_DIST += $(PACKAGE_VERSION_SH)
EXTRA_DIST += $(top_srcdir)/$(BUILD_SCRIPT_DIR)/package-version.mk
.PHONY: git-version-check
git-version-check:
	@git_ver=$$($(PACKAGE_VERSION_SH) $(top_srcdir) version-stamp); \
	if test "x$${git_ver}" = "x$(PACKAGE_VERSION)"; then :; else \
		echo "ERROR: PACKAGE_VERSION and 'git describe' version do not match:"; \
		echo "         current 'git describe' version: $${git_ver}"; \
		echo "         current PACKAGE_VERSION:        $(PACKAGE_VERSION)"; \
		rm -rf "$(top_srcdir)/autom4te.cache"; \
		if test -f "$(top_srcdir)/autogen.sh"; then \
			echo "Update PACKAGE_VERSION by running $(top_srcdir)/autogen.sh."; \
		else \
			echo "Update PACKAGE_VERSION by running autoreconf(1)."; \
		fi; \
		exit 1; \
	fi

# FIXME: NEWS check uses ${foo%%-*} POSIX shell, tested
#        with bash, dash, busybox.
.PHONY: git-version-check-news
git-version-check-news:
	@git_ver=$$($(PACKAGE_VERSION_SH) $(top_srcdir) version-stamp); \
	gv_xyz="$$(echo $${git_ver} | $(AWK) -F '[^0-9]' '{maj=$$1; min=$$2; patch=$$3;} END{printf("%d.%d.%d\n", maj, min, patch)}')" ; \
	if [[ "$${git_ver}" != "$${gv_xyz}" ]] ; then is_release=no; else is_release=yes ; fi ; \
	gv_xy="$${gv_xyz%.*}"; \
	pkg="$$(echo "$(PACKAGE_TARNAME)" | $(AWK) -f $(top_srcdir)/$(BUILD_SCRIPT_DIR)/pascal-case.awk)" ; \
	echo "Checking for $${pkg}-$${gv_xyz} or $${pkg}-$${gv_xy} release notes" ; \
	updated=no ; \
	if grep -q "^Release Notes for $${pkg}-$${gv_xyz}$$" "$(top_srcdir)/NEWS" ; then updated=yes ; fi ; \
	if grep -q "^Release Notes for $${pkg}-$${gv_xy}$$" "$(top_srcdir)/NEWS" ; then updated=yes ; fi ; \
	if [[ $${updated} = "yes" ]] ; then \
		echo "NEWS is updated for version $${git_ver} ($${gv_xyz} or $${gv_xy})" ; \
	else \
		echo "NEWS not updated for version $${git_ver} ($${gv_xyz} or $${gv_xy}) not releasing" 1>&2; \
		exit 1; \
	fi

# Version stamp files can only exist in tarball source trees.
#
# So there is no need to generate them anywhere else or to clean them
# up anywhere.
.PHONY: git-version-stamp
git-version-stamp:
	echo "$(PACKAGE_VERSION)" > "$(distdir)/version-stamp"

# Requires git 1.5 to work properly.
#if HAVE_GIT
# Usage: $ make tag VER=1.2
.PHONY: tag
tag:
	test -d "$(top_srcdir)/.git"
	@cd "$(top_srcdir)" && $(GIT) status | cat;:
	@cd "$(top_srcdir)" && if $(GIT) diff-files --quiet; then :; else \
		echo "Uncommitted local changes detected."; \
		exit 1; fi
	@cd "$(top_srcdir)" && if $(GIT) diff-index --cached --quiet HEAD; then :; else \
		echo "Uncommitted cached changes detected."; \
		exit 2; fi
	@if test "x$(VER)" = "x"; then \
		echo "VER not defined. Try 'make tag VER=2.11' or something similar."; \
		exit 3; \
        fi
	@test "x$$(echo "$(VER)" | $(SED) 's/^[0-9]\{1,\}\.[0-9]\{1,\}//')" = "x" || { \
		echo "VER=$(VER) is not in numerical 'x.y' format."; \
		exit 4; }
	@test "x$$($(SED) '1q' '$(top_srcdir)/NEWS')" = "x$(PACKAGE_TARNAME) $(VER)" || { \
		echo "NEWS does not start with entry for '$(PACKAGE_TARNAME) $(VER)'"; \
		exit 5; }
	@$(SED) -n '1p; 2,/^$(PACKAGE_TARNAME) / p' '$(top_srcdir)/NEWS' \
		| $(SED) '$$ { /^$(PACKAGE_TARNAME) / d }' | $(SED) '$$ { /^$$/d }' \
		> TAG-MESSAGE
	@echo "======================================================================="
	@cat TAG-MESSAGE
	@echo "======================================================================="
	@echo "Do you really want to tag this as release '$(PACKAGE_TARNAME)-$(VER)'? Enter to continue, Ctrl-C to abort."
	@read
	msgfile="$$PWD/TAG-MESSAGE"; \
	cd "$(top_srcdir)" && $(GIT) tag -s -F "$$msgfile" "$(PACKAGE_TARNAME)-$(VER)"; \
	rm -f "$$msgfile"
#endif

# Update *.h file to contain up-to-date version number
A_V = package-version-internal
CLEANFILES    += $(A_V).h
BUILT_SOURCES += $(A_V).h.stamp
$(A_V).h.stamp:
	@current_ver=$$($(PACKAGE_VERSION_SH) $(top_srcdir) version-stamp); \
	{ echo '#ifndef PACKAGE_VERSION_INTERNAL_H'; \
	  echo "#define PACKAGE_VERSION_INTERNAL \"$${current_ver}\""; \
	  echo "#endif /* !PACKAGE_VERSION_INTERNAL */"; } > "$(A_V).h.new"
	@if test -f "$(A_V).h" \
	&& cmp "$(A_V).h.new" "$(A_V).h"; then :; \
	else cat "$(A_V).h.new" > "$(A_V).h"; fi; \
	rm -f "$(A_V).h.new"

