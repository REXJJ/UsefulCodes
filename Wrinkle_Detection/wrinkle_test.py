import cv2
import numpy as np
import math

#img = cv2.imread('/home/rex/Desktop/Images/no_wrinkle_part_new.jpg')
#img2 = cv2.imread('/home/rex/Desktop/Images/wrinkle_part_new.jpg')
img = cv2.imread('/home/rex/Desktop/Images/base.png')
img2 = cv2.imread('/home/rex/Desktop/Images/wrinkled.png')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
gray1 = cv2.cvtColor(img2, cv2.COLOR_BGR2GRAY)


def sobel(image,threshold):
    img_sobelx = cv2.Sobel(image,cv2.CV_8U,1,0,ksize=5)
    img_sobely = cv2.Sobel(image,cv2.CV_8U,0,1,ksize=5)
    img_sobel = img_sobelx + img_sobely
    ret,thresh = cv2.threshold(img_sobely,threshold,255,cv2.THRESH_BINARY)
    return img_sobelx,img_sobely,img_sobel,thresh

def prewitt(image,threshold):
    kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
    kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
    img_prewittx = cv2.filter2D(image, -1, kernelx)
    img_prewitty = cv2.filter2D(image, -1, kernely)
    ret,thresh = cv2.threshold(img_prewittx,threshold,255,cv2.THRESH_BINARY)
    cv2.imwrite("/home/rex/Desktop/prewittx.jpg",img_prewittx)
    cv2.imwrite("/home/rex/Desktop/prewitty.jpg",img_prewitty)
    cv2.imwrite("/home/rex/Desktop/thresholded_prewittx.jpg",thresh)
    return img_prewittx+img_prewittx,img_prewittx,img_prewitty,thresh
    
    
def print_gradient_images(name,image,imagex,imagey,imaget):
    cv2.namedWindow(name, cv2.WINDOW_NORMAL)
    cv2.namedWindow(name+' X', cv2.WINDOW_NORMAL)
    cv2.namedWindow(name+' Y', cv2.WINDOW_NORMAL)
    cv2.namedWindow(name+' Th', cv2.WINDOW_NORMAL)
    cv2.imshow(name,image)
    cv2.imshow(name+' X', imagex)
    cv2.imshow(name+' Y', imagey)
    cv2.imshow(name+' Th', imaget)

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
            if dist1<11:
                for k in range(ksize):
                    for l in range(ksize):
                        image[i+k][j+l]=0
            j+=ksize
        i+=ksize
    #image = cv2.GaussianBlur(image,(3,3),0)
    cv2.imwrite("/home/rex/Desktop/output_1.jpg",image)

    image = cv2.medianBlur(image,3)
    laplacian = cv2.Laplacian(image,cv2.CV_64F)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT,(5,5))
    #blackhat = cv2.morphologyEx(laplacian, cv2.MORPH_BLACKHAT,  cv2.getStructuringElement(cv2.MORPH_ELLIPSE,(5,5)))
    return image                                    


def new_method(base,image):
    ksize=11
    i=ksize/2
    print("here 1")

    print("here 1")

    while i+ksize/2<(base.shape[0]):
        j=ksize/2
        while j+ksize/2<(base.shape[1]):
            s1=0
            s2=0
            m1=0
            m2=0
            sd1=0
            sd2=0
            n=0
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                    s1+=base[i+k][j+l]
                    s2+=image[i+k][j+l]
                    n+=1
            m1=s1/n
            m2=s2/n
            s1=0.0
            s2=0.0
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                    s1+=math.pow((base[i+k][j+l]-m1),2)
                    s2+=math.pow((image[i+k][j+l]-m2),2)
            sd1=math.sqrt(s1/n)
            sd2=math.sqrt(s2/n)
            
            for k in range(-ksize/2,ksize/2):
                for l in range(-ksize/2,ksize/2):
                    if abs(image[i+k][j+l]-m1)<abs(5*sd1):
                        #print image[i+k][j+l], m1, sd1
                        image[i+k][j+l]=0
            j+=1
        i+=1
                    
    return image                                    


def method_weighed_centroid(base,image):
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
                        sx=sx+(i+k)*base[i+k][j+l]
                        sy=sy+(j+l)*base[i+k][j+l]
                        n=n+base[i+k][j+l]
                        sx1=sx1+(i+k)*image[i+k][j+l]
                        sy1=sy1+(j+l)*image[i+k][j+l]
                        n1=n1+image[i+k][j+l]
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
    #image = cv2.GaussianBlur(image,(3,3),0)
    #image = cv2.medianBlur(image,3)
    ret,thresh = cv2.threshold(image,100,255,cv2.THRESH_BINARY)

    return thresh

   

