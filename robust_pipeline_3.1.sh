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
    COLMAP_PATH="${DATASET_PATH}/${video}/example"
    ######################## COLMAP to PatchmatchNet format ######################
    python colmap_input.py --input_folder $COLMAP_PATH --convert_format

    ######################## Broadcast COLMAP results to all scenes ########################
    python scripts/colmap_broadcasting.py --video $video --dataset_path $DATASET_PATH
done