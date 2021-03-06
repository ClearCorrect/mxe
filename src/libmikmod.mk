# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := libmikmod
$(PKG)_WEBSITE  := http://mikmod.raphnet.net/
$(PKG)_DESCR    := libMikMod
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.7
$(PKG)_CHECKSUM := 4cf41040a9af99cb960580210ba900c0a519f73ab97b503c780e82428b9bd9a2
$(PKG)_SUBDIR   := libmikmod-$($(PKG)_VERSION)
$(PKG)_FILE     := libmikmod-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/mikmod/libmikmod/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := https://$(SOURCEFORGE_MIRROR)/project/mikmod/outdated_versions/libmikmod/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/mikmod/files/libmikmod/' | \
    $(SED) -n 's,.*<a href="/projects/mikmod/files/libmikmod/\([0-9][^>]*\)/".*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(BUILD_STATIC), \
        $(SED) -i 's!defined(MIKMOD_STATIC)!1!g' '$(1)/include/mikmod.h')
    cd '$(1)' && ./configure \
        $(MXE_CONFIGURE_OPTS) \
        --disable-doc
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_CRUFT)

    '$(TARGET)-gcc' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(TEST_FILE)' -o '$(PREFIX)/$(TARGET)/bin/test-libmikmod.exe' \
        `'$(PREFIX)/$(TARGET)/bin/libmikmod-config' --cflags --libs`
endef
