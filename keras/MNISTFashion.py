from tensorflow.keras.datasets import fashion_mnist
import matplotlib.pyplot as plt
from tensorflow import keras
from tensorflow.keras.layers import Conv2D, MaxPooling2D, Dense, Flatten, Activation
from tensorflow.keras import backend as K
from kerastuner import RandomSearch
import time
from tensorflow.keras.utils import to_categorical

from kerastuner.engine.hyperparameters import HyperParameters


LOG_DIR = f"{int(time.time())}"

(x_train, y_train), (x_test, y_test) = fashion_mnist.load_data()
#
print(y_train[0])
print(y_train.shape)
#
if K.image_data_format() == 'channels_first':
    input_shape = (1, x_train.shape[0], 28, 28)
    input_shap2 = (1, x_test.shape[0], 28, 28)
else:
    input_shape = (x_train.shape[0], 28, 28, 1)
    input_shap2 = (x_test.shape[0], 28, 28, 1)

# y_train = to_categorical(y_train,10)
# y_test = to_categorical(y_test,10)
print(y_train[0])

# plt.imshow(x_train[0], cmap='gray')
# plt.show()

x_train = x_train.reshape(input_shape)
x_test = x_test.reshape(input_shap2)


def build_model(hp):
    model = keras.models.Sequential()

    model.add(Conv2D(hp.Int("input_units", min_value=32, max_value=256, step=32), (3, 3), input_shape=(28, 28, 1)))
    model.add(Activation('relu'))
    model.add(MaxPooling2D(pool_size=(2, 2)))

    for i in range(hp.Int("n_layers", 1, 4)):
        model.add(Conv2D(hp.Int(f"conv_{i}_units", min_value=32, max_value=256, step=32), (3, 3)))
        model.add(Activation('relu'))
        # model.add(MaxPooling2D(pool_size=(2, 2)))

    model.add(Flatten())  # this converts our 3D feature maps to 1D feature vectors

    model.add(Dense(10))
    model.add(Activation("softmax"))

    model.compile(optimizer="adam",
                  loss="sparse_categorical_crossentropy",
                  metrics=["accuracy"])
    return model

# model=build_model()
# model.fit(x_train, y_train, batch_size=64, epochs=8, validation_data = (x_test, y_test))

tuner = RandomSearch(
    build_model,
    objective="val_accuracy",
    max_trials=1,
    executions_per_trial=1,
    directory=LOG_DIR
)

tuner.search(
    x=x_train,
    y=y_train,
    epochs=1,
    batch_size=64,
    validation_data=(x_test,y_test)
)