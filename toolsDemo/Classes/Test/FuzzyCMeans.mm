//
//  FuzzyCMeans.m
//  toolsDemo
//
//  Created by mrq on 2020/3/18.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "FuzzyCMeans.h"
#import "UIImage+AssetUrl.h"

@implementation FuzzyCMeans

+ (NSArray*)testFCMeauns:(UIImage*)image{
    NSLog(@"b-line START");

    Byte *pBytes = [image pixelRGBBytes];
    
    int height = image.size.height;
    int width = image.size.width;
    int top = 80;
    
    int* sourceBuf = (int*)malloc(width*2 * sizeof(int));

    int invalidCount = 0;
    int allDotCount = 0;

    for (int l=0;l<width;l++) {
        int dotCount = 0;
        for (int s=top;s<height;s++) {
//            int dot = pBytes[l*height+s];
            int index = (width*s+l)*4;
            float r = pBytes[index];
            float g = pBytes[index+1];
            float b = pBytes[index+2];
            int dot = 0.30*r + 0.59*g + 0.11*b;
            dotCount += dot;
        }
        // 去除无效数据（黑色区域）
//        if(dotCount<20*height){
//            invalidCount++;
//            continue;
//        }
        sourceBuf[(l-invalidCount)*2] = l;
        sourceBuf[(l-invalidCount)*2+1] = dotCount;
        allDotCount+=dotCount;
    }
    
    width = width - invalidCount;
    
    float avgDotCount = allDotCount / ((height - top) * width);
    
    int gain = 80, zoom = 3;
    
    float avgThreshold = (15 * (gain/80.0)*(gain/80.0) + zoom * 5);
    
    if(avgDotCount <=  avgThreshold)
        return nil;

    int* destBuf =  (int*)malloc(width * sizeof(int));

    myFCMeans(sourceBuf, destBuf, 2, width, 2, 2);
    
    NSLog(@"b-line END");
    
    NSString *kDoucuments = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *path = [kDoucuments stringByAppendingPathComponent:@"b-line.txt"];
    
    NSMutableString *mStr = [NSMutableString string];
    
    int lineIndex = 0;
    int y0 = -1;
    int y1 = -1;
    
    for (int l=0;l < width ;l++) {
        int z = destBuf[l];
//        int x = sourceBuf[l*2];
        int y = sourceBuf[l*2+1];
        if(z == 0){
            y0 = y;
        }else if(z == 1){
            y1 = y;
        }
        if( y0 != -1 && y1 != -1){
            break;
        }
    }
    
    // 筛选出哪组数据是目标数据
    if( y1 > y0){
        lineIndex = 1;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (int l=0;l < width ;l++) {
        int z = destBuf[l];
        int x = sourceBuf[l*2];
        int y = sourceBuf[l*2+1];
        if(z == lineIndex){
            NSString* str = [NSString stringWithFormat:@"(%d,%d)\t", x,y];
            [mStr appendString:str];
            [array addObject:[NSNumber numberWithInt:x]];
        }
    }
    
    NSError *error;
    [mStr writeToFile:path atomically:YES encoding:NSASCIIStringEncoding error:&error];

    free(sourceBuf);
    free(destBuf);
    if(error)
        NSLog(@"%@",error);
    
    // 分组
    NSArray<NSArray*> *sortArray = [self sortArray:array];
    
    for( int i = 0; i < sortArray.count; i++){
        NSArray *arr = sortArray[i];
        if(arr.count<2){
            [array removeObjectsInArray:arr];
            continue;
        }
        int start = [arr.firstObject intValue] - 5;
        if(start<0) start = 0;
        int end = [arr.lastObject intValue]+5;
        if(end>width-1) end = width-1;
        
        int gWidth = (end - start);
        int gHeight = (height-top);
        
        int nnIndex = 0;
        
        float aver  = 0, greyCountXY = 0.0;// vari = 0;
        unsigned short grey = 0;

        for (int y = top; y < height; y++) {
            for (int x = start; x < end; x++) {
                grey = pBytes[x*height + y];
                greyCountXY+=grey;
                nnIndex++;
            }
        }
        
        // 平均值
        aver = (float) greyCountXY / ( gWidth * gHeight );
        
        if( aver < avgDotCount + 5){
            if(array.count == arr.count)
                [array removeAllObjects];
            else
                [array removeObjectsInArray:arr];
            continue;
        }
        
                
        if(arr.count > width / 1.6){
            NSMutableArray *peakSource = [NSMutableArray array];
             for (NSNumber *n in arr) {
                 int l = n.intValue;
                 int y = sourceBuf[l*2+1];
                 [peakSource addObject:[NSNumber numberWithInt:y]];
             }
            
//            NSArray *troughIndexs = [self findPeakAndTrough:peakSource];
//            NSLog(@"%lu",(unsigned long)troughIndexs.count);
            
            // 查找波谷 (考虑是否做波谷阈值的筛选，去除小的波谷, 阈值设多少合适?)
             NSArray *troughIndexs = [self findTrough:peakSource];
             if(troughIndexs.count){
                 int minIndex = [troughIndexs[0] intValue];
                 for (int j = 0; j < troughIndexs.count; j++) {
                     int index = [troughIndexs[j] intValue];
                     int y0 = [peakSource[index] intValue];
                     int y1 = [peakSource[minIndex] intValue];
                     if(y0 < y1 && minIndex > 5 && minIndex < troughIndexs.count-5)
                         minIndex = index;
                 }
                 if([array containsObject:arr[minIndex]])
                     [array removeObject: arr[minIndex]];
             }
            [peakSource removeAllObjects];
            peakSource = nil;
        }

    }
    /*
    for (NSArray *arr in sortArray) {
        float aver  = 0, greyCountXY = 0.0 , vari = 0;
        unsigned short grey = 0;
        
        int start = [arr.firstObject intValue];
        int end = [arr.lastObject intValue];
        for (int y = top; y < height; y++) {
            for (int x = start; x < end; x++) {
                grey = pBytes[(width*y+x)*4];
                greyCountXY+=grey;
            }
        }
        
        int gWidth = (end - start);
        int gHeight = (height-top);
        
        // 平均值
         aver = (float) greyCountXY / ( gWidth * gHeight );
        
        //  方差
          for (int y = top; y < height; y++) {
              for (int x = start; x < end; x++) {
                  grey = pBytes[(width*y+x)*4];
                  if(grey<aver/2)
                      grey = aver;
                  vari = vari + (grey - aver) * (grey - aver);
              }
          }
          
          vari = vari / (gWidth * gHeight);

          float vaScale =  (vari / aver);
          
          NSLog(@"平均 %.2f 方差 %.2f .. %.2f ", aver , vari ,  (vari / aver) );
      
          if(vaScale>8){
//              [array removeObjectsInArray:arr];
          }
    }
     */
    sortArray = [self sortArray:array];
    NSLog(@"b-line count %lu", (unsigned long)sortArray.count);
    
    
    return sortArray.copy;
}


//FCM聚类，得到的结果从0开始计数
void myFCMeans(int* pSamples,int* pClusterResult,int clusterNum,int sampleNum,int featureNum,int m_Value)
{
    if (m_Value<=1 || clusterNum>sampleNum)
    {
        return;
    }
 
    int i,j,k;
    int int_temp;
 
    float* pUArr=NULL;    //隶属度矩阵
    double* pDistances=NULL;    //距离矩阵
    float* pCenters=NULL;    //聚类中心
 
    int m=m_Value;            //参数
    int Iterationtimes;    //迭代次数
    int MaxIterationTimes=100;    //最大迭代次数
    double Epslion=0.001;            //聚类停止误差
    double VarSum;    //平方误差和
    double LastVarSum;    //上一次的平方误差和
 
 
    //申请空间以及初始化
    pUArr=new float[sampleNum*clusterNum];
    pDistances=new double[sampleNum*clusterNum];
    pCenters=new float[clusterNum*featureNum];
 
    //初始化中心点
    srand((unsigned int)time(NULL));
    int_temp=rand()%sampleNum;
    for (i=0;i<clusterNum;i++)
    {
        for (j=0;j<featureNum;j++)
        {
            pCenters[i*featureNum+j]=pSamples[int_temp*featureNum+j];
        }
        
        int_temp+=(sampleNum/clusterNum);
        if (int_temp>=sampleNum)
        {
            int_temp%=sampleNum;
        }
    }
    //计算初始距离矩阵
    for (i=0;i<sampleNum;i++)
    {
        for (k=0;k<clusterNum;k++)
        {
            double distance_temp=0;
            for (j=0;j<featureNum;j++)
            {
            distance_temp+=(double)((double)(pCenters[k*featureNum+j]-pSamples[i*featureNum+j])*(pCenters[k*featureNum+j]-pSamples[i*featureNum+j]));
            }
            pDistances[i*clusterNum+k]=distance_temp;
        }
    }
 
 
    //开始聚类
    Iterationtimes=0;
    LastVarSum=0;
    VarSum=0;
    while(1)
    {
        Iterationtimes++;
        
        //更新隶属度矩阵
        //计算隶属度，聚类矩阵已更新
        for (i=0;i<sampleNum;i++)
        {
            double denominator=0;    //(1/Dik^2)^(1/(m-1))
            bool isEqualCenter=false;    //是否有距离为0的情况
            int category_temp;        //如果有距离为0的情况所判别的类
            for (k=0;k<clusterNum;k++)
            {
                double currentDis=pDistances[i*clusterNum+k];
                if (currentDis!=0)
                {
                    denominator+=pow(1.0/pDistances[i*clusterNum+k],1.0/(m-1));
                }
                else
                {
                    isEqualCenter=true;
                    category_temp=k;
                    break;
                }
            }
            //如果有距离为0的情况，就把相应类的隶属度置为1，其它为0
            if (true==isEqualCenter)
            {
                for(k=0;k<clusterNum;k++)
                {
                    pUArr[i*clusterNum+k]=0;
                }
                pUArr[i*clusterNum+clusterNum]=1.0;
            }
            else
            {
                for (k=0;k<clusterNum;k++)
                {
                    pUArr[i*clusterNum+k]=pow(1.0/pDistances[i*clusterNum+k],1.0/(m-1))/denominator;
                }
            }
        }
 
        //更新聚类中心
        for (k=0;k<clusterNum;k++)
        {
            double denominator=0;
            for (j=0;j<featureNum;j++)
            {
                double numerator=0;
                for (i=0;i<sampleNum;i++)
                {
                    double U_m_temp=pow(pUArr[i*clusterNum+k],m_Value);
                    if (0==j)
                    {
                        denominator+=U_m_temp;
                    }
                    numerator+=(U_m_temp*pSamples[i*featureNum+j]);
                }
                pCenters[k*featureNum+j]=numerator/denominator;
            }
        }
 
        //计算平方误差函数值，并更新距离矩阵
        VarSum=0;
        for (i=0;i<sampleNum;i++)
        {
            for (k=0;k<clusterNum;k++)
            {
                double distance_temp=0;
                for (j=0;j<featureNum;j++)
                {
                    distance_temp+=(double)((double)(pCenters[k*featureNum+j]-pSamples[i*featureNum+j])
                        *(pCenters[k*featureNum+j]-pSamples[i*featureNum+j]));
                }
                pDistances[i*clusterNum+k]=distance_temp;
                VarSum+=(pow(pUArr[i*clusterNum+k],1.0/m)*distance_temp);        //存在溢出危险
            }
        }
 
        if (Iterationtimes>=MaxIterationTimes || fabsl(VarSum-LastVarSum)<=Epslion)
        {
            break;
        }
        LastVarSum=VarSum;
    }
    delete[] pDistances;
    pDistances=NULL;
    delete[] pCenters;
    pCenters=NULL;
 
    //分类,归为隶属度最大的那一类
    for (i=0;i<sampleNum;i++)
    {
        float maxU = 0.0    ;        //最大隶属度
        int Category = 0;    //属于类别
        for (k=0;k<clusterNum;k++)
        {
            if (0==k || maxU<pUArr[i*clusterNum+k])
            {
                Category=k;
                maxU=pUArr[i*clusterNum+k];
            }
        }
        pClusterResult[i]=Category;
    }
 
    delete[] pUArr;
    pUArr=NULL;
}

+ (NSArray*)sortArray:(NSArray*)arr {
    int count = 0;
    NSMutableArray *array = [NSMutableArray array];
    if (!arr.count) {
        return 0;
    }else {
        NSMutableArray *temp = [NSMutableArray arrayWithObject:arr[0]];
        
        for (int i = 1; i < arr.count; i++) {
            if ([arr[i] intValue] == [arr[i - 1] intValue] + 1) {
                [temp addObject:arr[i]];
            }else {
                if(temp.count >= 5){
                    [array addObject:temp.copy];
                    count++;
                }
                temp = [NSMutableArray arrayWithObject:arr[i]];
            }
        }
        if(temp.count >= 5){
            [array addObject:temp.copy];
            count++;
        }
    }
    return array.copy;
}


// 查询波谷
+ (NSArray*)findTrough:(NSArray*)v{
    
    int width = (int)v.count;
    
    NSMutableArray *diff_v = [NSMutableArray array];
    for (int i = 0; i < width; i++) {
        diff_v[i] = @0;
    }
    // 计算V的一阶差分和符号函数trend
    for (int i = 0; i < width-1; i++){
        if ([v[i + 1] intValue] - [v[i] intValue] > 0){
            diff_v[i] = @1;
        }else if ([v[i + 1] intValue] - [v[i] intValue] < 0){
            diff_v[i] = @-1;
        }else{
            diff_v[i] = @0;
        }
     }
     // 对Trend作了一个遍历
     for (int i = width - 1; i >= 0; i--){
         if ([diff_v[i] intValue] == 0 && i ==width-1){
             diff_v[i] = @1;
         }else if (diff_v[i] == 0){
             if ([diff_v[i + 1] intValue] >= 0){
                 diff_v[i] = @1;
             }else{
                 diff_v[i] = @-1;
             }
         }
     }
    NSMutableArray *array = [NSMutableArray array];
     for (int i = 0; i < width - 1; i++)
     {
         if ([diff_v[i + 1] intValue] - [diff_v[i] intValue] == 2) // 2 为波谷
            [array addObject:[NSNumber numberWithInt:i+1]];
     }
    
    return array.copy;
 }

@end
