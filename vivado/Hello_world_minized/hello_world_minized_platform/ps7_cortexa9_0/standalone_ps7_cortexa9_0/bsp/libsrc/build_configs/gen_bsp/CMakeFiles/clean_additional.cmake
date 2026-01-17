# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "")
  file(REMOVE_RECURSE
  "/home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/vivado/Hello_world_minized/hello_world_minized_platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/include/sleep.h"
  "/home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/vivado/Hello_world_minized/hello_world_minized_platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/include/xiltimer.h"
  "/home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/vivado/Hello_world_minized/hello_world_minized_platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/include/xtimer_config.h"
  "/home/user/Desktop/Personal_Stuff/Homework/an4/LICENTA/vivado/Hello_world_minized/hello_world_minized_platform/ps7_cortexa9_0/standalone_ps7_cortexa9_0/bsp/lib/libxiltimer.a"
  )
endif()
