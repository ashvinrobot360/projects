import cv2
import numpy as np


img1 = cv2.imread('/home/ashvin/Desktop/OpenCVImages/Medicene/IMG_4281.JPG', 0)
img2 = cv2.imread('/home/ashvin/Desktop/OpenCVImages/Medicene/IMG_4282.JPG', 0)
img3 = cv2.imread('/home/ashvin/Desktop/OpenCVImages/Medicene/IMG_4283.JPG', 0)

img1 = cv2.resize(img1, (640, 800))
img2 = cv2.resize(img2, (640, 800))
img3 = cv2.resize(img3, (640, 800))

orb = cv2.ORB_create(nfeatures=1000)

kp1, des1 = orb.detectAndCompute(img1, None)
kp2, des2 = orb.detectAndCompute(img2, None)
kp3, des3 = orb.detectAndCompute(img3, None)

bf= cv2.BFMatcher()
matches = bf.knnMatch(des1, des2, k=2)
# imgKp1 = cv2.drawKeypoints(img1, kp1, None)
# imgKp2 = cv2.drawKeypoints(img2, kp2, None)
# imgKp3 = cv2.drawKeypoints(img3, kp3, None)
good = []
for m, n in matches:
    if m.distance < 0.75*n.distance:
        good.append([m])

img3 = cv2.drawMatchesKnn(img1, kp1, img1, kp1, good, None, flags = 2)
# cv2.imshow('img1', imgKp1)
# cv2.imshow('img2', imgKp2)
# cv2.imshow('img3', imgKp3)

cv2.imshow('img3', img3)

cv2.waitKey(0)