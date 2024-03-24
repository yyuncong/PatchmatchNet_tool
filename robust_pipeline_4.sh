DATASET_PATH="../dataset/neural_3d_video"
IMAGE_WIDTH=1600
VIDEOS="
coffee_martini
sear_steak
cook_spinach
cut_roasted_beef
flame_salmon_1
flame_steak
"
fps=4


for video in $VIDEOS; do
  python scripts/copy_depth_back.py --video $video --dataset_path $DATASET_PATH
done