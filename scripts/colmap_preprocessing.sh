

while getopts "d:w:" opt; do
    case $opt in
        d)
            directory=$OPTARG
            ;;
        w)
            width=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done
colmap feature_extractor \
--database_path $directory/database.db \
--image_path $directory/images

colmap exhaustive_matcher \
--database_path $directory/database.db

mkdir $directory/sparse

colmap mapper \
--database_path $directory/database.db \
--image_path $directory/images \
--output_path $directory/sparse

mkdir $directory/dense

colmap image_undistorter \
--image_path $directory/images \
--input_path $directory/sparse/0 \
--output_path $directory/dense \
--output_type COLMAP \
--max_image_size $width