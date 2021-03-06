include(vcpkg_common_functions)

vcpkg_check_linkage(ONLY_STATIC_LIBRARY)

vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO htacg/tidy-html5
    REF 5.4.0
    SHA512 d92c89f2ef371499f9c3de6f9389783d2449433b4da1f5a29e2eb81b7a7db8dd9f68e220cdde092d446e9bd779bcbc30f84bda79013526540f29d00f438cb402
    HEAD_REF master
    PATCHES
        remove_execution_character_set.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS
        -DBUILD_SHARED_LIB=OFF
        -DTIDY_CONSOLE_SHARED=OFF
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE ${CURRENT_PACKAGES_DIR}/debug/bin/tidyd.exe)
file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/tools/tidy-html5)
file(RENAME ${CURRENT_PACKAGES_DIR}/bin/tidy.exe ${CURRENT_PACKAGES_DIR}/tools/tidy-html5/tidy.exe)

if(VCPKG_LIBRARY_LINKAGE STREQUAL "static")
    file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/bin ${CURRENT_PACKAGES_DIR}/debug/bin)
endif()

vcpkg_copy_tool_dependencies(${CURRENT_PACKAGES_DIR}/tools/${PORT})

file(INSTALL ${SOURCE_PATH}/README/LICENSE.md DESTINATION ${CURRENT_PACKAGES_DIR}/share/tidy-html5 RENAME copyright)
