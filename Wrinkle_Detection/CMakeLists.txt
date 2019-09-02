cmake_minimum_required(VERSION 2.8)
add_compile_options(-std=c++11 -O3)
project( Wrinkle )
find_package( OpenCV REQUIRED )

include_directories(include)
add_executable(image_poly
  main.cpp
  image_polygon.cpp
  include/image_polygon.hpp
)
target_link_libraries( image_poly ${OpenCV_LIBS} )

add_executable (scroll scroll.cpp)
target_link_libraries (scroll ${OpenCV_LIBS})


add_executable (test test.cpp)
target_link_libraries (test ${OpenCV_LIBS})
