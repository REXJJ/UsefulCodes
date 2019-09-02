import cv2
import matplotlib.pyplot as plt
from skimage.feature import hessian_matrix, hessian_matrix_eigvals
from skimage.filter import frangi, hessian

def detect_ridges(gray, sigma=1.0):
    Hxx, Hxy, Hyy = hessian_matrix(gray, sigma)
    maxima_ridges, minima_ridges = hessian_matrix_eigvals(Hxx, Hxy, Hyy)
    return maxima_ridges, minima_ridges


img = cv2.imread('/home/rex/Desktop/Images/SheetImages/Bad/sheet7_Color.png') # 0 imports a grayscale
gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
a, b = detect_ridges(gray, sigma=3.0)
cv2.imshow("Original Image", gray)
cv2.imshow("Maxima", a)
cv2.imshow("Minima", b)
ret,thresh = cv2.threshold(b,1,255,cv2.THRESH_BINARY)
cv2.imshow("Thresholded", thresh)

cv2.waitKey(0)
cv2.destroyAllWindows()

