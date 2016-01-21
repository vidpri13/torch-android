MACRO(ADD_TORCH_WRAP target luafile)
  INCLUDE_DIRECTORIES("${CMAKE_CURRENT_BINARY_DIR}")
  GET_FILENAME_COMPONENT(_file_ "${luafile}" NAME_WE)
  SET(cfile "${_file_}.c")
  SET(wrapdir "${CMAKE_CURRENT_SOURCE_DIR}/../cwrap")
  SET(luapath "./?.lua;${CMAKE_CURRENT_SOURCE_DIR}/?.lua;${wrapdir}/?.lua;${LUA_PATH};")
  SET($ENV{LUA_PATH} "./?.lua;${CMAKE_CURRENT_SOURCE_DIR}/?.lua;${wrapdir}/?.lua;${LUA_PATH};")

  ADD_CUSTOM_COMMAND(
    OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${cfile}"
    COMMAND env  ARGS "LUA_PATH=\"${luapath}\"" luajit "${CMAKE_CURRENT_SOURCE_DIR}/${luafile}" "${CMAKE_CURRENT_BINARY_DIR}/${cfile}"
    DEPENDS "${luafile}" "${wrapdir}/init.lua" "${wrapdir}/types.lua")
  ADD_CUSTOM_TARGET(${target} DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${cfile}")
ENDMACRO(ADD_TORCH_WRAP)
