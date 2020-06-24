//
//  USMeasure.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMark.h"

typedef enum{
    ANCHOR_TYPE0 = 0,
    ANCHOR_TYPE1,
    ANCHOR_TYPE2,
    ANCHOR_TYPE3,
}ANCHOR_TYPE;
@interface Anchor : NSObject{
    @public
    float positionX;
    float positionY;
    int anchorType;
    UIImage *anchorImage;
    UIImage *selectedImage;
}
- (instancetype)initWithX:(float)x Y:(float)y anchorType:(ANCHOR_TYPE)type;
- (Anchor*)hitTest:(USPoint*)point;
- (void)drawWith:(CAShapeLayer*)layer selected:(BOOL)selected;
- (CGPoint)CGPoint;
@end

@interface USRect : NSObject{
    @public
    float left;
    float top;
    float width;
    float height;
}
- (instancetype)initWithLeft:(float)l top:(float)t width:(float)w height:(float)h;
- (USRect*)offsetDx:(float)dx dy:(float)dy;
- (BOOL)pointInRectX:(float)x y:(float)y;

@end

@interface USMeasure : USMark{
    @public
    BOOL isResultSelected;
    float scale;
//    Anchor *anchor;
    @protected
    int anchorType;
    UIImage *anchorImage;
    UIImage *selectedImage;
    USRect *resultRect;
    BOOL resultSelected;
    float fontSize;
}

@property (nonatomic,weak) USRawImage *rawImage;

- (void)addAnchor:(USPoint*)point;

- (void)setAnchorType:(ANCHOR_TYPE)type;
- (ANCHOR_TYPE)getAnchorType;
- (void)setAnchorImage:(UIImage*)image selectedImage:(UIImage*)selectedImg;

- (void)setResultRect:(USRect*)rect;
- (USRect*)getResultRect;

- (Anchor*)getSelectedAnchor;

- (BOOL)isResultSelected;
- (void)cancelResultSelected;

- (BOOL)resultHitTest:(USPoint*)point;

- (void)setScale:(float)s;
- (void)setResultFontSize:(float)size;

//- (int)calGa:(float)value index:(NSArray *)index ga:(NSArray *)ga;

- (int)resultRowCount;
@end
