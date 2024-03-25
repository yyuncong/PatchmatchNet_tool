DATASET_PATH="../dataset/enerf"
IMAGE_WIDTH=1600
VIDEOS="
actor1_4
actor2_3
actor5_6
"
fps=4


for video in $VIDEOS; do
  python scripts/copy_depth_back.py --video $video --dataset_path $DATASET_PATH
done