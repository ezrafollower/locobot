#! /bin/bash

# Step 1, Compile Orbslam packages
cd ~/pyrobot-ws/catkin_ws/src/pyrobot/robots/LoCoBot/install
chmod +x install_orb_slam2.sh
source install_orb_slam2.sh

# Step 2, Make the WS
source ~/camera_ws/devel/setup.bash
cd ~/pyrobot-ws/catkin_ws
catkin_make

# Step 3, Dependencies and config for calibration
chmod +x ~/pyrobot-ws/catkin_ws/src/pyrobot/robots/LoCoBot/locobot_navigation/orb_slam2_ros/scripts/gen_cfg.py
source ~/pyrobot-ws/catkin_ws/devel/setup.bash
rosrun orb_slam2_ros gen_cfg.py