import tensorflow as tf
import numpy as np
from tensorflow.keras.utils import to_categorical
import time
import matplotlib.pyplot as plt

(train_images, train_labels), (test_images, test_labels) = tf.keras.datasets.mnist.load_data()

model = tf.keras.models.load_model('~/PycharmProjects/Keras/model')

test_images = test_images.reshape(10000, 784).astype('float32') / 255
test_labels = to_categorical(test_labels, num_classes=10)

test_loss, test_acc = model.evaluate(test_images, test_labels)
print('Accuracy', test_acc)

_, (test1, test2) = tf.keras.datasets.mnist.load_data()

image = 0
plt.imshow(test1[0], cmap=plt.cm.binary)
plt.show()
scores = model.predict(test_images[0:1])
print(np.argmax(scores))

