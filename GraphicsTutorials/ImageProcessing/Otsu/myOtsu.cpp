#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include "opencv2/imgproc.hpp"
#include "opencv2/imgcodecs.hpp"
#include <iostream>
#include <climits>

using namespace cv;
using namespace std;

int color_space[5]={COLOR_RGB2BGR,COLOR_RGB2HLS,COLOR_RGB2YUV,COLOR_RGB2YCrCb,COLOR_RGB2HSV};


double otsu_binarization(vector<int> A,int &threshold)
{
std::vector<int> hist(256, 0);
std::vector<double> prob(256, 0.0);
std::vector<double> mu(256, 0.0);
std::vector<double> sigma(256, 0.0);
double max_sigma=-1;
for(int i=0;i<A.size();i++) hist[A[i]]++;
prob[0] = hist[0]/double(A.size());
for(int i=1;i<256;i++) {
    prob[i]=prob[i-1]+double(hist[i])/double(A.size());
    mu[i]=mu[i-1]+hist[i]*i;
}
for(int i = 0; i < 255; i++) {
    sigma[i]=(prob[i] != 0.0 && prob[i] != 1.0)?pow(mu[255]*prob[i]-mu[i],2)/(prob[i]*(1.0-prob[i])):0.0;
    if(sigma[i] > max_sigma) {
        max_sigma = sigma[i];
        threshold = i;
 }
}
return max_sigma;
}

Mat idealColorSpace(Mat image)
{

int threshold=0,chan=0;
double max_sigma=-1;int space_ideal=0;
for(int space=0;space<5;space++){
Mat img;
cvtColor(image,img,color_space[space]);
std::vector<cv::Mat> channels;
cv::split(img, channels);
for(int k=0;k<3;k++){
vector<int> A;
for(int i=0;i<channels[k].rows;i++)
for(int j=0;j<channels[k].cols;j++)
    A.push_back(channels[k].at<uchar>(i,j));
int threshold_temp;
double sigma=otsu_binarization(A,threshold_temp);
if(sigma>max_sigma){ threshold=threshold_temp;max_sigma=sigma;chan=k;space_ideal=space;}
}
}
Mat img_bw;
std::cout<<threshold<<" "<<max_sigma<<" "<<chan<<" "<<space_ideal<<endl;
Mat temp;
cvtColor(image,temp,color_space[space_ideal]);
std::vector<cv::Mat> channels;
cv::split(temp, channels);
cv::threshold(channels[chan], img_bw, threshold, 255, CV_THRESH_BINARY);
namedWindow( "IdealColorSpace", WINDOW_AUTOSIZE );// Create a window for display.
namedWindow( "IdealChannel", WINDOW_AUTOSIZE );// Create a window for display.
imshow( "IdealColorSpace", temp );                  
imshow( "IdealChannel", channels[chan]);                  
return img_bw;
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

    namedWindow( "Source", WINDOW_AUTOSIZE );// Create a window for display.
    namedWindow( "Destination", WINDOW_AUTOSIZE );// Create a window for display.
//cvtColor(dst,dst,COLOR_RGB2YCrCb);    
//cv::merge(channels, image);
Mat mask;
Mat otsu_1,otsu_2,otsu_3;
Mat img_bw=idealColorSpace(image);
imshow( "Source", image );                  
imshow( "Destination", img_bw);                  
waitKey(0);                                          // Wait for a keystroke in the window
return 0;
}