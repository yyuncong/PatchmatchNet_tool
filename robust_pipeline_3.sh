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

    ######################## Scene to Depth ########################
    num_views=$(ls $DATASET_PATH/$video/cam*.mp4 | wc -l)
    for scene in $(ls $DATASET_PATH/$video/scans); do
        SCENE_PATH="${DATASET_PATH}/${video}/scans/${scene}"
        CHECKPOINT_FILE="./checkpoints/params_000007.ckpt"
        image_max_dim=$IMAGE_WIDTH
        DYNERF_TESTING=$SCENE_PATH
        python eval.py --input_folder=$DYNERF_TESTING --output_folder=$DYNERF_TESTING --output_type depth \
        --checkpoint_path $CHECKPOINT_FILE --num_views $num_views --image_max_dim $image_max_dim --geo_mask_thres 3 --photo_thres 0.8 "$@"
    done
done