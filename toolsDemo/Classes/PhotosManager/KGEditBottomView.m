//
//  KGEditBottomView.m
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import "KGEditBottomView.h"

#define KGBundle(name,type) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"KGLibary" ofType:@"bundle"]] pathForResource:name ofType:type]

@implementation KGEditBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"KGEditBottomView" owner:self options:nil] lastObject];
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];
        
        [self.editBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"图层", @"png")] forState:UIControlStateNormal];
        [self.retoBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"旋转", @"png")] forState:UIControlStateNormal];
        [self.scaleBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"缩放", @"png")] forState:UIControlStateNormal];
        [self.returnBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"撤销", @"png")] forState:UIControlStateNormal];
        [self.shureBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"对号", @"png")] forState:UIControlStateNormal];
        
        self.editBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.retoBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.scaleBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.returnBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.shureBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

- (IBAction)editAction:(UIButton *)sender {
    self.editBtu.layer.borderColor = [UIColor whiteColor].CGColor;
    self.retoBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.scaleBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.returnBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.shureBtu.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.editModeBlock) {
        self.editModeBlock();
    }
}

- (IBAction)rotateAction:(UIButton *)sender {
    self.editBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.retoBtu.layer.borderColor = [UIColor whiteColor].CGColor;
    self.scaleBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.returnBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.shureBtu.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.retoModeBlock) {
        self.retoModeBlock();
    }
}

- (IBAction)scaleAction:(UIButton *)sender {
    self.editBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.retoBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.scaleBtu.layer.borderColor = [UIColor whiteColor].CGColor;
    self.returnBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.shureBtu.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.scaleModeBlock) {
        self.scaleModeBlock();
    }
}

- (IBAction)undoAction:(UIButton *)sender {
    self.editBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.retoBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.scaleBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.returnBtu.layer.borderColor = [UIColor whiteColor].CGColor;
    self.shureBtu.layer.borderColor = [UIColor clearColor].CGColor;
    if (self.undoModeBlock) {
        self.undoModeBlock();
    }
}

- (IBAction)setNormalAction:(UIButton *)sender {
    self.editBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.retoBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.scaleBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.returnBtu.layer.borderColor = [UIColor clearColor].CGColor;
    self.shureBtu.layer.borderColor = [UIColor whiteColor].CGColor;
    if (self.setNormalBlock) {
        self.setNormalBlock();
    }
}



@end