def method_weighed_centroid_sd(base,image):
    i=0
    ksize=50
    while i+ksize<(base.shape[0]):
        j=0
        while j+ksize<(base.shape[1]):
            sx=0
            sy=0
            n=0
            sx1=0
            sy1=0
            n1=0            
            for k in range(ksize):
                for l in range(ksize):
                        sx=sx+(i+k)*base[i+k][j+l]
                        sy=sy+(j+l)*base[i+k][j+l]
                        n=n+base[i+k][j+l]
                        sx1=sx1+(i+k)*image[i+k][j+l]
                        sy1=sy1+(j+l)*image[i+k][j+l]
                        n1=n1+image[i+k][j+l]

            xcen=i+ksize/2
            ycen=j+ksize/2
            xcen1=i+ksize/2;
            ycen1=j+ksize/2
            if (n!=0):
                xcen=sx/n
                ycen=sy/n
            if (n1!=0):
                xcen1=sx1/n1
                ycen1=sy1/n1

            sdx=0
            sdy=0
            m=0
            sdx1=0
            sdy1=0
            m1=0
            for k in range(ksize):
                for l in range(ksize):
                        sdx=sdx+math.pow((i+k-xcen)*base[i+k][j+l],2)
                        sdy=sdy+math.pow((j+l-ycen)*base[i+k][j+l],2)
                        if base[i+k][j+l]!=0:
                            m=m+1
                        sdx1=sdx1+math.pow((i+k-xcen1)*image[i+k][j+l],2)
                        sdy1=sdy1+math.pow((j+l-ycen1)*image[i+k][j+l],2)
                        if image[i+k][j+l]!=0:
                            m1=m1+1
            if n!=0:
                sdx=math.sqrt(sdx/n)
                sdy=math.sqrt(sdy/n)
            if n1!=0:
                sdx1=math.sqrt(sdx1/n1)
                sdy1=math.sqrt(sdy1/n1)
            if abs(xcen1-xcen)<5 or abs(ycen1-ycen)<5:
                for k in range(ksize):
                    for l in range(ksize):
                        image[i+k][j+l]=0
                           
            j+=ksize
        i+=ksize
    return image




def mean_method(base, image):
    ksize=10
    i=0
    while i+ksize<(base.shape[0]):
        j=0
        while j+ksize<(base.shape[1]):
            s1=0
            s2=0
            n=0
            for k in range(ksize):
                for l in range(ksize):
                        s1=s1+base[i+k][j+l]
                        s2=s2+image[i+k][j+l]
                        n=n+1;
            m1=s1/n
            m2=s2/n
            if(abs(m1-m2)<20):
                for k in range(ksize):
                    for l in range(ksize):
                        image[i+k][j+l]=0
                
            j+=ksize
        i+=ksize
    #image = cv2.GaussianBlur(image,(3,3),0)
    image = cv2.medianBlur(image,3)
    ret,thresh = cv2.threshold(image,100,255,cv2.THRESH_BINARY)
    return thresh

    

cv2.namedWindow('Base', cv2.WINDOW_NORMAL)
cv2.imshow("Base", img)

img_sobelx,img_sobely,img_sobel,thresh = sobel(gray,100)
img_sobelx1,img_sobely1,img_sobel1,thresh1 = sobel(gray1,100)

img_prewitt,img_prewittx,img_prewitty,threshp = prewitt(gray,100)
img_prewitt,img_prewittx1,img_prewitty1,thresh1p = prewitt(gray1,100)

#image = method_weighed_centroid(img_prewitty,img_prewitty1)
#image = method_centroid(threshp,thresh1p)
#image = method_weighed_centroid_sd(img_prewittx,img_prewittx1)

image  = new_method(img_prewitty,img_prewitty1)
cv2.namedWindow('Wrinkled Image', cv2.WINDOW_NORMAL)
cv2.imshow("Wrinkled Image", img2)

cv2.namedWindow('Filtered', cv2.WINDOW_NORMAL)
cv2.imshow("Filtered", image)

cv2.imwrite("/home/rex/Desktop/input.jpg",img2)
cv2.imwrite("/home/rex/Desktop/output.jpg",image)

cv2.waitKey(0)
cv2.destroyAllWindows()
