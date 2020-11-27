from pyrobot import Robot
import numpy as np
robot = Robot('locobot')

import time

robot.gripper.open()
time.sleep(1)

robot.gripper.close()
