
def train_CNN(train_directory, target_size=(200, 200), classes=None, batch_size=16, num_epochs=20, num_classes=5, verbose=0):
    """
    Trains a conv net for the flowers dataset with a 5-class classifiction output
    Also provides suitable arguments for extending it to other similar apps

    Arguments:
            train_directory: The directory where the training images are stored in separate folders.
                            These folders should be named as per the classes.
            target_size: Target size for the training images. A tuple e.g. (200,200)
            classes: A Python list with the classes
            batch_size: Batch size for training
            num_epochs: Number of epochs for training
            num_classes: Number of output classes to consider
            verbose: Verbosity level of the training, passed on to the `fit_generator` method
    Returns:
            A trained conv net model

    """
    from tensorflow.keras.preprocessing.image import ImageDataGenerator
    import tensorflow as tf
    from tensorflow.keras.optimizers import RMSprop

    # ImageDataGenerator object instance with scaling
    train_datagen = ImageDataGenerator(rescale=1 / 255)

    # Flow training images in batches using the generator
    train_generator = train_datagen.flow_from_directory(
        train_directory,  # This is the source directory for training images
        target_size=target_size,  # All images will be resized to 200 x 200
        batch_size=batch_size,
        # Specify the classes explicitly
        classes=classes,
        # Since we use categorical_crossentropy loss, we need categorical labels
        class_mode='categorical')

    input_shape = tuple(list(target_size) + [3])

    # Model architecture
    model = tf.keras.models.Sequential([
        # Note the input shape is the desired size of the image 200x 200 with 3 bytes color
        # The first convolution
        tf.keras.layers.Conv2D(16, (3, 3), activation='relu', input_shape=input_shape),
        tf.keras.layers.MaxPooling2D(2, 2),
        # The second convolution
        tf.keras.layers.Conv2D(32, (3, 3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        # The third convolution
        tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        # The fourth convolution
        tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        # The fifth convolution
        tf.keras.layers.Conv2D(64, (3, 3), activation='relu'),
        tf.keras.layers.MaxPooling2D(2, 2),
        # Flatten the results to feed into a dense layer
        tf.keras.layers.Flatten(),
        # 512 neuron in the fully-connected layer
        tf.keras.layers.Dense(512, activation='relu'),
        # 5 output neurons for 5 classes with the softmax activation
        tf.keras.layers.Dense(num_classes, activation='softmax')
    ])

    # Optimizer and compilation
    model.compile(loss='categorical_crossentropy',
                  optimizer=RMSprop(lr=0.001),
                  metrics=['acc'])

    # Total sample count
    total_sample = train_generator.n

    # Training
    model.fit_generator(
        train_generator,
        steps_per_epoch=int(total_sample / batch_size),
        epochs=num_epochs,
        verbose=verbose)

    return model

train_dir = "/home/ashvin/Desktop/KerasImages/Family/family_photos"
trained_model=train_CNN(train_directory=train_dir,classes=['Ashvin', 'Paapu', 'Kumaran', 'Veni'], num_epochs=60,num_classes=4,verbose=1)
trained_model.save("~/PycharmProjects/Keras/family_model")