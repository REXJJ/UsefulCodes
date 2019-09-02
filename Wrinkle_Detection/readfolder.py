import cv2
import os
import numpy as np
import math



def prewitt(image,threshold):
    kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
    kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
    img_prewittx = cv2.filter2D(image, -1, kernelx)
    img_prewitty = cv2.filter2D(image, -1, kernely)
    ret,threshx = cv2.threshold(img_prewittx,threshold,255,cv2.THRESH_BINARY)
    ret,threshy = cv2.threshold(img_prewitty,threshold,255,cv2.THRESH_BINARY)   
    return img_prewittx+img_prewittx,img_prewittx,img_prewitty,threshx,threshy


def square_distance(x1,x2,y1,y2):
    return (math.sqrt((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2)))


def method_centroid(base,image):
    i=0
    ksize=50
    print("here 1")
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
            if dist1<5:
                for k in range(ksize):
                    for l in range(ksize):
                        image[i+k][j+l]=0
            j+=ksize
        i+=ksize
    #image = cv2.GaussianBlur(image,(3,3),0)

#    image = cv2.medianBlur(image,3)
#    laplacian = cv2.Laplacian(image,cv2.CV_64F)
#    kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(5,5))
    #blackhat = cv2.morphologyEx(laplacian, cv2.MORPH_BLACKHAT,  cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(5,5)))
    return image                                    

img_prewitt = np.zeros((100,100), np.uint8)
img_prewittx = np.zeros((100,100), np.uint8)
img_prewitty = np.zeros((100,100), np.uint8)
threshp = np.zeros((100,100), np.uint8)
threshp1 = np.zeros((100,100), np.uint8)                          

   

def load_images_from_folder(folder):
    images = []
    i=0
    for filename in os.listdir(folder):
        img = cv2.imread(os.path.join(folder,filename))
        if img is not None:
            print i
            if i==0:
                image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
                img_prewitt,img_prewittx,img_prewitty,threshpx1,threshpy1 = prewitt(image,100)
            #cv2.namedWindow('Frame',cv2.WINDOW_NORMAL)
            image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            img_prewitt,img_prewittx,img_prewitty,threshpx,threshpy = prewitt(image,100)
            reference_x = method_centroid(threshpx1,threshpx)
            reference_y = method_centroid(threshpy1,threshpy)
            cv2.imshow('Prewitt_x',threshpx)
            cv2.imshow('Prewitt_y',threshpy)
            cv2.imshow('Frame_x',reference_x)
            cv2.imshow('Frame_y',reference_y)
            cv2.imshow('Image',image)


            i+=1
            cv2.waitKey(0)


load_images_from_folder("/home/rex/Desktop/TestData")
cv2.waitKey(3)
