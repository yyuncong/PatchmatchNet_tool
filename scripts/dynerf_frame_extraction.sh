

while getopts "d:w:f:" opt; do
    case $opt in
        d)
            directory=$OPTARG
            ;;
        w)
            width=$OPTARG
            ;;
        f)
            fps=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
# directory="/home/yuncong/dynamic_scene/dynerf"
# List all folders in the directory
# only list directories
folders=$(find $directory -maxdepth 1 -mindepth 1 -type d)

# Iterate through each folder
for folder in $folders; do
    prefix=""
    cams=$(find "$folder/$prefix" -type f -name "cam*.mp4")
    for cam in $cams; do
        echo "Processing $cam"
        # Extract the camera number
        cam_num=$(echo $cam | grep -oE "cam[0-9]+" | grep -oE "[0-9]+")
        output_dir="$folder/frames/cam$cam_num/"
        mkdir -p $output_dir
        # Extract the frames
        ffmpeg -i $cam -vf "scale=$width:-1,fps=$fps" $output_dir/frame%04d.jpg
    done
done