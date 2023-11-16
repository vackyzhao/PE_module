import torch
import matplotlib.pyplot as plt
import numpy as np

def get_weight(elmnt):
    true_width = len(format(int(elmnt), "b"))
    if 0 <= true_width and true_width <= 6:
        width = 1 / 2**0
    elif  6 < true_width and true_width <= 12:
        width = 1 / 2**5
    elif 12 < true_width and true_width <= 13:
        width = 1 / 2**7
    elif 13 < true_width and true_width <= 14:
        width = 1 / 2**8
    elif 14 < true_width and true_width <= 16:
        width = 1 / 2**15
    else:
        width = 0
    return width

def get_bias(elmnt):
    true_width = len(format(int(elmnt), "b"))
    if 0 <= true_width and true_width <= 6:
        bias = 0
    if  6 < true_width and true_width <= 12:
        bias = 64 - 2
    if 12 < true_width and true_width <= 13:
        bias = 128 + 32 - 2
    if 13 < true_width and true_width <= 14:
        bias = 128 + 64 -2
    if 14 < true_width and true_width <= 16:
        bias = 256 - 2
    else: 
        bias = 255
    return bias


def get_width(elmnt):
    b = format(elmnt, "b")
    b = '{:016b}'.format(elmnt)
    if int(b[3:11], 2) >= 127:
        elmnt = 127

    if elmnt <= 0:
        elmnt = 0

    if int(b[3:11], 2) < 127:
        if b[9] == 1:
            elmnt = int(b[3:1], 2) + 1
        else:
            elmnt = int(b[2:10], 2)
            
            
    return elmnt

get_width(255*255)
vis = []
for i in range(255*255):
    vis.append(get_width(i))
print(vis)
plt.plot(list(range(255*255)), vis)
plt.show()
    

class Truncate(torch.autograd.Function):
    @staticmethod
    def forward(ctx, x):
        return torch.Tensor.apply_(x, get_width)
    
    
def truncate(x):
    return Truncate.apply(x)