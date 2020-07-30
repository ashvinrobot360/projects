import cv2
import numpy as np


cap = cv2.VideoCapture(0)

imgResult = None
myColors = [[29, 120, 50, 93, 255, 255], #green
            [0, 167, 121, 12, 255, 255], #orange
            [91, 184, 61, 179, 255, 200]  #blue
            ]

myColorsRGB = [[34, 139, 34], #green
            [0, 69, 255], #orange
            [255, 0, 0]  #blue
            ]

myPoints = []

def drawOnCanvas(myPoints, myColorsRGB):
    for point in myPoints:
        cv2.circle(imgResult, (point[0], point[1]), 10, myColorsRGB[point[2]], cv2.FILLED)

def findColor(img, myColors, myColorsRGB):
    imgHSV = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    newPoints = []
    for i, color in enumerate(myColors):
        lower = np.array(color[0:3])
        upper = np.array(color[3:6])
        mask = cv2.inRange(imgHSV, lower, upper)
        x, y= getContours(mask)
        cv2.circle(imgResult, (x, y), 10, myColorsRGB[i], cv2.FILLED)
        if x!=0 and y!=0:
            newPoints.append([x,y,i])
        # cv2.imshow(str(color[3]), mask)
    return newPoints

def empty(a):
    pass

def getContours(img):
    x, y, w, h = 0, 0, 0, 0
    contours,hierarchy = cv2.findContours(img,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE)
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area>500:
            cv2.drawContours(imgResult, cnt, -1, (147, 20, 255), 3)
            peri = cv2.arcLength(cnt,True)
            approx = cv2.approxPolyDP(cnt,0.02*peri,True)
            x, y, w, h = cv2.boundingRect(approx)

    return x+w//2, y


def main():
    global imgResult, myPoints
    while True:
        success, img = cap.read()
        imgResult = img.copy()
        newPoints = findColor(img, myColors, myColorsRGB)

        if len(newPoints) != 0:
            for newP in newPoints:
                myPoints.append(newP)

        if len(myPoints)!=0:
            drawOnCanvas(myPoints, myColorsRGB)

        key = cv2.waitKey(1) & 0xFF
        if key == ord('q'):
            break
        elif key == ord('c'):
            # imgResult = img.copy()
            myPoints = []
        imgResult = cv2.resize(imgResult, (1280,1024))
        cv2.imshow("Result", imgResult)


if __name__ == "__main__":
    main()