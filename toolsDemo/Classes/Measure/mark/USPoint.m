//
//  USPoint.m
//  SmartUSLibrary
//
//  Created by 吴文斌 on 2017/4/13.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USPoint.h"

@implementation USPoint
-(USPoint*)initWith: (float)x and: (float)y
{
    self = [super init];
    self.x = x;
    self.y = y;
    return self;
}

- (CGPoint)CGPoint{
    return CGPointMake(self.x, self.y);
}

@end
