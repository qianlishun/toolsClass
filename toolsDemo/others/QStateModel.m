//
//  QStateModel.m
//  toolsDemo
//
//  Created by Qianlishun on 2021/6/22.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import "QStateModel.h"
#import <sys/utsname.h>


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
    }
    return self;
}

    
@end
