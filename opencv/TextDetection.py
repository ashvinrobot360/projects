import cv2
import pytesseract

pytesseract.pytesseract.tesseract_cmd = '/usr/bin/tesseract'

# img = cv2.imread('/home/ashvin/Desktop/OpenCVImages/Text/test.png')
#
# img = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
# print(pytesseract.image_to_string(img))
####################################
# hImg, wImg, _ = img.shape
# boxes = (pytesseract.image_to_boxes(img))
#
# print(type(boxes))
# for b in boxes.splitlines():
#     # print(b)
#     b = b.split(' ')
#     # print(b)
#     x, y, w, h = int(b[1]), int(b[2]), int(b[3]), int(b[4])
#     cv2.rectangle(img, (x,hImg - y), (w, hImg - h), (255, 0, 255), 1)
#     cv2.putText(img, b[0], (x, hImg -y + 25), cv2.FONT_HERSHEY_SIMPLEX, 0.3, (255,0,255), 1)
#
# cv2.imshow('Result', img)
# cv2.waitKey(0)
#
# img = cv2.imread('/home/ashvin/Desktop/OpenCVImages/Text/test.png')



cap = cv2.VideoCapture(0)

while True:

    success, img = cap.read()
    img = cv2.resize(img, (800, 600))

    hImg, wImg, _ = img.shape
    boxes = (pytesseract.image_to_data(img))

    print(type(boxes))
    for x, b in enumerate(boxes.splitlines()):
        # print(b)
        if x!= 0:
            b = b.split()
            # print(b)
            if len(b) == 12:
                x, y, w, h = int(b[6]), int(b[7]), int(b[8]), int(b[9])
                cv2.rectangle(img, (x,y), (w + x, h + y), (255, 0, 255), 1)
                print(b[11])
                cv2.putText(img, b[11], (x, y), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (255,0,255), 1)

    cv2.imshow('Result', img)
    cv2.waitKey(1)