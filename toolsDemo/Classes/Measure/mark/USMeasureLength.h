//
//  USMeasureLength.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMeasure.h"

@interface USMeasureLength : USMeasure{
    @protected
    Anchor *firstAnchor;
    Anchor *secondAnchor;
    Anchor *selectedAnchor;
}

- (float)calcLength;

- (void)drawResult:(CAShapeLayer*)layer;

@end
