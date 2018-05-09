# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := cgal
$(PKG)_WEBSITE  := https://www.cgal.org/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.12
$(PKG)_CHECKSUM := 442ef4fffb2ad6e4141e5a7902993ae6a4e73f7cb641fae1010bb586f6ca5e3f
# using / in tag name means we have to set SUBDIR, FILE, URL
$(PKG)_GH_CONF  := CGAL/cgal/tags, releases%2FCGAL-
$(PKG)_SUBDIR   := CGAL-$($(PKG)_VERSION)
$(PKG)_FILE     := CGAL-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/CGAL/cgal/releases/download/releases/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc boost gmp mpfr qt5

define $(PKG)_BUILD
    cd '$(BUILD_DIR)' && '$(TARGET)-cmake' '$(SOURCE_DIR)' \
        -DCGAL_INSTALL_CMAKE_DIR:STRING="lib/CGAL" \
        -DCGAL_INSTALL_INC_DIR:STRING="include" \
        -DCGAL_INSTALL_DOC_DIR:STRING="share/doc/CGAL-$($(PKG)_VERSION)" \
        -DCGAL_INSTALL_BIN_DIR:STRING="bin" \
        -DCGAL_Boost_USE_STATIC_LIBS:BOOL=$(CMAKE_STATIC_BOOL) \
        -DWITH_OpenGL:BOOL=ON \
        -DWITH_ZLIB:BOOL=ON \
        -C'$(PWD)/src/cgal-TryRunResults.cmake'

    $(MAKE) -C '$(BUILD_DIR)' -j $(JOBS)
    $(MAKE) -C '$(BUILD_DIR)' -j 1 install
endef
