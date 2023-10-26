
from multiprocessing.pool import ThreadPool
import os

import numpy as np
import torch
import tqdm
from transformers import AutoModel, AutoTokenizer

def average_pool(last_hidden_states, attention_mask):
    last_hidden = last_hidden_states.masked_fill(~attention_mask[..., None].bool(), 0.0)
    return last_hidden.sum(dim=1) / attention_mask.sum(dim=1)[..., None]

if __name__ == '__main__':

  # devices
  os.environ["CUDA_VISIBLE_DEVICES"] = "0,1,2,3"
  devices = [torch.device(f'cuda:{i}') for i in range(torch.cuda.device_count())]

  # hugging face
  tokenizer = AutoTokenizer.from_pretrained('intfloat/multilingual-e5-large')
  models = [
    AutoModel.from_pretrained('intfloat/multilingual-e5-large').eval().to(device) 
    for device in devices
  ]

  # data
  text = ["hello", "world", "let's", "parallelize", "some", "inference", "code", "hope this works"]
  loader = DataLoader(text, batch_size=2, shuffle=False)
  
  outputs = []
  for batch in tqdm.tqdm(loader):
    # np split into equal pieces
    batch_parallel = np.array_split(batch, len(devices))
    # tokenize
    batch_parallel = [
      tokenizer(x, padding=True, truncation=True, return_tensors='pt').to(device)
      for x, device in zip(batch_parallel, devices)
    ]
    # forward pass with ThreadPool
      def forward_pass(model, x):
        with torch.no_grad():
          outputs = model(**batch)
          outputs = average_pool(
              outputs.last_hidden_state, batch['attention_mask']
          ).cpu()
        # clear cache
        torch.cuda.empty_cache()
        return outputs
  
      with ThreadPool(len(devices)) as pool:
          batch = pool.starmap(forward_pass, zip(models, batch))
  
      # to cpu and concat
      batch = torch.cat(batch)
      embeddings.append(batch)
  
  # concat all batches
  embeddings = torch.cat(embeddings)
  # save embeddings
  torch.save(embeddings, f'data/{name}_embeddings_e5.pt')
