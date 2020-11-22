#! /bin/bash

if [ -d ~/pyrobot-ws ]; then
	echo "pyrobot-ws already exist"
	echo "Remove the old one if you want to set up a new workspace."
	return 1
fi

# Step 1 - Setup WS

PYROBOT_FOLDER=~/pyrobot-ws/catkin_ws
mkdir -p ~/pyrobot-ws/catkin_ws/src
cd $PYROBOT_FOLDER/src
catkin_init_workspace
mv ~/pyrobot $PYROBOT_FOLDER/src/
cp pyrobot/Docker/locobot/docker_run.sh $PYROBOT_FOLDER/..
cp pyrobot/Docker/locobot/docker_join.sh $PYROBOT_FOLDER/..

# Step 2 - Setup robot desceiption (interbotix)
cd $PYROBOT_FOLDER/src/pyrobot/robots/LoCoBot/locobot_description/urdf
ln interbotix_locobot_description.urdf locobot_description.urdf
cd $PYROBOT_FOLDER/src/pyrobot/robots/LoCoBot/locobot_moveit_config/config
ln interbotix_locobot.srdf locobot.srdf
cd $PYROBOT_FOLDER/src/pyrobot/robots/LoCoBot/locobot_control/src
sed -i 's/\(float restJnts\[5\] = \)\(.*\)/\1{0, -1.30, 1.617, 0.5, 0};/' locobot_controller.cpp

# Step 3 - Clone thirdparty packages
if [ ! -d "$PYROBOT_FOLDER/src/pyrobot/robots/LoCoBot/thirdparty" ]; then

  	cd $PYROBOT_FOLDER/src/pyrobot/robots/LoCoBot
  	mkdir thirdparty
  	cd thirdparty
		git clone https://github.com/AutonomyLab/create_autonomy
		git clone https://github.com/ROBOTIS-GIT/dynamixel-workbench.git
		git clone https://github.com/ROBOTIS-GIT/DynamixelSDK.git
		git clone https://github.com/ROBOTIS-GIT/dynamixel-workbench-msgs.git
		git clone https://github.com/ros-controls/ros_control.git
		git clone https://github.com/kalyanvasudev/ORB_SLAM2.git
		git clone https://github.com/s-gupta/ar_track_alvar.git

	# assume use ros distro melodic
	cd create_autonomy && git checkout 90e597ea4d85cde1ec32a1d43ea2dd0b4cbf481c && cd ..
	cd dynamixel-workbench && git checkout bf60cf8f17e8385f623cbe72236938b5950d3b56 && cd ..
	cd DynamixelSDK && git checkout 05dcc5c551598b4d323bf1fb4b9d1ee03ad1dfd9 && cd ..
	cd dynamixel-workbench-msgs && git checkout 93856f5d3926e4d7a63055c04a3671872799cc86 && cd ..
	cd ros_control && git checkout cd39acfdb2d08dc218d04ff98856b0e6a525e702 && cd ..
	cd ORB_SLAM2 && git checkout ec8d750d3fc813fe5cef82f16d5cc11ddfc7bb3d && cd ..
	cd ar_track_alvar && git checkout a870d5f00a548acb346bfcc89d42b997771d71a3 && cd ..

fi

# Step 4 - Clone more necessary packages
if [ ! -d "$PYROBOT_FOLDER/src/turtlebot" ]; then
	cd $PYROBOT_FOLDER/src/
	mkdir turtlebot
	cd turtlebot

	git clone https://github.com/turtlebot/turtlebot_simulator
	git clone https://github.com/turtlebot/turtlebot.git
	git clone https://github.com/turtlebot/turtlebot_apps.git
	git clone https://github.com/turtlebot/turtlebot_msgs.git
	git clone https://github.com/turtlebot/turtlebot_interactions.git

	git clone https://github.com/toeklk/orocos-bayesian-filtering.git

	git clone https://github.com/udacity/robot_pose_ekf
	git clone https://github.com/ros-perception/depthimage_to_laserscan.git

	git clone https://github.com/yujinrobot/kobuki_msgs.git
	git clone https://github.com/yujinrobot/kobuki_desktop.git
	cd kobuki_desktop/
	rm -r kobuki_qtestsuite
	cd -
	git clone https://github.com/yujinrobot/kobuki.git
	cd kobuki && git checkout melodic && cd ..
	mv kobuki/kobuki_description kobuki/kobuki_bumper2pc \
	  kobuki/kobuki_node kobuki/kobuki_keyop \
	  kobuki/kobuki_safety_controller ./
	
	#rm -r kobuki

	git clone https://github.com/yujinrobot/yujin_ocs.git
	mv yujin_ocs/yocs_cmd_vel_mux yujin_ocs/yocs_controllers .
	mv yujin_ocs/yocs_safety_controller yujin_ocs/yocs_velocity_smoother .
	rm -rf yujin_ocs

	# sudo apt-get install ros-$ROS_NAME-kobuki-* -y
	# sudo apt-get install ros-$ROS_NAME-ecl-streams -y
fi

# Step 5 - Add path
echo "export ORBSLAM2_LIBRARY_PATH=~/pyrobot-ws/catkin_ws/src/pyrobot/robots/LoCoBot/thirdparty/ORB_SLAM2" >> ~/.bashrc
