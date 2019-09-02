#include <opencv2/opencv.hpp>
#include <vector>
#include <algorithm>
#include<opencv2/imgproc/imgproc.hpp>
#include<opencv2/highgui/highgui.hpp>

using namespace std;
using namespace cv;

int main()
{
    // Load the image 
    Mat3b img = imread("/home/rex/Desktop/Images/test_bounding.jpg", IMREAD_COLOR);
    // Convert to grayscale
    Mat1b gray;
    cvtColor(img, gray, COLOR_BGR2GRAY);
    // Get binary mask (remove jpeg artifacts)
    gray = gray > 100;
    // Get all non black points
    vector<Point> pts;
    findNonZero(gray, pts);
    // Define the radius tolerance
    int th_distance = 5; // radius tolerance
    // Apply partition 
    // All pixels within the radius tolerance distance will belong to the same class (same label)
    vector<int> labels;
    // With lambda function (require C++11)
    int th2 = th_distance * th_distance;
    int n_labels = partition(pts, labels, [th2](const Point& lhs, const Point& rhs) {
        return ((lhs.x - rhs.x)*(lhs.x - rhs.x) + (lhs.y - rhs.y)*(lhs.y - rhs.y)) < th2;
    });
    // You can save all points in the same class in a vector (one for each class), just like findContours
    vector<vector<Point>> contours(n_labels);
    for (int i = 0; i < pts.size(); ++i)
    {
        contours[labels[i]].push_back(pts[i]);
    }

    // Get bounding boxes
    vector<Rect> boxes;
    for (int i = 0; i < contours.size(); ++i)
    {
        Rect box = boundingRect(contours[i]);
        boxes.push_back(box);
    }
    // Get largest bounding box
/*    Rect largest_box = *max_element(boxes.begin(), boxes.end(), [](const Rect& lhs, const Rect& rhs) {
        return lhs.area() < rhs.area();
    });
*/
    // Draw largest bounding box in RED
    Mat3b res = img.clone();
    for(auto rect:boxes){
    rectangle(res, rect, Scalar(0, 0, 255));
    std::cout<<rect.x+rect.width/2<<","<<rect.y+rect.height/2<<endl;
}

    // Draw enlarged BOX in GREEN
/*    Rect enlarged_box = largest_box + Size(20,20);
    enlarged_box -= Point(10,10);

    rectangle(res, enlarged_box, Scalar(0, 255, 0));*/
    imshow("Result", res);
    waitKey();
    return 0;
}