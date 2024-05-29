mport cv2

cap = cv2.VideoCapture("/savedir/sample-video.mp4", cv2.CAP_GSTREAMER)
success = True
while cap.isOpened() and success:
    success, frame = cap.read()
    #print("got frame")

print("Done reading video")
