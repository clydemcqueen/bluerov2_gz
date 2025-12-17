# BlueROV2 Ping

This is the base BlueROV2 model with a Ping sonar attached.

## Usage

Gazebo and all other requirements documented in the project [README](/README.md) should
be installed.

Update the `GZ_SIM_RESOURCE_PATH` to include the BlueROV2 models:

~~~bash
export GZ_SIM_RESOURCE_PATH=$GZ_SIM_RESOURCE_PATH:\
~/colcon_ws/src/bluerov2_gz/models:\
~/colcon_ws/src/bluerov2_gz/worlds
~~~

### Start Gazebo

~~~bash
gz sim -v 3 -r bluerov2_ping.world
~~~

### Run ArduPilot SITL

The `ping.params` file will set up a simple rangefinder in ArduSub. You can add it to the ArduPilot SITL command line:

~~~bash
# Modify paths as necessary
export COLCON_WS=$HOME/colcon_ws
export BLUEROV2_GZ_HOME=$COLCON_WS/src/bluerov2_gz

Tools/autotest/sim_vehicle.py -L RATBeach -v ArduSub -f vectored --model=JSON --out=udp:0.0.0.0:14550 --console --wipe --add-param-file=$BLUEROV2_GZ_HOME/params/ping.params
~~~

### Send commands to the ROV

~~~
arm throttle
rc 3 1450     
rc 3 1500
mode alt_hold
rc 5 1550
disarm
~~~

## Credits

See the [BlueROV2](/models/bluerov2/BlueROV2.md) model for credits.
