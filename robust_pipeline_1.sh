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

######################## Videos to Frames ########################
bash scripts/dynerf_frame_extraction.sh -d $DATASET_PATH -w $IMAGE_WIDTH -f $fps

for video in $VIDEOS; do
    ######################## Frames to Scenes Format ########################
    python scripts/scene_frames_preparing.py --video $video --dataset_path $DATASET_PATH

    ######################## Pick a scene as an example for COLMAP ########################
    python scripts/example_scene_preparing.py --video $video --dataset_path $DATASET_PATH

done