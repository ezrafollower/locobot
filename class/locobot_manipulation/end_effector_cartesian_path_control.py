from pyrobot import Robot
import numpy as np
robot = Robot('locobot')

robot.arm.go_home()
displacement = np.array([0, 0, -0.15])
robot.arm.move_ee_xyz(displacement, plan=True)
displacement = np.array([-0.1, 0, 0])
robot.arm.move_ee_xyz(displacement, plan=True)
robot.arm.go_home()
