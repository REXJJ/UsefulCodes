import cv2
import os
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
            image = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
            print i
            if i==0:
                img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(image,100)
                mean_x,sd_x = calculate(img_prewittx)
                mean_y,sd_y = calculate(img_prewitty)
            i+=1
            #cv2.namedWindow('Frame',cv2.WINDOW_NORMAL)
            img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(image,100)
            reference_x = process(img_prewittx,mean_x,sd_x)
            reference_y = process(img_prewitty,mean_y,sd_y)
            cv2.imshow('Image',img)
            cv2.imshow('Prewitt_x',img_prewittx)
            cv2.imshow('Prewitt_y',img_prewitty)
            cv2.imshow('Frame_x',reference_x)
            cv2.imshow('Frame_y',reference_y)
            cv2.waitKey(0)


load_images_from_folder("/home/rex/Desktop/TestData")
cv2.waitKey(3)
