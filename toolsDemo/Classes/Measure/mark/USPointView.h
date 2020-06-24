//
//  USPointView.h
//  SmartUS
//
//  Created by mrq on 2017/4/28.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kPointWidth 25
#define kCurvePointWidth 28

@interface USPointView : UIImageView<NSCoding>


- (instancetype)initWithPoint:(CGPoint)point ImageName:(NSString *)name;

@end
