cmake_minimum_required(VERSION 3.12.2)
project(bluerov2_gz)

find_package(ament_cmake_auto REQUIRED)

# Update GZ_SIM_RESOURCE_PATH
# Reference: https://colcon.readthedocs.io/en/released/developer/environment.html#dsv-files
ament_environment_hooks(hooks/setup.dsv)

ament_auto_find_build_dependencies()

ament_auto_package(INSTALL_TO_SHARE models worlds)