//
//  QGestureRecognizer.h
//  toolsDemo
//
//  Created by mrq on 2019/1/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    USGestureTypeSinglePan,
    USGestureTypeDoublePan,
    USGestureTypePinch,
} USGestureType;

@protocol USGestureRecognizerDelegate <NSObject>

@optional
- (void)onUSGestureTranslation:(CGPoint)translation withUSGestureType:(USGestureType)gestureType;

@end

@interface USGestureRecognizer : UIGestureRecognizer

- (void)setDelegate:(id)delegate;

@end

