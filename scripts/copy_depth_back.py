import argparse
from os.path import join as pjoin
import os

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--dataset_path', type=str, required=True)
    parser.add_argument('--video', type=str, required=True)
    args = parser.parse_args()
    dataset_path = args.dataset_path
    video = args.video

    scan_dir = pjoin(dataset_path, video, 'scans')
    frame_list = os.listdir(scan_dir)

    frame_dir = pjoin(dataset_path, video, 'frames')
    camera_list = os.listdir(frame_dir)

    for frame_id in frame_list:
        depth_dir = pjoin(scan_dir, frame_id, 'depth_est')
        depth_map_list = os.listdir(depth_dir)
        for i, depth_map in enumerate(depth_map_list):
            cam_id = camera_list[i]
            save_dir = pjoin(frame_dir, cam_id, 'depth_est')
            os.makedirs(save_dir, exist_ok=True)
            file_name = f'mvs_depth_{frame_id}.pfm'
            os.system(f'cp {pjoin(depth_dir, depth_map)} {pjoin(save_dir, file_name)}')

