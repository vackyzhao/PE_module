
from __future__ import division
import json

def write_blob_info(p_file, inputs, input_shape):
	print(len(input_shape))
	p_file.write(str(inputs) + ', ')
	p_file.write(str(3) + ', ')
	for i in range(len(input_shape)):
		p_file.write(str(input_shape[i]) + ",")
	# p_file.write(str(input_shape[3]) + ', ')
	# p_file.write(str(input_shape[1]) + ', ')
	# p_file.write(str(input_shape[2]) + ', ')

with open("asl_model_quant_new.json",'r') as f:
	load_dict = json.load(f)


print(load_dict.keys())


param_file=open("asl_model_quant.proto",'w')

tensors = load_dict["subgraphs"][0]["tensors"]
operators = load_dict["subgraphs"][0]["operators"]
inputs = load_dict["subgraphs"][0]["inputs"]
input_shape = tensors[inputs[0]]["shape"]




print(tensors)
print(operators)
print(inputs)
print(input_shape)



param_file.write(str(len(operators) + 1) + ',\n')
write_blob_info(param_file, \
				inputs[0], \
				input_shape)
param_file.write('\n')

for layer in operators:
    try:
        layer_name = layer["builtin_options_type"]
    except:
        continue
    operators_inputs  = layer["inputs"]
    input_len = len(operators_inputs)
    builtin_options = layer["builtin_options"]
	
    if layer_name == "Conv2DOptions":	#conv_2d, depthwiseconv_2d
        input_shape  = tensors[operators_inputs[0]]["shape"]
        kernel_shape = tensors[operators_inputs[1]]["shape"]
        bias_shape   = tensors[operators_inputs[2]]["shape"]
        kernel_H = kernel_shape[1]
        kernel_W = kernel_shape[2]
        param_file.write(str(kernel_H) + ', ')
        param_file.write(str(kernel_W) + ', ')
        stride_H = builtin_options["stride_h"]
        stride_W = builtin_options["stride_w"]
        param_file.write(str(stride_H) + ', ')
        param_file.write(str(stride_W) + ', ')
        try:		
            dilation_W = builtin_options["dilation_w_factor"]
            dilation_H = builtin_options["dilation_h_factor"]
        except:
            continue
        param_file.write(str(dilation_H) + ', ')
        param_file.write(str(dilation_W) + ', ')
        bias_term = 1
        if input_len  < 3 or bias_shape[0] == 0:
            bias_term = 0
        param_file.write(str(bias_term) + ', ')
        bottom_zero_point = tensors[operators_inputs[0]]["quantization"]["zero_point"][0]
        param_file.write(str(bottom_zero_point) + ', ')
        write_blob_info(param_file, \
                operators_inputs[0], \
                input_shape)	
	#output_blob
    operators_outputs = layer["outputs"]
    output_shape = tensors[operators_outputs[0]]["shape"]
    write_blob_info(param_file, \
            operators_outputs[0], \
            output_shape)
    param_file.write('\n')


