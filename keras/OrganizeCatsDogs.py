# https://www.kaggle.com/c/dogs-vs-cats/data?select=test1.zipv

import os, shutil

try:
    os.mkdir("/home/ashvin/Downloads/train/cats")
    os.mkdir("/home/ashvin/Downloads/train/dogs")
except OSError:
    pass

for file in os.listdir("/home/ashvin/Downloads/train"):
    print(file)
    if "cat" in file:
        shutil.move("/home/ashvin/Downloads/train/" + file, "/home/ashvin/Downloads/train/cats")
    else:
        shutil.move("/home/ashvin/Downloads/train/" + file, "/home/ashvin/Downloads/train/dogs")

