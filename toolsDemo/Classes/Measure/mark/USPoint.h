//
//  USPoint.h
//  SmartUSLibrary
//
//  Created by 吴文斌 on 2017/4/13.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
@interface USPoint : NSObject

@property(nonatomic)    float x;
@property(nonatomic)    float y;


-(USPoint*)initWith: (float)x and: (float)y;

- (CGPoint)CGPoint;
@end
