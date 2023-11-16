import torch
import torch.nn as nn
class ASL(nn.Module):
    def __init__(self):
        super(ASL, self).__init__()
        self.Lconv1 =    torch.nn.Conv2d(1, 4, 3, 1, 1)
        self.Lrelu1 =     torch.nn.ReLU()
        self.Lpool1 =     torch.nn.MaxPool2d(2, 2)
        self.Lconv2 =     torch.nn.Conv2d(4, 8, 3, 1, 1)
        self.Lrelu2 =     torch.nn.ReLU()
        self.Lpool2 =     torch.nn.MaxPool2d(2, 2)
        self.Lflat =     torch.nn.Flatten()
        self.Llinear =     torch.nn.Linear(384, 27)
        
    def forward(self, x):
        return self.Llinear(self.Lflat(self.Lpool2(self.Lrelu2(self.Lconv2(self.Lpool1(self.Lrelu1(self.Lconv1(x))))))))

model = ASL()
print(model.state_dict())