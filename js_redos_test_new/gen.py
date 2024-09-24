import openpyxl

# Load the workbook
workbook = openpyxl.load_workbook('instance.xlsx')

# Select the active sheet
sheet = workbook.active

instances = []

count = 0
# Iterate through each row in the sheet
for row in sheet.iter_rows(values_only=True):
  count += 1
  # print(row[-1].split('#L')[-2] if "github.com" in row[-1] else row[-1])
  # if count == 2:
  #   break
  # ('regex', 'line', 'repository', 'commitid', 'path', 'lineNumber', 'repoStars', 'output', 'GitHub URL')
  instance = {
    "regex": row[0],
    "line": row[1],
    "repository": row[2],
    "commitid": row[3],
    "path": row[4],
    "lineNumber": row[5],
    "repoStars": row[6],
    "output": row[7],
    "GitHub URL": row[8],
    "file_addr": row[-1].split('#L')[-2].replace('github.com','raw.githubusercontent.com').replace('/blob','') if "github.com" in row[-1] else row[-1]
  }
  instances.append(instance)


# Close the workbook
workbook.close()

# 读取"sucessful0910/succeed1"下所有文件夹名
import os
import re
import requests
import shutil
import json

def download_file(url, destination):
  
  response = requests.get(url)
  
  if response.status_code == 200:
    with open(destination, 'wb') as file:
      file.write(response.content)
    print(f"File downloaded successfully to {destination}")
  else:
    print("Failed to download file")

# # Example usage:
# url = "https://example.com/file.xlsx"
# destination = "path/to/save/file.xlsx"
# download_file(url, destination)

for root, dirs, files in os.walk(".\instances"):
  if len(root.split("\\")) > 2:
    continue
  for dir in dirs:
    # print(root + "\t" + dir)
    # 如果存在raw文件夹则删除
    if os.path.exists(os.path.join(root, dir, 'raw')):
      shutil.rmtree(os.path.join(root, dir, 'raw'))
    os.makedirs(os.path.join(root, dir, 'raw'))
    # 将文件夹对应的信息写入info.json文件
    with open(os.path.join(root, dir, 'info.json'), 'w') as f:
      # f.write(str(instances[int(dir)]))
      json.dump(instances[int(dir)-1], f)
    # 下载文件
    url = instances[int(dir)-1]["file_addr"]
    destination = os.path.join(root, dir, 'raw', url.split("/")[-1])
    download_file(url, destination)
    print(url, destination)
    

    
