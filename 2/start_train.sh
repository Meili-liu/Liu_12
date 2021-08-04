#!/bin/bash

# 创建默认目录，训练过程中生成的模型文件、日志、图必须保存在这些固定目录下，训练完成后这些文件将被保存
rm -rf /project/train/models && rm -rf /project/train/models/result-graphs && rm -rf /project/train/log && \
    mkdir -p /project/train/src_repo && mkdir -p /project/train/result-graphs && mkdir -p /project/train/log && mkdir -p /project/train/models

rm -rf /project/train/src_repo/training && rm -rf /project/train/src_repo/dataset

project_root_dir=/project/train/src_repo
dataset_dir=/home/data
log_file=/project/train/log/log.txt
if [ ! -z $1 ]; then
    num_train_steps=$1
else
    num_train_steps=50
fi

pip install -i https://mirrors.aliyun.com/pypi/simple -r /project/train/src_repo/requirements.txt \
&& echo "Preparing..." \
&& cd ${project_root_dir}/tf-models/research/ && protoc object_detection/protos/*.proto --python_out=. \
&& echo "Converting dataset..." \
&& python3 -u ${project_root_dir}/convert_dataset.py ${dataset_dir} | tee -a ${log_file} \
&& echo "Start update plot..." \
&& cd ${project_root_dir} && sh -c "python3 update_plots.py &" \
&& echo "Start training..." \
&& cd ${project_root_dir} && python3 -u train.py --logtostderr --model_dir=training/ --pipeline_config_path=pre-trained-model/ssd_inception_v2_coco.config --num_train_steps ${num_train_steps} 2>&1 | tee -a ${log_file} \
&& echo "Done" \
&& echo "Exporting and saving models to /project/train/models..." \
&& python3 -u ${project_root_dir}/export_models.py | tee -a ${log_file} \
&& echo "Saving plots..." \
&& python3 -u ${project_root_dir}/save_plots.py | tee -a ${log_file}
