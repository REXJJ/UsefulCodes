import cv2
import numpy as np
import math

def crop(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return gray[243:893,704:1427]
    
img_prewitt = np.zeros((100,100), np.uint8)
img_prewittx = np.zeros((100,100), np.uint8)
img_prewitty = np.zeros((100,100), np.uint8)
threshp = np.zeros((100,100), np.uint8)
threshp1 = np.zeros((100,100), np.uint8)

cap = cv2.VideoCapture('/home/rex/Desktop/ICRA/test1.mp4')
im=cv2.imread("/home/rex/Desktop/ICRA/reference.jpg");
im=crop(im);
cv2.imwrite("/home/rex/Desktop/ICRA/ref_image.jpg",im);
if (cap.isOpened()== False): 
  print("Error opening video stream or file")
i=0 
while(cap.isOpened()):
  ret, frame = cap.read()
  if ret == True:
    reference=crop(frame)
    i+=1
    cv2.namedWindow("Ref",cv2.WINDOW_NORMAL);
    cv2.imshow('Ref',reference)
    print i
    if cv2.waitKey(25) & 0xFF == ord('s'):
        cv2.imwrite("/home/rex/Desktop/ICRA/input"+str(i)+".jpg",reference)
    if cv2.waitKey(25) & 0xFF == ord('q'):
      break
  else: 
    break 
cap.release()
cv2.destroyAllWindows()
