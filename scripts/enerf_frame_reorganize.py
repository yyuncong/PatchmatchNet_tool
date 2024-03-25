import os
from os.path import join as pjoin
import glob
import argparse
from PIL import Image

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset_path', type=str, required=True)
    parser.add_argument('--video', type=str, required=True)
    parser.add_argument('--skip_frame', type=int, default=80)
    args = parser.parse_args()
    dataset_path = args.dataset_path
    video = args.video
    skip_frame = args.skip_frame

    # copy original images to frames
    old_frame_path = pjoin(dataset_path, video, 'images')
    cam_idx_list = os.listdir(old_frame_path)
    new_frame_path = pjoin(dataset_path, video, 'frames')
    for cam_idx in cam_idx_list:
        img_dir = pjoin(old_frame_path, cam_idx)
        all_imgs = os.listdir(img_dir)
        new_cam_dir = pjoin(new_frame_path, f'cam{cam_idx}')
        os.makedirs(new_cam_dir, exist_ok=True)

        frame_count = 1
        for i, img_filename in enumerate(all_imgs):
            if i % skip_frame != 0:
                continue
            new_filename = f'frame{frame_count:04d}.jpg'
            new_save_path = pjoin(new_cam_dir, new_filename)
            old_path = pjoin(old_frame_path, cam_idx, img_filename)
            os.system(f'cp {old_path} {new_save_path}')
            frame_count += 1

            # sanity check
            try:
                img = Image.open(old_frame_path)
            except Exception as e:
                print(e)
                print(f'Error in {old_frame_path}')

        print(f'{cam_idx} selected {frame_count-1} frames')

    # copy frames to scans
    video_path = pjoin(dataset_path, video, 'frames')
    scans_dir = pjoin(dataset_path, video, 'scans')
    os.makedirs(scans_dir, exist_ok=True)

    # Get the list of cam*.mp4 files in the directory
    frame_folders = glob.glob(f'{video_path}/cam*')
    # Get the number of cam*.mp4 files
    num_folders = len(frame_folders)
    print(f"Number of cam* folders in {video_path}: {num_folders}")

    frame_folders.sort(key=lambda x: int(x.split('/')[-1][-2:]))

    frame_names = glob.glob(f'{frame_folders[0]}/*.jpg')
    frame_names = [frame.split('/')[-1].split('.')[0] for frame in frame_names]
    frame_names.sort(key=lambda x: int(x[-4:]))
    num_frames = len(frame_names)

    for i in range(num_frames):
        os.makedirs(f'{scans_dir}/{frame_names[i]}', exist_ok=True)
        images_folder = f'{scans_dir}/{frame_names[i]}/images'
        os.makedirs(images_folder, exist_ok=True)
        # os.system(f'cp -r {cam_poses_dir} {scans_dir}/{frame_names[i]}')

        for j in range(num_folders):
            frame_folder = frame_folders[j]
            frame_name = frame_names[i]
            frame_file = f'{frame_folder}/{frame_name}.jpg'
            new_frame_file = f'{images_folder}/{j:08d}.jpg'
            os.system(f'cp {frame_file} {new_frame_file}')
