import torch
import torch.nn as nn
import torch.nn.functional as F
from torch.profiler import profile, ProfilerActivity

class CNN(nn.Module):
    def __init__(self):
        super(CNN, self).__init__()
        self.conv1 = nn.Conv2d(1, 10, kernel_size=5)
        self.conv2 = nn.Conv2d(10, 20, kernel_size=5)
        self.fc1 = nn.Linear(320, 50)
        self.fc2 = nn.Linear(50, 10)
    
    def forward(self, x):
        x = F.relu(self.conv1(x))
        x = F.max_pool2d(x,2)
        x = F.relu(self.conv2(x))
        x = F.max_pool2d(x,2)
        x = x.view(-1, 320)
        x = F.relu(self.fc1(x))
        x = self.fc2(x)
        return F.log_softmax(x, dim=1)

def main():

    model = CNN().cuda()
    data = (torch.randn(6400, 1, 28, 28), torch.randint(0, 10, (6400,)))

    optimizer = torch.optim.Adam(model.parameters(), lr=0.01)

    with profile(activities=[ProfilerActivity.CPU, ProfilerActivity.CUDA], record_shapes=True) as prof:
        
        for i in range(100):
            img, label = data[0][i*64:(i+1)*64], data[1][i*64:(i+1)*64]
            output = model(img.cuda())
            loss = F.nll_loss(output, label.cuda())
            loss.backward()
            optimizer.step()
    
    print(prof.key_averages().table(sort_by="cuda_time_total", row_limit=10))

    print(prof.key_averages().table(sort_by="cpu_time_total", row_limit=10))


if __name__ == '__main__':
    main()
  
