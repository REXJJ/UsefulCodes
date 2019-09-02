import cv2
import numpy as np

img = cv2.imread('/home/rex/Desktop/Images/base.png')
img_ref = cv2.imread('/home/rex/Desktop/Images/wrinkled.png')

gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
gray_ref = cv2.cvtColor(img_ref, cv2.COLOR_BGR2GRAY)
kernel = np.ones((2,2),np.uint8)

#prewitt
kernelx = np.array([[1,1,1],[0,0,0],[-1,-1,-1]])
kernely = np.array([[-1,0,1],[-1,0,1],[-1,0,1]])
img_prewittx = cv2.filter2D(gray, -1, kernelx)
img_prewitty = cv2.filter2D(gray, -1, kernely)
ret,thresh1 = cv2.threshold(img_prewittx + img_prewitty,180,255,cv2.THRESH_BINARY)
opening = cv2.morphologyEx(thresh1, cv2.MORPH_OPEN, kernel)

img_prewittx_ref = cv2.filter2D(gray_ref, -1, kernelx)
img_prewitty_ref = cv2.filter2D(gray_ref, -1, kernely)
ret,thresh1_ref = cv2.threshold(img_prewittx_ref + img_prewitty_ref,180,255,cv2.THRESH_BINARY)
opening_ref = cv2.morphologyEx(thresh1_ref, cv2.MORPH_OPEN, kernel)

'''comb = thresh1_ref - thresh1'''
print(thresh1.shape)
print(thresh1_ref.shape)

comb = thresh1_ref

for i in range(722):
    for j in range(880):
        if thresh1[i,j]==255:
            comb[i,j]=0
            comb[i-1,j]=0
            comb[i-1,j-1]=0
            comb[i,j-1]=0
            comb[i-1,j+1]=0
            comb[i,j+1]=0
            comb[i+1,j-1]=0
            comb[i+1,j]=0
            comb[i+1,j+1]=0


cv2.imshow("Base Image", img)
cv2.imshow("Wrinkled Image", img)

cv2.imshow("Thresholded_Prewitt",thresh1)
cv2.imshow("Thresholded_Prewitt Wrinkled",thresh1_ref)

cv2.imshow("Subtracted",comb)



cv2.waitKey(0)
cv2.destroyAllWindows()
