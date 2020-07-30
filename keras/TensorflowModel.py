import tensorflow.compat.v1 as tf

tf.disable_v2_behavior()

W = tf.Variable([.3], tf.float32)
b = tf.Variable([-.3], tf.float32)

x = tf.placeholder(tf.float32)

linear_model = W * x + b
y = tf.placeholder(tf.float32)

# Loss
squared_delta = tf.square(linear_model - y)
loss = tf.reduce_sum(squared_delta)

# Optimize
optimizer = tf.train.GradientDescentOptimizer(0.01)
train = optimizer.minimize(loss)

init = tf.global_variables_initializer()

sess = tf.Session()

sess.run(init)

for i in range(9999):
    sess.run(train, {x: [1, 2, 3, 4], y: [0, -1, -2, -3]})

print(sess.run([W, b]))
