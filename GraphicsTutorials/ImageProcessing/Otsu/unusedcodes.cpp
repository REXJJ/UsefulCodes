Mat otsu_binarization(vector<int> A,Mat img)
{
std::vector<int> hist(256, 0);
std::vector<double> prob(256, 0.0);
double max_sigma=-1.0;
int threshold=0,N=A.size();
for(int i=0;i<A.size();i++) hist[A[i]]++;
unsigned long long int sum=0;
for(int i=0;i<256;i++) sum+=i*hist[i];

for(int i=0;i<256;i++)
{
    int w0=0,w1=0;
    unsigned long long int sum2=0;
    w0+=hist[i];
    if(!w0) continue;
    w1=N-w0;
    sum2+=i*hist[i];
    double u0=sum2/w0,u1=(sum-sum2)/w1;
    double sigma2=double(w0*w1)*(u0-u1)*(u0-u1);
    if(sigma2-max_sigma>FLT_EPSILON) {
        max_sigma=sigma2;
        threshold=i;
    }
}
cout<<threshold;
Mat img_bw;
// cv::threshold(img, img_bw, threshold, 255, CV_THRESH_BINARY);
cv::threshold(img, img_bw, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
return img_bw;
}

Mat otsu_binarization(vector<int> A,Mat img)
{
std::vector<int> hist(256, 0);
std::vector<double> prob(256, 0.0);
std::vector<double> mu(256, 0.0);
std::vector<double> sigma(256, 0.0);
double max_sigma=-1.0;
int threshold=0;
for(int i=0;i<A.size();i++) hist[A[i]]++;
prob[0] = hist[0]/double(A.size());
for(int i=1;i<256;i++) {
    prob[i]=prob[i-1]+double(hist[i])/double(A.size());
    mu[i]=mu[i-1]+hist[i]*i;
}
for(int i = 0; i < 255; i++) {
        if(prob[i] != 0.0 && prob[i] != 1.0)
            sigma[i] = pow(mu[255] * prob[i] - mu[i], 2) / (prob[i] * (1.0 - prob[i]));
    else
        sigma[i] = 0.0;
        if(sigma[i] > max_sigma) {
            max_sigma = sigma[i];
            threshold = i;
 
}

}
cout<<threshold;
float histogram[256];
for(int i=0;i<256;i++)
    histogram[i]=float(hist[i])/float(A.size());
//threshold=otsu_method(histogram,A.size());
std::cout<<threshold;
Mat img_bw;
cv::threshold(img, img_bw, threshold, 255, CV_THRESH_BINARY);
// cv::threshold(img, img_bw, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);

return img_bw;
}


Mat otsu_binarization(vector<int> A,Mat img)
{
std::vector<int> hist(256, 0);
std::vector<double> prob(256, 0.0);
std::vector<double> mu(256, 0.0);
double max_sigma=-1.0;
int threshold=0;
for(int i=0;i<A.size();i++) hist[A[i]]++;
prob[0] = hist[0]/double(A.size());
for(int i=1;i<256;i++) {
    prob[i]=prob[i-1]+double(hist[i])/double(A.size());
    mu[i]=mu[i-1]+prob[i];
}
for(int i=1;i<256;i++)
{
    double w0=0.0,w1=0.0,u0=0.0,u1=0.0,sigma2=0.0;
    for(int j=0;j<i;j++)
    {
        u0=u0+j*prob[j];
        w0=w0+prob[j];
    }
    for(int j=i;j<256;j++)
    {
        u1=u1+j*prob[j];
        w1=w1+prob[j];
    }
if(min(w1,w0)<FLT_EPSILON||max(w1,w0)>1.0) continue;

sigma2=w0*w1*(u0-u1)*(u0-u1);
if(sigma2-max_sigma>FLT_EPSILON) {
    max_sigma=sigma2;
    threshold=i;
}

}
cout<<threshold;
float histogram[256];
for(int i=0;i<256;i++)
    histogram[i]=float(hist[i])/float(A.size());
//threshold=otsu_method(histogram,A.size());
std::cout<<threshold;
Mat img_bw;
cv::threshold(img, img_bw, threshold, 255, CV_THRESH_BINARY);
// cv::threshold(img, img_bw, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);

return img_bw;
}
