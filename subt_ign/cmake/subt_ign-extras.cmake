find_package(ignition-transport11 REQUIRED)

list(APPEND catkin_INCLUDE_DIRS ${ignition-transport11_INCLUDE_DIRS})
list(APPEND catkin_LIBRARIES ${ignition-transport11_LIBRARIES} ${Protobuf_LIBRARIES})
