import tensorflow as tf

reader = tf.compat.v1.train.NewCheckpointReader("H:\\tensorflow\\flow\checkpoint\\asl_cnn.ckpt")  

variables = reader.get_variable_to_shape_map()  

for v in variables: 
    w = reader.get_tensor(v)  
    print(type(w))  
    # print(w.shape) 
    # print (w[0]) 
    print(w)