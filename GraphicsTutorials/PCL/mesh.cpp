
#include <iostream>
#include <thread>
#include <string>
#include <map> 

#include <pcl/common/common_headers.h>
#include <pcl/features/normal_3d.h>
#include <pcl/io/pcd_io.h>
#include <pcl/visualization/pcl_visualizer.h>
#include <pcl/console/parse.h>

using namespace std::chrono_literals;

float xmin=-50,xmax=50,ymin=-50,ymax=50;
int space=10;

pcl::visualization::PCLVisualizer::Ptr shapesVis (pcl::PointCloud<pcl::PointXYZRGB>::ConstPtr cloud)
{
  // --------------------------------------------
  // -----Open 3D viewer and add point cloud-----
  // --------------------------------------------
  pcl::visualization::PCLVisualizer::Ptr viewer (new pcl::visualization::PCLVisualizer ("3D Viewer"));
  viewer->setBackgroundColor (0, 0, 0);
  //pcl::visualization::PointCloudColorHandlerRGBField<pcl::PointXYZRGB> rgb(cloud);
  //viewer->addPointCloud<pcl::PointXYZRGB> (cloud, rgb, "sample cloud");
  //viewer->setPointCloudRenderingProperties (pcl::visualization::PCL_VISUALIZER_POINT_SIZE, 3, "sample cloud");
  viewer->addCoordinateSystem (1.0);
  viewer->initCameraParameters ();
  std::map<int,float> m;
  
  for(size_t i=0;i<cloud->points.size();i++)
  {
    m[int((cloud->points[i].x+xmin)*10000+cloud->points[i].y)]=cloud->points[i].z; 
  }

  //------------------------------------
  //-----Add shapes at cloud points-----
  //------------------------------------
 /* for(size_t i=0;i<cloud->points.size();i++)
    for(size_t j=0;j<cloud->points.size();j++){
      int k = 10*i+j;
      std::string out_string;
      std::stringstream ss;
      ss << i;
      out_string = ss.str();
      std::string name="line"+out_string;
       viewer->addLine<pcl::PointXYZRGB> (cloud->points[i],cloud->points[j],name);
     }*/

for(int i=0;i<int(xmax-xmin);i=i+space)
{
  for(int j=space;j<=int(ymax-ymin);j=j+space)
  {
      int k = 10000*i+j;
      std::string out_string;
      std::stringstream ss;
      ss << k;
      out_string = ss.str();
      std::string name="line"+out_string;

      pcl::PointXYZRGB point_1;
      point_1.x = float(i+xmin);
      point_1.y = float(j+ymin);
      point_1.z = 1;


      pcl::PointXYZRGB point_2;
      point_2.x = float(i+xmin-space);
      point_2.y = float(j+ymin);
      point_2.z = 1;

     
      viewer->addLine<pcl::PointXYZRGB> (point_1,point_2,name);
  }
}

for(int i=0;i<int(ymax-ymin);i=i+space)
{
  for(int j=space;j<=int(xmax-xmin);j=j+space)
  {
      int k = 10000*i+j;
      std::string out_string;
      std::stringstream ss;
      ss << k;
      out_string = ss.str();
      std::string name="line"+out_string;

      pcl::PointXYZRGB point_1;
      point_1.x = float(i+xmin);
      point_1.y = float(j+ymin);
      point_1.z = 1;


      pcl::PointXYZRGB point_2;
      point_2.x = float(i+xmin);
      point_2.y = float(j+ymin-space);
      point_2.z = 1;

     
      viewer->addLine<pcl::PointXYZRGB> (point_1,point_2,name+"horizontal");
  }
}


 
  // viewer->addSphere (cloud->points[0], 0.2, 0.5, 0.5, 0.0, "sphere");

  // //---------------------------------------
  // //-----Add shapes at other locations-----
  // //---------------------------------------
  /*pcl::ModelCoefficients coeffs;
  coeffs.values.push_back (0.0);
  coeffs.values.push_back (0.0);
  coeffs.values.push_back (1.0);
  coeffs.values.push_back (0.0);
  viewer->addPlane (coeffs, "plane");*/
  // coeffs.values.clear ();
  // coeffs.values.push_back (0.3);
  // coeffs.values.push_back (0.3);
  // coeffs.values.push_back (0.0);
  // coeffs.values.push_back (0.0);
  // coeffs.values.push_back (1.0);
  // coeffs.values.push_back (0.0);
  // coeffs.values.push_back (5.0);
  // viewer->addCone (coeffs, "cone");

  return (viewer);
}


// --------------
// -----Main-----
// --------------
int
main (int argc, char** argv)
{
  // ------------------------------------
  // -----Create example point cloud-----
  // ------------------------------------
  // pcl::PointCloud<pcl::PointXYZ>::Ptr basic_cloud_ptr (new pcl::PointCloud<pcl::PointXYZ>);
  pcl::PointCloud<pcl::PointXYZRGB>::Ptr point_cloud_ptr (new pcl::PointCloud<pcl::PointXYZRGB>);
  std::cout << "Generating example point clouds.\n\n";
  // We're going to make an ellipse extruded along the z-axis. The colour for
  // the XYZRGB cloud will gradually go from red to green to blue.
  uint8_t r(100), g(100), b(100);
 /* for (float z(-1.0); z <= 1.0; z += 0.05)
  {
    for (float angle(0.0); angle <= 360.0; angle += 5.0)
    {
      pcl::PointXYZ basic_point;
      basic_point.x = 0.5 * cosf (pcl::deg2rad(angle));
      basic_point.y = sinf (pcl::deg2rad(angle));
      basic_point.z = z;
      basic_cloud_ptr->points.push_back(basic_point);

      pcl::PointXYZRGB point;
      point.x = basic_point.x;
      point.y = basic_point.y;
      point.z = basic_point.z;
      uint32_t rgb = (static_cast<uint32_t>(r) << 16 |
              static_cast<uint32_t>(g) << 8 | static_cast<uint32_t>(b));
      point.rgb = *reinterpret_cast<float*>(&rgb);
      point_cloud_ptr->points.push_back (point);
    }
    if (z < 0.0)
    {
      r -= 12;
      g += 12;
    }
    else
    {
      g -= 12;
      b += 12;
    }
  }*/

  for(float x=xmin;x<=xmax;x=x+space)
  {
    for(float y=ymin;y<=ymax;y=y+space)
    {
      pcl::PointXYZRGB basic_point;
      basic_point.x = x;
      basic_point.y = y;
      basic_point.z = 1.0;
      basic_point.r = r;
      basic_point.g = g;
      basic_point.b = b;
      point_cloud_ptr->points.push_back(basic_point);
    }
  }
  point_cloud_ptr->width = (int) point_cloud_ptr->points.size ();
  point_cloud_ptr->height = 1;
  pcl::visualization::PCLVisualizer::Ptr viewer;
  
  viewer = shapesVis(point_cloud_ptr);
  while (!viewer->wasStopped ())
  {
    viewer->spinOnce (100);
    std::this_thread::sleep_for(100ms);
  }
}