from pyrobot import Robot
import numpy as np
import time
robot = Robot('locobot')

target_joints = [
        [0.408, 0.721, -0.471, -1.4, 0.920],
        [-0.675, 0, 0.23, 1, -0.70]
    ]
robot.arm.go_home()

for joint in target_joints:
    robot.arm.set_joint_positions(joint, plan=False)
    time.sleep(1)
    
robot.arm.go_home()
