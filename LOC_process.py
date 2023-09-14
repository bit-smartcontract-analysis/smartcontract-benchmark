import os

dir_path = './safecontract'

results = {}

if os.path.exists(dir_path):
    for filename in os.listdir(dir_path):
        if filename.endswith('.sol'):
            file_path = os.path.join(dir_path, filename)
            lines_of_code = 0
            metadata = {}

            with open(file_path, 'r') as f:
                in_comment_block = False
                for line in f:
                    line = line.strip()
                    
                    if line.startswith("/*"):
                        in_comment_block = True
                    if in_comment_block and "*/" in line:
                        in_comment_block = False
                        continue
                    if in_comment_block:
                        continue
                    
                    if line.startswith("//") or len(line) == 0:
                        continue

                    lines_of_code += 1

                    if line.startswith("* @"):
                        key, value = line[3:].split(":", 1)
                        metadata[key.strip()] = value.strip()

            results[filename] = {'lines_of_code': lines_of_code, 'metadata': metadata}
else:
    results = "Directory not found."

total_lines_of_code = 0
for filename, data in results.items():
    total_lines_of_code += data['lines_of_code']


print(results)
print(total_lines_of_code)
