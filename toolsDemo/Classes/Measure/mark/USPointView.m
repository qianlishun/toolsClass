//
//  USPointView.m
//  SmartUS
//
//  Created by mrq on 2017/4/28.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USPointView.h"


@implementation USPointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userInteractionEnabled = YES;

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (instancetype)initWithPoint:(CGPoint)point ImageName:(NSString *)name{
    self = [[USPointView alloc] initWithFrame:CGRectMake(point.x-kPointWidth/2, point.y-kPointWidth/2, kPointWidth, kPointWidth)];
    if (self) {
        self.alpha = 0.6;
        [self setImage:[UIImage imageNamed:name]];
    }
    return self;
}

@end
