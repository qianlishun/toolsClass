//
//  USMeasureAngle.h
//  WirelessUSG3
//
//  Created by mrq on 2017/11/20.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasure.h"

@interface USMeasureAngle : USMeasure{
@protected
    Anchor *firstAnchor;
    Anchor *secondAnchor;
    Anchor *thirdAnchor;
    
    Anchor *selectedAnchor;
    
}

- (float)calcAngle;

- (void)drawResult:(CAShapeLayer*)layer;

@end

