#include "opencv2/opencv.hpp"
#include <iostream>
#include <Eigen/Dense>
using Eigen::MatrixXd;
 
using namespace std;
using namespace cv;
using namespace Eigen ;

int applyKernel(const Mat& img, const MatrixXd& kernel,int x,int y)
{
  int r = kernel.rows();
  int c = kernel.cols();
  int sum=0;
  for(int i=-r/2;i<=r/2;i++)
    for(int j=-c/2;j<=c/2;j++)
      sum+=kernel(i+r/2,j+c/2)*img.at<uchar>(x+i,y+j);
    return sum;
} 
 

Mat prewittx(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernelx,kernely;
  kernelx<<-1,0,1,-1,0,1,-1,0,1;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int gx = applyKernel(dst,kernelx, x, y);
                int sum = gx;
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}


Mat prewitty(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernelx,kernely;
  kernely<<-1,-1,-1,0,0,0,1,1,1;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int gx = applyKernel(dst,kernely, x, y);
                int sum = gx;
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat crop(Mat image)
{
  cv::Rect roi(100,820,600,1500);
  Mat image_bw;
  //std::cout<<image.size()<<endl;
  cvtColor(image,image_bw,CV_RGB2GRAY);
  return image_bw;
}
 
int main(){
  VideoCapture cap("/home/rex/Desktop/wrinkle_1.mp4"); 
  if(!cap.isOpened()){
    cout << "Error opening video stream or file" << endl;
    return -1;
  }   
  while(1){
     Mat image;
     cap >> image;
    if (image.empty())
      break;
    Mat frame =  crop(image);
    Mat Prewitty = prewitty(frame);
    Mat Prewittx = prewittx(frame);
    imshow( "Frame", frame );
    imshow( "Prewitty", prewitty );
    imshow( "Prewittx", prewittx );

    char c=(char)waitKey(25);
    if(c==27)
      break;
  }
  cap.release();
  destroyAllWindows();   
  return 0;
}