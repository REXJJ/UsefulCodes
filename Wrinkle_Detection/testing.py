'''/home/rex/Desktop/Images'''
import cv2
import numpy as np

img_base = cv2.imread('/home/rex/Desktop/Images/wrinkled.png')
gray = cv2.cvtColor(img_base, cv2.COLOR_BGR2GRAY)
img_gaussian = gray
kernel = np.ones((2,2),np.uint8)

#canny
img_canny = cv2.Canny(gray,60,200)

#sobel
img_sobelx = cv2.Sobel(img_gaussian,cv2.CV_8U,1,0,ksize=5)
img_sobely = cv2.Sobel(img_gaussian,cv2.CV_8U,0,1,ksize=5)
img_sobel = img_sobelx + img_sobely
ret,thresh2 = cv2.threshold(img_sobel,127,255,cv2.THRESH_BINARY)


#prewitt
kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
img_prewittx = cv2.filter2D(img_gaussian, -1, kernelx)
img_prewitty = cv2.filter2D(img_gaussian, -1, kernely)
ret,thresh1 = cv2.threshold(img_prewittx + img_prewitty,60,255,cv2.THRESH_BINARY)
opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)
prewitt_im = img_prewittx+img_prewitty
shape=gray.shape

 
inp = cv2.dnn.blobFromImage(gray, scalefactor=1.0, size=(shape[0], shape[1]),
                                  mean=(104.00698793, 116.66876762, 122.67891434), swapRB=False,
                                  crop=False)
cv2.imshow("Original Image", img_base)
cv2.imshow("Canny", img_canny)
cv2.imshow("Sobel X", img_sobelx)
cv2.imshow("Sobel Y", img_sobely)
cv2.imshow("Sobel", img_sobel)
cv2.imshow("Prewitt X", img_prewittx)
cv2.imshow("Prewitt Y", img_prewitty)
cv2.imshow("Prewitt", img_prewittx + img_prewitty)
cv2.imshow("Thresholded_Prewitt",thresh1)
cv2.imshow("Thresholded_Sobel",thresh2)
cv2.imshow("Opened",opening)
cv2.imshow("Prewitt",prewitt_im)


cv2.waitKey(0)
cv2.destroyAllWindows()
