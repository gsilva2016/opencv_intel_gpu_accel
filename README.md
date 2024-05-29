Enable hardware accelerated GPU in OpenCV for Intel platforms.

## Build Docker Image
```
docker build -t opencv-gpu --progress plain .
```


## Run Docker Container

Download an AVC video in the current directory and call it: sample-video.mp4

Start the container via: 

```
docker run --rm --user root -e DISPLAY=$DISPLAY -v $HOME/.Xauthority:/root/.Xauthority -v /tmp/.X11-unix:/tmp/.X11-unix -it -v `pwd`:/savedir --privileged --net host --ipc=host opencv-gpu
```

## Test HW Accel GPU Decode via OpenCV

Inside the container run:

```
python3 /savedir/opencv-hw-accel-video.py
```

## Verify GPU Usage

In another terminal run intel_gpu_top and verify the "Video" engine usage
