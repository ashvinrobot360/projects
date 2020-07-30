import cv2
import os

faceCascade = cv2.CascadeClassifier("/home/ashvin/haarcascade_frontalface_default.xml")

for file in os.listdir("/home/ashvin/Desktop/KerasImages/Family/family_photos/Veni"):
    img = cv2.imread(f"/home/ashvin/Desktop/KerasImages/Family/family_photos/Veni/{file}")
    print(os.path.abspath(file))
    print(img.shape)
    img = cv2.resize(img, (int(img.shape[1]/5), int(img.shape[0]/5)))

    faces = faceCascade.detectMultiScale(img, 1.1, 4)
    for (x, y, w, h) in faces:
        cv2.rectangle(img, (x,y), (x+w,y+h), (255,0,0), 2)
    cv2.imshow("Result", img)
    cv2.waitKey(0)