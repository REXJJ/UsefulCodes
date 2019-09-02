#ifndef POINTCLOUD_FLOODFILL_HPP
#define POINTCLOUD_FLOODFILL_HPP

#include <opencv2/core/core.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <iostream>
#include <utility>
#include <map>

#include "opencv2/imgproc.hpp"
using namespace cv;
using namespace std;


class image_polygon
{
public:
    Mat image;
    Mat binary;
    vector<vector<Point>> corners;
    void setImage(const Mat& img);
    void process();
    Mat getBinary();
    void boundingPolygon();
    void drawPoints();
    vector<vector<Point>> getCorners();
    void optimize();
};

#endif