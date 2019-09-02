#include<iostream>
#include<cmath>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>
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
 

Mat prewitt(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernelx,kernely;
  kernelx<<-1,0,1,-1,0,1,-1,0,1;
  kernely<<-1,-1,-1,0,0,0,1,1,1;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int gx = applyKernel(dst,kernelx, x, y);
                int gy = applyKernel(dst,kernely, x, y);
                int sum = sqrt(gx*gx+gy*gy);
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat roberts(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernelx,kernely;
  kernelx<<1,0,0,0,0,0,0,0,-1;
  kernely<<0,0,1,0,0,0,-1,0,0;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int gx = applyKernel(dst,kernelx, x, y);
                int gy = applyKernel(dst,kernely, x, y);
                int sum = sqrt(gx*gx+gy*gy);
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat scharr(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernelx,kernely;
  kernelx<<3,0,-3,10,0,-10,3,0,-3;
  kernely<<3,10,3,0,0,0,-3,-10,-3;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int gx = applyKernel(dst,kernelx, x, y);
                int gy = applyKernel(dst,kernely, x, y);
                int sum = sqrt(gx*gx+gy*gy);
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}


Mat kirsch(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d k1,k2,k3,k4,k5,k6,k7,k8;
  k1<<5,5,5,-3,0,-3,-3,-3,-3;
  k2<<5,5,-3,5,0,-3,-3,-3,-3;
  k3<<5,-3,-3,5,0,-3,5,-3,-3;
  k4<<-3,-3,-3,5,0,-3,5,5,-3;
  k5<<-3,-3,-3,-3,0,-3,5,5,5;
  k6<<-3,-3,-3,-3,0,5,-3,5,5;
  k7<<-3,-3,5,-3,0,5,-3,-3,5;
  k8<<-3,5,5,-3,0,5,-3,-3,-3;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int g1 = applyKernel(dst,k1, x, y);
                int g2 = applyKernel(dst,k2, x, y);
                int g3 = applyKernel(dst,k3, x, y);
                int g4 = applyKernel(dst,k4, x, y);
                int g5 = applyKernel(dst,k5, x, y);
                int g6 = applyKernel(dst,k6, x, y);
                int g7 = applyKernel(dst,k7, x, y);
                int g8 = applyKernel(dst,k8, x, y);                
                int sum = sqrt(g1*g1+g2*g2+g3*g3+g4*g4+g5*g5+g6*g6+g7*g7+g8*g8);
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat pointFilter(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kernel;
  kernel<<1,1,1,1,-8,1,1,1,1;
  for(int x = 1; x < dst.rows - 1; x++){
      for(int y = 1; y < dst.cols - 1; y++){
                int g = applyKernel(dst,kernel, x, y);
                int sum = g;
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat pointFilter5x5(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  MatrixXd kernel(5,5);
  kernel<<1,2,4,2,1,2,-3,-6,-3,2,4,-6,0,-6,4,2,-3,-6,-3,2,1,2,4,2,1;
  for(int x = 2; x < dst.rows - 2; x++){
      for(int y = 2; y < dst.cols - 2; y++){
                int g = applyKernel(dst,kernel, x, y);
                int sum = g;
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

Mat secondOrder(Mat dst)
{
  Mat ref=dst.clone();
  ref=0;
  Matrix3d kxx,kyy;
  Matrix3f kxy;
  kxx<<1,-2,1,0,0,0,0,0,0;
  kxy<<-1/4;
  for(int x = 2; x < dst.rows - 2; x++){
      for(int y = 2; y < dst.cols - 2; y++){
                int g = applyKernel(dst,kxx, x, y);
                int sum = g;
                sum = sum > 255 ? 255:sum;
                sum = sum < 0 ? 0 : sum;
                ref.at<uchar>(x,y) = sum;
            }
        }
  return ref;
}

int main( int argc, char** argv)
{
 
      Mat src, dst;
      int gx, gy, sum;
      if( argc != 2)
    {
     cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
     return -1;
    }

      // Load an image
      src = imread(argv[1], 1);
      Mat img_hsv;//=src.clone();
      //cvtColor(src, img_hsv, COLOR_BGR2Lab);
      //cvtColor(src, img_hsv,cv::COLOR_BGR2YCrCb);
      cvtColor(src,img_hsv,CV_RGB2HSV);
      
/*         for ( int i = 1; i < 4; i = i + 2 )
        { GaussianBlur( src, dst, Size( i, i ), 0, 0 );}*/

     /* GaussianBlur(src,dst,Size(3,3),0,0);*/
      std::vector<cv::Mat> channels;
      cv::split(img_hsv, channels);
/*      cv::equalizeHist(channels[0], channels[0]);
      cv::equalizeHist(channels[1], channels[1]);
      cv::equalizeHist(channels[2], channels[2]);*/
      cv::merge(channels,img_hsv);
      dst=channels[2].clone();
      Mat ref=pointFilter5x5(dst);
      ref=ref>70;
        int morph_size=1;
        Mat sol=ref.clone();
        Mat element = getStructuringElement( 0, Size( 2*morph_size, 2*morph_size), Point( morph_size, morph_size ) );
        morphologyEx( ref, sol, 2, element );
        namedWindow("final");
        imshow("final", ref);
 
        namedWindow("initial");
        imshow("initial", dst);

        dst=dst>100;
        namedWindow("thresholded");
        imshow("thresholded", dst);


/*         Mat detected_edges;
         Canny( src, ref, 60, 180, 3 );
          

        namedWindow("canny");
        imshow("canny", ref);
*/
 
      waitKey();
 
 
    return 0;
}