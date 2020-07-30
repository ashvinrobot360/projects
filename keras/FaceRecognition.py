import face_recognition
import os
import cv2

FACES_DIR = "/home/ashvin/Desktop/KerasImages/face_rec"
TEST_DIR = "/home/ashvin/Desktop/KerasImages/face_rec/Ashvin"
TOLERANCE = 0.6

FRAME_THICKNESS = 3
FONT_THICKNESS = 2
MODEL = "cnn"

print("loading know faces...")

known_faces=[]
known_names=[]

for name in os.listdir(FACES_DIR):
    print("dir")
    for filename in os.listdir(f"{FACES_DIR}/{name}"):
        print("pic")

        image = face_recognition.load_image_file(f"{FACES_DIR}/{name}/{filename}")
        if len(face_recognition.face_encodings(image)) == 0:
            pass
        else:
            encoding = face_recognition.face_encodings(image)[0]
            known_faces.append(encoding)
            known_faces.append(name)

print("processing unknown faces")

for filename in os.listdir(TEST_DIR):
    print(filename)
    image = face_recognition.load_image_file(f"{TEST_DIR}/{filename}")
    locations = face_recognition.face_locations(image, model=MODEL)
    encodings = face_recognition.face_encodings(image, locations)
    image = cv2.cvtColor(image, cv2.COLOR_RGB2BGR)

    for face_encoding, face_location in zip(encodings, locations):
        results = face_recognition.compare_faces(known_faces, face_encoding, TOLERANCE)
        match = None
        if True in results:
            match = known_names[results.index(True)]
            print(f"Match found {match}")
            top_left = (face_location[3], face_location[0])
            bottom_right = (face_location[1], face_location[2])
            color = [0, 255, 0]
            cv2.rectangle(image, top_left, bottom_right, color, FRAME_THICKNESS)
            
            top_left = (face_location[3], face_location[0])
            bottom_right = (face_location[1], face_location[2] + 22)

            cv2.rectangle(image, top_left, bottom_right, color, cv2.FILLED)
            cv2.putText(image, match, (face_location[1] + 10, face_location[2] + 15), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, FONT_THICKNESS)

    cv2.imshow(filename, image)
    cv2.waitKey(0)
    # cv2.destroyWindow(filename)

