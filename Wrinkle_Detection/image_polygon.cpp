#include "image_polygon.hpp"


void image_polygon::setImage(const Mat& img)
{
    image=img.clone();
}

void image_polygon::process()
{
    Mat image_hsv;
    blur( image, image, Size(3,3) );  
    cvtColor(image,image_hsv,COLOR_RGB2HSV);
    inRange(image_hsv,Scalar(0,0,250),Scalar(160,255,255), binary);
}

Mat image_polygon::getBinary()
{
    return binary;
}

void image_polygon::drawPoints()
{
     Mat drawing = Mat::zeros( binary.size(), CV_8UC3 );
     Scalar color = Scalar( 0,0,255 );
     for(int i=0;i<corners.size();i++)
     drawContours( drawing, corners,i, color );
     namedWindow("Hull demo",CV_WINDOW_NORMAL);
     imshow( "Hull demo", drawing );
}


void image_polygon::boundingPolygon()
{
    vector<vector<Point> > contours;
    findContours( binary, contours, RETR_TREE, CHAIN_APPROX_SIMPLE );
    vector<vector<Point> >hull( contours.size() );
    
    for( size_t i = 0; i < contours.size(); i++ )
    {
        convexHull( contours[i], hull[i] );
        
    }
    Mat drawing = Mat::zeros( binary.size(), CV_8UC3 );
    // std::cout<<contours.size();
    unsigned long long int largest_area=0;
    int largest_contour_index=0;
    for( int i = 0; i< contours.size(); i++ ) // iterate through each contour.
    {
    double a=contourArea( contours[i],false);  //  Find the area of contour
    // std::cout<<a<<endl;
    if(a>5000){
        std::cout<<"Hi"<<endl;
      vector<Point> corner;
      for(int j=0;j<hull[i].size();j++) corner.push_back(hull[i][j]);
        corners.push_back(corner);
     }

    }

    std::cout<<corners.size()<<endl;

}

vector<vector<Point>> image_polygon::getCorners()
{
    return corners;
}

void image_polygon::optimize()
{
/*    if(n>corners.size()) n=corners.size();
    vector<Point> local = corners;
    vector<int> distances;
    map<pair<int, int>, int> m; 
    map<pair<int,int>,int > stat;
    for(int i=0;i<corners.size();i++)
        for(int j=0;j<corners.size();i++)
            if(i!=j)
            {
                int x1=corners[i].x,x2=corners[j].x,y1=corners[i].y,y2=corners[j].y;
                m[{corners[i].x*10000+corners[i].y,corners[j].x*10000+corners[j].y}]=(x1-x2)*(x1-x2)+(y1-y2)*(y1-y2);
                distances.push_back((x1-x2)*(x1-x2)+(y1-y2)*(y1-y2));
            }
    sort(distances.begin(),distances.end(),[](int i, int j){return i>j;});*/
    vector<vector<Point>> temp;
    vector<Point> approx;
    for(auto corner:corners){
    approxPolyDP(Mat(corner), approx, arcLength(Mat(corner), true) * 0.01, true);
    temp.push_back(approx);
    }
    corners.clear();
    corners=temp;
}
