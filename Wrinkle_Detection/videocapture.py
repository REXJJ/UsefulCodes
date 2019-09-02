import cv2
import numpy as np
import math

def crop(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return gray[100:820,600:1500]
    
img_prewitt = np.zeros((100,100), np.uint8)
img_prewittx = np.zeros((100,100), np.uint8)
img_prewitty = np.zeros((100,100), np.uint8)
threshp = np.zeros((100,100), np.uint8)
threshp1 = np.zeros((100,100), np.uint8)

cap = cv2.VideoCapture('/home/rex/Desktop/wrinkle_1.mp4')
 
if (cap.isOpened()== False): 
  print("Error opening video stream or file")
i=0 
while(cap.isOpened()):
  ret, frame = cap.read()
  if ret == True:
    reference=crop(frame)
    i+=1
    cv2.imshow('Ref',reference)
    print i
    if cv2.waitKey(25) & 0xFF == ord('s'):
        cv2.imwrite("/home/rex/Desktop/TestData/input"+str(i)+".jpg",reference)
    if cv2.waitKey(25) & 0xFF == ord('q'):
      break
  else: 
    break 
cap.release()
cv2.destroyAllWindows()
