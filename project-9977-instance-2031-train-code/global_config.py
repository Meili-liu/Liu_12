import sys
import os
import pathlib

project_root = '/project/train/src_repo'
sys.path.append(os.path.join(project_root, 'tf-models/research'))
sys.path.append(os.path.join(project_root, 'tf-models/research/slim'))

label_id_map = {}
try:
    with open(os.path.join(pathlib.Path(os.path.abspath(__file__)).parent.as_posix(), 'label.txt'), 'r') as f:
        id = 1
        for line in f.readlines():
            line = line.strip()
            if not line:
                continue
            label_id_map[line] = id
            id += 1
except Exception as e:
    print(f'Failed to read /project/train/src_reop/label.txt')