#!/usr/bin/env bash

# Modify this for your environment

# Not required for ROS users, see CMakeLists.txt and hooks/setup.dsv

if [[ -z "${ARDUPILOT_GAZEBO}" ]]; then
  export ARDUPILOT_GAZEBO="$HOME/ardupilot_gazebo"
fi

if [[ -z "${ARDUPILOT_HOME}" ]]; then
  export ARDUPILOT_HOME="$HOME/ardupilot"
fi

if [[ -z "${COLCON_WS}" ]]; then
  export COLCON_WS="$HOME/colcon_ws"
fi


# Add results of ArduSub build
export PATH=${ARDUPILOT_HOME}/build/sitl/bin:$PATH

# Optional: add autotest to the PATH, helpful for running sim_vehicle.py
export PATH=${ARDUPILOT_HOME}/ardupilot/Tools/autotest:$PATH

# Add ardupilot_gazebo plugin
export GZ_SIM_SYSTEM_PLUGIN_PATH=${ARDUPILOT_GAZEBO}/build:$GZ_SIM_SYSTEM_PLUGIN_PATH

# Optional: add ardupilot_gazebo models and worlds
export GZ_SIM_RESOURCE_PATH=${ARDUPILOT_GAZEBO}/models:${ARDUPILOT_GAZEBO}/worlds:$GZ_SIM_RESOURCE_PATH

# Add bluerov2_gz models and worlds
export GZ_SIM_RESOURCE_PATH=${COLCON_WS}/src/bluerov2_gz/models:${COLCON_WS}/src/bluerov2_gz/worlds:$GZ_SIM_RESOURCE_PATH
