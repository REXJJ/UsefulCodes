#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include <iostream>

using namespace cv;
using namespace std;

// Global variables

Mat src, src_gray;
Mat dst, detected_edges;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 255;
int ratio = 3;
int kernel_size = 3;
char* window_name = "Edge Map";

Mat otsu_binarization(Mat img)
{
Mat img_bw;
cv::threshold(img, img_bw, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
return img_bw;
}

void CannyThreshold(int, void*)
{
  blur( src_gray, detected_edges, Size(3,3) );
  Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
  dst = Scalar::all(0);
  src.copyTo( dst, detected_edges);
  dst=otsu_binarization(dst);
  for(int i=0;i<dst.rows;i=i+10)
  {  
  	for(int j=0;j<dst.cols;j=j+10)
  {
  	int sum=0,status=0;
  	for(int k=i;k<i+10;k++)
  		for(int l=j;l<j+10;l++){
  			     sum=sum+dst.at<uchar>(k,l);
  			     std::cout<<int(dst.at<uchar>(k,l));
                if(sum>10)
                	status=1;
  		}
  		if(status)
  			for(int k=i;k<i+10;k++)
  		for(int l=j;l<j+10;l++){
  			     dst.at<uchar>(k,l)=255;
  		}
  }
  }
  imshow( window_name, dst );
 }

int main( int argc, char** argv )
{
    if( argc != 2)
    {
     cout <<" Usage: display_image ImageToLoadAndDisplay" << endl;
     return -1;
    }

    Mat image;
    image = imread(argv[1], CV_LOAD_IMAGE_COLOR);   // Read the file

    if(! image.data )                              // Check for invalid input
    {
        cout <<  "Could not open or find the image" << std::endl ;
        return -1;
    }

  src=image.clone();
  dst.create( src.size(), src.type() );
  cvtColor( src, src_gray, CV_BGR2GRAY );
  namedWindow( window_name, CV_WINDOW_AUTOSIZE );
  namedWindow( "Original", WINDOW_AUTOSIZE );// Create a window for display.
  imshow( "Original", src );
  createTrackbar( "Min Threshold:", window_name, &lowThreshold, max_lowThreshold, CannyThreshold );
  CannyThreshold(0, 0);
  waitKey(0);
  return 0;
}