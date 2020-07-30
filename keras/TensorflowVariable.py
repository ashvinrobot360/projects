import tensorflow.compat.v1 as tf

tf.disable_v2_behavior()

a = tf.placeholder(tf.float32)
b = tf.placeholder(tf.float32)

adderNode = a + b

sess = tf.Session()

print(sess.run(adderNode, {a: [1, 3], b: [2, 4]}))

