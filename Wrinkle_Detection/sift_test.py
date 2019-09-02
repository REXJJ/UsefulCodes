import cv2
img = cv2.imread('/home/rex/Desktop/Images/non_wrinkled_part.jpg')
sift = cv2.xfeatures2d.SIFT_create();
gray = cv2.cvtColor(img,cv2.COLOR_BGR2GRAY);
kp = sift.detect(gray,None);
cv2.drawKeypoints(gray,kp,img);
cv2.imwrite('sift_keypoints_non.jpg',img)
