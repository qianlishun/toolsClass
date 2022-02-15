//
//  QStateModel.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/6/22.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import "QStateModel.h"
#import <sys/utsname.h>

@interface QStateModel()
@property(nonatomic, strong) NSUserDefaults *ud;
@end

@implementation QStateModel


+ (instancetype)sharedInstance{
    static QStateModel *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[QStateModel alloc]init];
    });
    return shared;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        struct utsname systemInfo;
        uname(&systemInfo);
        _machine = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

        self.edgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        
        self.ud = [NSUserDefaults standardUserDefaults];
        
        self.pdfSaveData = [self.ud dictionaryForKey:@"pdfSaveData"];
    }
    return self;
}

- (void)setPdfSaveData:(NSDictionary *)pdfSaveData{
    _pdfSaveData = pdfSaveData;
    
    [_ud setObject:pdfSaveData forKey:@"pdfSaveData"];
}

+ (void)createFolderPath:(NSString*)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    if(isDirExist)
        NSLog(@"folder is exist");
    if(!(isDirExist && isDir)){
        BOOL bCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir){
            NSLog(@"creat folder failed！");
        }else{
            NSLog(@"creat folder successed: %@",path);
        }
    }
}
    
@end
