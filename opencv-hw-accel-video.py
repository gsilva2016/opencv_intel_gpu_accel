import cv2

cap = cv2.VideoCapture("/savedir/sample-video.mp4", cv2.CAP_GSTREAMER)

while cap.isOpened():
    success, frame = cap.read()
    #print("got frame")

print("Done reading video")
