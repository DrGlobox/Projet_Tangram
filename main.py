# -*- coding: utf-8 -*-

import time
import sys, random

from pl_launcher import start_script
from PyQt4 import QtGui, QtCore
from interface import *

def main():
    app = QtGui.QApplication(sys.argv)
    interface = ShapesBase()
    interface.show()
    app.exec_()

if __name__ == "__main__":
    main()

