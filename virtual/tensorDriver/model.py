import tensorflow as tf
import model_util as util

def build_graph_placeholder():
    # Create placeholders (I/O for our model/graph)
    x = tf.placeholder(tf.float32, shape=[None, 66, 200, 3], name='IMAGE_IN')
    y_ = tf.placeholder(tf.float32, shape=[None, 1], name='LABEL_IN')
    dropout_prob = tf.placeholder(tf.float32, name='drop_prob')

    x_image = x

    # Add input image/steering angle on summary
    tf.summary.image("input_image", x_image, 10)
    tf.summary.histogram("steer_angle", y_)

    # CONV 1 (Mark that want visualization)
    conv1 = util.conv2d(x_image, 5, 5, 3, 24, 2, "conv1", True)

    # CONV 2
    conv2 = util.conv2d(conv1, 5, 5, 24, 36, 2, "conv2")

    # CONV 3
    conv3 = util.conv2d(conv2, 5, 5, 36, 48, 2, "conv3")

    # CONV 4
    conv4 = util.conv2d(conv3, 3, 3, 48, 64, 1, "conv4")

    # CONV 5
    conv5 = util.conv2d(conv4, 3, 3, 64, 64, 1, "conv5")

    # Fully Connect 1
    # Needs calculation... (-1 means any batch size)
    conv5_flat = tf.reshape(conv5, [-1, 1152])
    fc1 = util.fc_layer(conv5_flat, 1152, 1164, "fc1")
    # Add dropout to the fully connected layer
    fc1_drop = tf.nn.dropout(fc1, dropout_prob)

    # Fully Connect 2
    fc2 = util.fc_layer(fc1_drop, 1164, 100, "fc2")
    # Add dropout to the fully connected layer
    fc2_drop = tf.nn.dropout(fc2, dropout_prob)

    # Fully Connect 3
    fc3 = util.fc_layer(fc2_drop, 100, 50, "fc3")
    # Add dropout to the fully connected layer
    fc3_drop = tf.nn.dropout(fc3, dropout_prob)

    # Fully Connect 4
    fc4 = util.fc_layer(fc3_drop, 50, 10, "fc4")
    # Add dropout to the fully connected layer
    fc4_drop = tf.nn.dropout(fc4, dropout_prob)

    # Output
    y = util.output_layer(fc4_drop, 10, 1, "output_layer")

    return x, y, y_, dropout_prob


def build_graph_no_placeholder(input):
    dropout_prob = tf.placeholder(tf.float32, name='drop_prob')

    # Add input image/steering angle on summary
    tf.summary.image("input_image", input, 10)

    # CONV 1 (Mark that want visualization)
    conv1 = util.conv2d(input, 5, 5, 3, 24, 2, "conv1", True)

    # CONV 2
    conv2 = util.conv2d(conv1, 5, 5, 24, 36, 2, "conv2")

    # CONV 3
    conv3 = util.conv2d(conv2, 5, 5, 36, 48, 2, "conv3")

    # CONV 4
    conv4 = util.conv2d(conv3, 3, 3, 48, 64, 1, "conv4")

    # CONV 5
    conv5 = util.conv2d(conv4, 3, 3, 64, 64, 1, "conv5")

    # Fully Connect 1
    # Needs calculation... (-1 means any batch size)
    conv5_flat = tf.reshape(conv5, [-1, 1152])
    fc1 = util.fc_layer(conv5_flat, 1152, 1164, "fc1")
    # Add dropout to the fully connected layer
    fc1_drop = tf.nn.dropout(fc1, dropout_prob)

    # Fully Connect 2
    fc2 = util.fc_layer(fc1_drop, 1164, 100, "fc2")
    # Add dropout to the fully connected layer
    fc2_drop = tf.nn.dropout(fc2, dropout_prob)

    # Fully Connect 3
    fc3 = util.fc_layer(fc2_drop, 100, 50, "fc3")
    # Add dropout to the fully connected layer
    fc3_drop = tf.nn.dropout(fc3, dropout_prob)

    # Fully Connect 4
    fc4 = util.fc_layer(fc3_drop, 50, 10, "fc4")
    # Add dropout to the fully connected layer
    fc4_drop = tf.nn.dropout(fc4, dropout_prob)

    # Output
    y = util.output_layer(fc4_drop, 10, 1, "output_layer")

    return y, dropout_prob

