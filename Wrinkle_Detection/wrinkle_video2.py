import cv2
import numpy as np
import math


def prewitt(image,threshold):
    kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
    kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
    img_prewittx = cv2.filter2D(image, -1, kernelx)
    img_prewitty = cv2.filter2D(image, -1, kernely)
    ret,thresh = cv2.threshold(img_prewittx,threshold,255,cv2.THRESH_BINARY)
    return img_prewittx+img_prewittx,img_prewittx,img_prewitty,thresh


def square_distance(x1,x2,y1,y2):
    return (math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)))


def method_centroid(base,image):
    i=0
    ksize=50
    while i+ksize<(base.shape[0]):
        j=0
        while j+ksize<(base.shape[1]):
            sx=0
            sy=0
            sx1=0
            sy1=0
            n1=0
            n=0
            for k in range(ksize):
                for l in range(ksize):
                    if base[i+k][j+l]>0:
                        sx=sx+i+k
                        sy=sy+j+l
                        n=n+1
                    if image[i+k][j+l]>0:
                        sx1=sx1+i+k
                        sy1=sy1+j+l
                        n1=n1+1
            dist1=0.0
            dist2=0.0
            xcen=i+ksize/2;
            ycen=j+ksize/2
            xcen1=i+ksize/2
            ycen1=j+ksize/2
            if (n!=0):
                xcen=sx/n
                ycen=sy/n
            if n1!=0:
                xcen1=sx1/n1
                ycen1=sy1/n1
            dist1=square_distance(xcen,xcen1,ycen,ycen1)
            if dist1<11:
                for k in range(ksize):
                    for l in range(ksize):
                        image[i+k][j+l]=0
            j+=ksize
        i+=ksize

    image = cv2.medianBlur(image,3)
    #laplacian = cv2.Laplacian(image,cv2.CV_64F)
    #kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(5,5))
    #blackhat = cv2.morphologyEx(laplacian, cv2.MORPH_BLACKHAT,  cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(5,5)))
    return image                                    


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
    if i==0:
        img_prewitt,img_prewittx,img_prewitty,threshp1 = prewitt(reference,100)
    i+=1
    #cv2.namedWindow('Frame',cv2.WINDOW_NORMAL)
    img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(reference,100)
    reference = method_centroid(threshp,threshp1)
    cv2.imshow('Prewitt_x',img_prewittx)
    cv2.imshow('Prewitt_y',img_prewitty)
    cv2.imshow('Frame_x',reference)

    print i
    if cv2.waitKey(25) & 0xFF == ord('q'):
      break
  else: 
    break
 
cap.release()
cv2.destroyAllWindows()
