DATASET_PATH="../dataset/enerf"
IMAGE_WIDTH=1600
VIDEOS="
actor1_4
actor2_3
actor5_6
"
fps=4


for video in $VIDEOS; do
    echo "Processing video: $video"
    COLMAP_PATH="${DATASET_PATH}/${video}/example"
    ######################## COLMAP to PatchmatchNet format ######################
    python colmap_input.py --input_folder $COLMAP_PATH --convert_format

    ######################## Broadcast COLMAP results to all scenes ########################
    python scripts/colmap_broadcasting.py --video $video --dataset_path $DATASET_PATH
done