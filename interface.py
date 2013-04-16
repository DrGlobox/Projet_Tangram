# -*- coding: utf-8 -*-

import sys
from PyQt4 import QtGui, QtCore
class ShapesBase(QtGui.QWidget):

    shapes = []
    colors = [QtGui.QColor(255, 0, 0, 80), QtGui.QColor(255, 0, 0, 160), QtGui.QColor(255, 0, 0, 255),
              QtGui.QColor(10, 163, 2, 55), QtGui.QColor(160, 100, 0, 255),QtGui.QColor(60, 100, 60, 255),
              QtGui.QColor(50, 50, 50, 255)]

    def __init__(self, parent=None):
        QtGui.QWidget.__init__(self, parent)

        self.setGeometry(200, 200, 400, 400)
        self.setWindowTitle('Tangram')

        for line in open('shapes.txt', 'r'):
            self.shapes += [line.split()]

    def paintEvent(self, event):
        paint = QtGui.QPainter()
        paint.begin(self)

        color = QtGui.QColor(0, 0, 0)
        color.setNamedColor('#d4d4d4')
        paint.setPen(color)

        scale = self.width() / 100

        point = QtCore.QPointF
        for shape in self.shapes:
            paint.setBrush(self.colors[ self.shapes.index(shape) ])
            polygon = QtGui.QPolygon(len(shape)/2) 
            for i in range(0,len(shape),2):
                polygon.setPoint(i/2,int(shape[i])*scale,int(shape[i+1])*scale)
            paint.drawPolygon(polygon)

        paint.end()
