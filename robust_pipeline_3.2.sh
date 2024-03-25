DATASET_PATH="../dataset/enerf"
IMAGE_WIDTH=1600
VIDEOS="
actor1_4
actor2_3
actor5_6
"
fps=4


for video in $VIDEOS; do
    ######################## Scene to Depth ########################
    num_views=$(ls $DATASET_PATH/$video/frames/cam* | wc -l)
    for scene in $(ls $DATASET_PATH/$video/scans); do
        SCENE_PATH="${DATASET_PATH}/${video}/scans/${scene}"
        CHECKPOINT_FILE="./checkpoints/params_000007.ckpt"
        image_max_dim=$IMAGE_WIDTH
        DYNERF_TESTING=$SCENE_PATH

        # skip the already estimated scene
        # remove if necessary
        DEPTH_PATH="${SCENE_PATH}/depth_est"
        CONFIDENCE_PATH="${SCENE_PATH}/confidence"
        # if these two paths exist
        if [ -d $DEPTH_PATH ] && [ -d $CONFIDENCE_PATH ]; then
            n_depth=$(ls $DEPTH_PATH | wc -l)
            n_confidence=$(ls $CONFIDENCE_PATH | wc -l)
            # if the number of depth maps and confidence maps all equals to the number of views
            if [ $n_depth -eq $num_views ] && [ $n_confidence -eq $num_views ]; then
              echo "Depth and confidence maps already exist: $SCENE_PATH"
              continue
            fi
        fi

        python eval.py --input_folder=$DYNERF_TESTING --output_folder=$DYNERF_TESTING --output_type depth \
        --checkpoint_path $CHECKPOINT_FILE --num_views $num_views --image_max_dim $image_max_dim --geo_mask_thres 3 --photo_thres 0.8 "$@"
    done
done