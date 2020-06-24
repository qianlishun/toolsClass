//
//  USMeasureArea.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasure.h"

@interface USMeasureArea : USMeasure{
@protected
    Anchor *firstAnchor;
    Anchor *secondAnchor;
    Anchor *thirdAnchor;

    Anchor *selectedAnchor;
    
@public
    USPoint *backPoint;
}

- (float)calcArea;

- (float)calcCircum;

- (void)drawResult:(CAShapeLayer*)layer;

@end
