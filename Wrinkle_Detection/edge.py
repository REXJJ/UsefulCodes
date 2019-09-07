import cv2
import numpy as np

img = cv2.imread('/home/rex/Desktop/TestData2/Selection_579.png')
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
img_gaussian = gray
kernel = np.ones((2,2),np.uint8)

#canny
img_canny = cv2.Canny(img,60,200)

#sobel
img_sobelx = cv2.Sobel(img_gaussian,cv2.CV_8U,1,0,ksize=5)
img_sobely = cv2.Sobel(img_gaussian,cv2.CV_8U,0,1,ksize=5)
img_sobel = img_sobelx + img_sobely
ret,thresh2 = cv2.threshold(img_sobel,150,255,cv2.THRESH_BINARY)


#prewitt
kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
img_prewittx = cv2.filter2D(img_gaussian, -1, kernelx)
img_prewitty = cv2.filter2D(img_gaussian, -1, kernely)
ret,thresh1 = cv2.threshold(img_prewittx + img_prewitty,150,255,cv2.THRESH_BINARY)
opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)

shape=gray.shape

 
inp = cv2.dnn.blobFromImage(gray, scalefactor=1.0, size=(shape[0], shape[1]),
                                  mean=(104.00698793, 116.66876762, 122.67891434), swapRB=False,
                                  crop=False)


cv2.namedWindow('Original', cv2.WINDOW_NORMAL)
cv2.namedWindow('Canny', cv2.WINDOW_NORMAL)
cv2.namedWindow('Sobel X', cv2.WINDOW_NORMAL)
cv2.namedWindow('Sobel Y', cv2.WINDOW_NORMAL)
cv2.namedWindow('Sobel', cv2.WINDOW_NORMAL)
cv2.namedWindow('Prewitt X', cv2.WINDOW_NORMAL)
cv2.namedWindow('Prewitt Y', cv2.WINDOW_NORMAL)
cv2.namedWindow('Prewitt', cv2.WINDOW_NORMAL)
cv2.namedWindow('Thresholded_Prewitt', cv2.WINDOW_NORMAL)
cv2.namedWindow('Thresholded_Sobel', cv2.WINDOW_NORMAL)
cv2.namedWindow('Opened', cv2.WINDOW_NORMAL)
cv2.namedWindow('Laplacian', cv2.WINDOW_NORMAL)
cv2.namedWindow('Median_Filtered_x',cv2.WINDOW_NORMAL)
cv2.namedWindow('Median_Filtered_y',cv2.WINDOW_NORMAL)
cv2.namedWindow('Median_Filtered',cv2.WINDOW_NORMAL)


median_y = cv2.medianBlur(img_sobely,25)
median_x = cv2.medianBlur(img_sobelx,25)

blur = cv2.blur(img_sobely,(35,35))


cv2.imshow('Median_Filtered_x',median_x)
cv2.imshow('Median_Filtered_y',median_y)
cv2.imshow('Median_Filtered',median_y+median_x)



cv2.imshow("Original", img)
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

# Apply Gaussian Blur
blur = cv2.GaussianBlur(gray,(3,3),0)
 
# Apply Laplacian operator in some higher datatype
laplacian = cv2.Laplacian(blur,cv2.CV_64F)
laplacian1 = laplacian/laplacian.max()
cv2.imshow("Laplacian",laplacian1)


cv2.waitKey(0)
cv2.destroyAllWindows()

cv2.imwrite("/home/rex/Desktop/prewitt.jpg",img_sobel)
cv2.imwrite("/home/rex/Desktop/thresh.jpg",thresh2)


