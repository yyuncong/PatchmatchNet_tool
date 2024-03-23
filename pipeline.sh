######################## Video to frames ########################
# This process all videos
directory="/home/yuncong/dynamic_scene/dynerf"

# # List all folders in the directory
# # only list directories
# folders=$(find $directory -maxdepth 1 -mindepth 1 -type d)

# # Iterate through each folder
# for folder in $folders; do
#     prefix=""
#     cams=$(find "$folder/$prefix" -type f -name "cam*.mp4")
#     for cam in $cams; do
#         echo "Processing $cam"
#         # Extract the camera number
#         cam_num=$(echo $cam | grep -oE "cam[0-9]+" | grep -oE "[0-9]+")
#         output_dir="$folder/frames/cam$cam_num/"
#         mkdir -p $output_dir
#         # Extract the frames
#         ffmpeg -i $cam -vf fps=4 $output_dir/frame%04d.jpg
#     done
# done

######################## Frames to Scenes Frames ########################

# work on a specific video
video="sear_steak"
# python scene_frames_preparing.py --video $video

######################## Frames to COLMAP ########################

# work on a specific scene (timestep) in the video
timestep="0003"
DATASET_PATH="${directory}/${video}/scans/frame${timestep}"

colmap feature_extractor \
--database_path $DATASET_PATH/database.db \
--image_path $DATASET_PATH/images

colmap exhaustive_matcher \
--database_path $DATASET_PATH/database.db

mkdir $DATASET_PATH/sparse

colmap mapper \
--database_path $DATASET_PATH/database.db \
--image_path $DATASET_PATH/images \
--output_path $DATASET_PATH/sparse

mkdir $DATASET_PATH/dense

colmap image_undistorter \
--image_path $DATASET_PATH/images \
--input_path $DATASET_PATH/sparse/0 \
--output_path $DATASET_PATH/dense \
--output_type COLMAP \
--max_image_size 512

######################## COLMAP to PatchmatchNet ######################
python colmap_input.py --input_folder $DATASET_PATH --convert_format

######################## COLMAP to Depth ########################
CHECKPOINT_FILE="./checkpoints/params_000007.ckpt"
num_views=21
image_max_dim=512

DYNERF_TESTING=$DATASET_PATH
python eval.py --input_folder=$DYNERF_TESTING --output_folder=$DYNERF_TESTING --output_type depth \
--checkpoint_path $CHECKPOINT_FILE --num_views $num_views --image_max_dim $image_max_dim --geo_mask_thres 3 --photo_thres 0.8 "$@"