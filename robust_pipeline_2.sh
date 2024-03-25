DATASET_PATH="../dataset/enerf"
IMAGE_WIDTH=1600
VIDEOS="
actor1_4
actor2_3
actor5_6
"
fps=4




for video in $VIDEOS; do





    COLMAP_PATH="${DATASET_PATH}/${video}/example"
    bash scripts/colmap_preprocessing.sh -d $COLMAP_PATH -w $IMAGE_WIDTH
done