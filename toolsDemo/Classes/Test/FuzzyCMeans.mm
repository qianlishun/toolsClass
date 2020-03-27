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
    int top = 30;
    
    int* sourceBuf = (int*)malloc(width*2 * sizeof(int));
    int* destBuf =  (int*)malloc(width * sizeof(int));

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
        sourceBuf[l*2] = l;
        sourceBuf[l*2+1] = dotCount;
    }
    
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
    
    // 连续性 校验
    [array enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(NSNumber *num, NSUInteger idx, BOOL * _Nonnull stop) {
       int x = num.intValue;
       int avgGrey = sourceBuf[x*2+1] / height * 0.8;
       int lianxuCount = 0;
       int lianxuCountMax = 0;
       int notLianxuCount = 0;
       for (int y = 0; y < height; y++) {
           int grey = pBytes[x*height + y];
           if(grey > 50 && grey > avgGrey){
               lianxuCount ++;
               notLianxuCount = 0;
           }else{
               notLianxuCount++;
           }
           if(notLianxuCount>5){
               lianxuCount = 0;
               notLianxuCount = 0;
           }
           if(lianxuCount > lianxuCountMax)
                lianxuCountMax = lianxuCount;
        }
       if(lianxuCountMax<50){
           [array removeObject:num];
       }
    }];

    
    
    return array.copy;
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

@end
