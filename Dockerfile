FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && \
    apt install -y gpg wget && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN wget -qO - https://repositories.intel.com/gpu/intel-graphics.key | gpg --yes --dearmor --output /usr/share/keyrings/intel-graphics.gpg; echo "deb [arch=amd64,i386 signed-by=/usr/share/keyrings/intel-graphics.gpg] https://repositories.intel.com/gpu/ubuntu jammy client" | tee /etc/apt/sources.list.d/intel-gpu-jammy.list; apt update

ARG BUILD_DEPENDENCIES="nasm yasm libmfx-dev libva-dev vim libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly gstreamer1.0-libav gstreamer1.0-tools gstreamer1.0-x gstreamer1.0-alsa gstreamer1.0-gl gstreamer1.0-gtk3 gstreamer1.0-qt5 gstreamer1.0-pulseaudio gstreamer1.0-vaapi libmfx1 libmfxgen1 libmfx-tools libvpl2 libva-drm2 libva-x11-2 libva-wayland2 libva-glx2 vainfo intel-media-va-driver-non-free ffmpeg build-essential git pkg-config python3-dev cmake pkg-config python3-opencv unzip"
RUN apt -y update && \
    apt install -y ${BUILD_DEPENDENCIES} && \
    rm -rf /var/lib/apt/lists/* && rm -rf /tmp/*

RUN wget https://github.com/opencv/opencv/archive/refs/tags/4.9.0.zip && unzip 4.9.0.zip
RUN cd opencv-4.9.0/; mkdir -p build; cd build; cmake -DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") -DBUILD_opencv_python2=OFF -DBUILD_opencv_python3=ON -DINSTALL_PYTHON_EXAMPLES=OFF -DBUILD_TESTS=OFF -DPYTHON3_NUMPY_INCLUDE_DIRS=/usr/local/lib/python3.10/dist-packages/numpy/core/include -DOPENCV_PYTHON3_INSTALL_PATH=/usr/local/lib/python3.10/dist-packages -DPYTHON3_PACKAGES_PATH=/usr/lib/python3/dist-packages -DOPENCV_PYTHON3_INSTALL_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") -DPYTHON_EXECUTABLE=$(which python3) -DBUILD_DOCS=OFF -DVIDEOIO_PLUGIN_LIST="mfx;ffmpeg" ..; cmake --build . --config Release -- -j`nproc`; make install; echo $(python3 -c "import cv2; print(cv2.__version__)")

# Test video HW decode with gst manually
# gst-launch-1.0 filesrc location=/savedir/sample-video.mp4 ! qtdemux ! h264parse ! vaapidecodebin ! fakesink

# Test video HW decode with OpenCV 
# python3 /savedir/opencv-hw-accel-video.py
