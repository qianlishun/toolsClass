//
//  USMarkView.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>
@class USMarkGroup;
@class USMeasure;
@class USAnnotate;
@class USMark;
@class USScrawl;

@protocol USMarkViewDelegate <NSObject>
@optional
//- (void)onSwipe:(UISwipeGestureRecognizerDirection)direction;
- (void)didUpdateMarkState;
@end
@interface USMarkView : UIView

@property (nonatomic,strong) USMarkGroup *theMarks;

@property (nonatomic,strong) USMeasure *creatingMeasure;
@property (nonatomic,strong) USMeasure *selectedMeasure;

@property (nonatomic,strong) USAnnotate *creatingAnnotate;
@property (nonatomic,strong) USAnnotate *selectedAnnotate;

@property (nonatomic,strong) USScrawl *creatingScrawl;

@property (nonatomic,assign) BOOL autoEndScrawl;

- (UIImage*)getAnchorImage:(int)anchorType selected:(BOOL)selected;

//- (void)updateMarks:(USMarkGroup*)marks;

- (void)setDelegate:(id)delegate;

- (void)clearMarks;

- (void)updateLayer;

- (UIImage*)screenImage;

- (void)addMark:(USMark*)marker;

- (void)endScrawl;
@end
