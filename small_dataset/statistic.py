import json

# 读取 JSON 文件
with open("./vulnerabilities.json", "r") as f:
    json_data = f.read()

# 解析 JSON 数据为 Python 对象
list_data = json.loads(json_data)

# 使用 len() 函数获取列表元素数量
num_elements = len(list_data)

print("JSON 文件中包含 {} 个元素。".format(num_elements))

# 统计 "name" 标签的数量
tag_name = "vulnerabilities"
tag_category = "category"
tag_value = "gasless_send"
count = 0
for item in list_data:
    for sub_item in item[tag_name]:
        if sub_item[tag_category] == tag_value:
            count +=1

print("JSON 数组中包含 {} 个元素具有标签 {}。".format(count, tag_name))