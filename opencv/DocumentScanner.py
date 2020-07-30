import cv2
import numpy as np

widthImg=640
heightImg =480

cap = cv2.VideoCapture(0)
cap.set(3, 640)
cap.set(4, 480)
cap.set(10, 99999)
imgContour = None
def getContours(img):
    x, y, w, h = 0, 0, 0, 0
    biggest = np.array([])
    maxArea = 0
    contours,hierarchy = cv2.findContours(img,cv2.RETR_EXTERNAL,cv2.CHAIN_APPROX_NONE)
    for cnt in contours:
        area = cv2.contourArea(cnt)
        if area>5000:
            cv2.drawContours(imgContour, cnt, -1, (147, 20, 255), 3)
            peri = cv2.arcLength(cnt, True)
            approx = cv2.approxPolyDP(cnt,0.02*peri,True)

            if area > maxArea and len(approx) == 4:
                biggest = approx
                maxArea = area
    cv2.drawContours(imgContour, biggest, -1, (0, 255, 0), 20)
    return biggest

def preProcessing(img):
    imgGray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    imgBlur = cv2.GaussianBlur(imgGray, (5,5), 1)
    imgCanny = cv2.Canny(imgBlur, 200, 200)

    kernel = np.ones((5,5))
    imgDilate = cv2.dilate(imgCanny, kernel, iterations=2)
    imgErode = cv2.erode(imgDilate, kernel, iterations=1)

    return imgErode


def reorder(myPoints):
    myPoints = myPoints.reshape((4, 2))
    myPointsNew = np.zeros((4, 1, 2), np.int32)
    add = myPoints.sum(1)
    # print("add", add)
    myPointsNew[0] = myPoints[np.argmin(add)]
    myPointsNew[3] = myPoints[np.argmax(add)]
    diff = np.diff(myPoints, axis=1)
    myPointsNew[1] = myPoints[np.argmin(diff)]
    myPointsNew[2] = myPoints[np.argmax(diff)]
    # print("NewPoints",myPointsNew)
    return myPointsNew


def getWarp(img, biggest):
    biggest = reorder(biggest)
    pts1 = np.float32(biggest)
    pts2 = np.float32([[0, 0], [widthImg, 0], [0, heightImg], [widthImg, heightImg]])
    matrix = cv2.getPerspectiveTransform(pts1, pts2)
    imgOutput = cv2.warpPerspective(img, matrix, (widthImg, heightImg))

    imgCropped = imgOutput[20:imgOutput.shape[0] - 20, 20:imgOutput.shape[1] - 20]
    imgCropped = cv2.resize(imgCropped, (widthImg, heightImg))

    return imgCropped

def main():
    global imgContour
    while True:
        success, img = cap.read()
        imgContour = img.copy()
        
        imgResult = preProcessing(img)
        biggest = getContours(imgResult)
        print(biggest)
        # imgWarped = img.copy()
        if biggest.size != 0:
            imgWarped = getWarp(img, biggest)
            # imageArray = ([img,imgThres],
            #           [imgContour,imgWarped])
            imageArray = ([imgContour, imgWarped])
            cv2.imshow("ImageWarped", imgWarped)
        else:
            # imageArray = ([img, imgThres],
            #               [img, img])
            imageArray = ([imgContour, img])
        cv2.imshow("Video", imgContour)
        print("Image SIZE", img.shape)
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

if __name__ == "__main__":
    main()