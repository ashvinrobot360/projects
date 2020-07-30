import tensorflow as tf
import numpy as np
from tensorflow.keras.utils import to_categorical
import matplotlib.pyplot as plt

(train_images, train_labels), (test_images, test_labels) = tf.keras.datasets.mnist.load_data()

print(train_images.shape)
print(test_images.shape)

train_images = train_images.reshape(60000, 784).astype('float32') / 255
print(train_labels[0])

train_labels = to_categorical(train_labels, num_classes=10)
print(train_labels[0])
model = tf.keras.Sequential()
model.add(tf.keras.layers.Dense(512, activation=tf.nn.relu, input_shape=(784,)))
model.add(tf.keras.layers.Dense(10, activation=tf.nn.softmax))

model.compile(loss='categorical_crossentropy', optimizer='rmsprop', metrics=['accuracy'])

model.fit(train_images, train_labels, epochs=5)
model.save('~/PycharmProjects/Keras/model')
