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

def calculate(base):
    ksize=5
    i=ksize/2
    mean=np.zeros(base.shape)
    sd=np.zeros(base.shape)
    while i+ksize/2<(base.shape[0]):
        j=ksize/2
        while j+ksize/2<(base.shape[1]):
            s1=0
            m1=0
            sd1=0
            n=0
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                    s1+=base[i+k][j+l]
                    n+=1
            m1=s1/n
            s1=0.0
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                    s1+=math.pow((base[i+k][j+l]-m1),2)
            sd1=math.sqrt(s1/n)
            
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                        mean[i+k][j+l]=abs(m1)
                        sd[i+k][j+l]=abs(sd1)
            j+=1
        i+=1
    print("Mean and SD calculated")                
    return mean,sd                                    

i=0

'''def process(image,mean,sd):
    for i in range(image.shape[0]):
        for j in range(image.shape[1]):
            if abs(image[i][j]-mean[i][j])<5*sd[i][j]:
                image[i][j]=0
    return image
'''
def process(image,mean,sd):
    image = np.where(abs(image-mean)<7*sd,0,image)
    #ret,thresh = cv2.threshold(image,100,255,cv2.THRESH_BINARY)
    #ret, otsu = cv2.threshold(image,0,255,cv2.THRESH_BINARY+cv2.THRESH_OTSU)
    image = cv2.medianBlur(image,3)
    ret,thresh = cv2.threshold(image,100,255,cv2.THRESH_BINARY)
    return image

def crop(image):
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return gray[100:820,600:1500]
    
mean = cv2.imread('/home/rex/Desktop/Images/base.png')
sd = cv2.imread('/home/rex/Desktop/Images/wrinkled.png')

    
cap = cv2.VideoCapture('/home/rex/Desktop/wrinkle_2.mp4')
 
if (cap.isOpened()== False): 
  print("Error opening video stream or file")
 
while(cap.isOpened()):
  ret, frame = cap.read()
  if ret == True:
    #frame = cv2.GaussianBlur(frame,(5,5),0)
    reference=crop(frame)
    if i==0:
        img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(reference,100)
        mean_x,sd_x = calculate(img_prewittx)
        mean_y,sd_y = calculate(img_prewitty)
    i+=1
    #cv2.namedWindow('Frame',cv2.WINDOW_NORMAL)
    img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(reference,100)
    reference_x = process(img_prewittx,mean_x,sd_x)
    reference_y = process(img_prewitty,mean_y,sd_y)
    cv2.imshow('Image',frame)
    cv2.imshow('Prewitt_x',img_prewittx)
    cv2.imshow('Prewitt_y',img_prewitty)
    cv2.imshow('Frame_x',reference_x)
    cv2.imshow('Frame_y',reference_y)

    print i
    if cv2.waitKey(25) & 0xFF == ord('q'):
      break
  else: 
    break
 
cap.release()
cv2.destroyAllWindows()
