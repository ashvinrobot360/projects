import tensorflow.compat.v1 as tf

tf.disable_v2_behavior()

a = tf.constant(3.0)
b = tf.constant(4.0)

c = a * b

with tf.Session() as sess:
    File_Writer = tf.summary.FileWriter('//home//ashvin//PycharmProjects//Keras//graph', sess.graph)
    output = (sess.run(c))
    print(output)
