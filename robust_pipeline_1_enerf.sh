DATASET_PATH="../dataset/enerf"
IMAGE_WIDTH=1600
VIDEOS="
actor1_4
actor2_3
actor5_6
"
skip_frame=20

for video in $VIDEOS; do
    ######################## Frames to Scenes Format ########################
    python scripts/enerf_frame_reorganize.py --video $video --dataset_path $DATASET_PATH --skip_frame $skip_frame

    ######################## Pick a scene as an example for COLMAP ########################
    python scripts/example_scene_preparing.py --video $video --dataset_path $DATASET_PATH

done