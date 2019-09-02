#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <utility>
#include <map>

#include "opencv2/imgproc.hpp"
#include "include/image_polygon.hpp"
using namespace cv;
using namespace std;


int main( int argc, char** argv )
{
    Mat image;
    image = imread("/home/rex/Desktop/Images/mold_test.jpg", CV_LOAD_IMAGE_COLOR);  

    if(! image.data )                              
    {
        cout <<  "Could not open or find the image" << std::endl ;
        return -1;
    }

    namedWindow( "Display window", CV_WINDOW_NORMAL);
    imshow( "Display window", image );   

    image_polygon poly;
    poly.setImage(image);
    poly.process();
    poly.boundingPolygon();
    poly.optimize();
    poly.drawPoints();
    waitKey(0);
/*    namedWindow("Processed", WINDOW_AUTOSIZE);
    imshow("Processed",poly.getBinary());           
    waitKey(0); */                                         
    return 0;
}