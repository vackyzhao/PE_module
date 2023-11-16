def trunc_conv11(x):
    
    return x

def trunc_conv12(x):
    if x > 5000:
        x = x / 2**9
    else:
        x = x / 2**6 - x / 2**8
        
        
    return x
    