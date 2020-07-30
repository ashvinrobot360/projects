from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Conv2D, MaxPooling2D
from tensorflow.keras.layers import Activation, Dropout, Flatten, Dense
from tensorflow.keras import backend as K
import numpy as np
from tensorflow.keras.preprocessing import image
import tensorflow as tf
from matplotlib import pyplot as plt
img_width, img_height = 150, 150

train_data_dir = '/home/ashvin/Downloads/train'
validation_data_dir = '/home/ashvin/Downloads/test1'

nb_train_samples = 1000
nb_validation_samples = 100
epochs = 50
batch_size = 20

if K.image_data_format() == 'channels_first':
    input_shape = (3, img_width, img_height)
else:
    input_shape = (img_width, img_height, 3)

train_datagen = ImageDataGenerator(
    rescale=1. / 255,
    shear_range=0.2,
    zoom_range=0.2,
    horizontal_flip=True
)
test_datagen = ImageDataGenerator(
    rescale=1. / 255,
)

train_generator = train_datagen.flow_from_directory(
    train_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode='binary'
)

validation_generator = test_datagen.flow_from_directory(
    validation_data_dir,
    target_size=(img_width, img_height),
    batch_size=batch_size,
    class_mode='binary'
)

# model = Sequential()
# model.add(Conv2D(32, (3, 3), input_shape=input_shape, activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(64, (3, 3), input_shape=input_shape, activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
# model.add(Conv2D(64, (3, 3), input_shape=input_shape, activation='relu'))
# model.add(MaxPooling2D(pool_size=(2,2)))
#
# model.add(Flatten())
# model.add(Dense(64, activation='relu'))
# model.add(Dense(1, activation='sigmoid'))
#
# model.compile(loss='binary_crossentropy', optimizer='rmsprop', metrics=['accuracy'])
#
# model.fit_generator(
#     train_generator,
#     steps_per_epoch=nb_train_samples // batch_size,
#     epochs=epochs,
#     validation_data=validation_generator,
#     validation_steps=nb_validation_samples // batch_size
# )
#
# model.save('first_try.h5')

model = tf.keras.models.load_model('first_try.h5')
img_pred = image.load_img('/home/ashvin/Downloads/test1/156.jpg', target_size=(150,150))
plt.imshow(img_pred)
plt.show()
img_pred = image.img_to_array(img_pred)
img_pred = np.expand_dims(img_pred, axis=0)


result = model.predict(img_pred)
print(result)

if result[0][0] == 1:
    print("dog")
else:
    print("cat")