# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appIHA_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appIHA_autogen.dir\\ParseCache.txt"
  "appIHA_autogen"
  )
endif()
