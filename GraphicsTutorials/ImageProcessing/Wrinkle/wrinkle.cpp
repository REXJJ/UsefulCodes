#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include <iostream>

using namespace cv;
using namespace std;

// Global variables

Mat src;

int edgeThresh = 1;
int lowThreshold;
int const max_lowThreshold = 255;

char* window_name = "Edge Map";


void CannyThreshold(int, void*)
{
  Mat dst, detected_edges,src_gray;
  cvtColor( src, src_gray, CV_BGR2GRAY );
  int ratio = 3,kernel_size = 3;
  dst.create( src_gray.size(), src_gray.type() );
  blur( src_gray, detected_edges, Size(3,3) );	
  Canny( detected_edges, detected_edges, lowThreshold, lowThreshold*ratio, kernel_size );
  dst = Scalar::all(0);
  src_gray.copyTo( dst, detected_edges);
  int step_r=40,step_c=40;
  for(int i=0;i+step_r<dst.rows;i=i+step_r)
  {  
  	for(int j=0;j+step_c<dst.cols;j=j+step_c)
  {
  	int sum=0,status=0;
  	 for(int k=i;k<i+step_r;k++)
  		for(int l=j;l<j+step_c;l++){
  			     sum=sum+int(int(dst.at<uchar>(k,l))>0);
                if(sum>10)
                	status=1;
  		}
  		if(status)
  			for(int k=i;k<i+step_r;k++)
            for(int l=j;l<j+step_c;l++){
            dst.at<uchar>(k,l)=100;
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
  namedWindow( window_name, CV_WINDOW_AUTOSIZE );
  namedWindow( "Original", WINDOW_AUTOSIZE );// Create a window for display.
  imshow( "Original", src );
  createTrackbar( "Min Threshold:", window_name, &lowThreshold, max_lowThreshold, CannyThreshold );
  CannyThreshold(0, 0);
  waitKey(0);
  return 0;
}