//
//  KGChangeImgSizeView.m
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import "KGChangeImgSizeView.h"

@implementation KGChangeImgSizeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.mainView = [[[NSBundle mainBundle] loadNibNamed:@"KGChangeImgSizeView" owner:self options:nil] lastObject];
        self.mainView.frame = self.bounds;
        [self addSubview:self.mainView];
    }
    return self;
}

- (IBAction)tailorFourAction:(UIButton *)sender {
    if (self.typeOf4Than3Block) {
        self.typeOf4Than3Block();
    }
}

- (IBAction)tailorsixthAction:(UIButton *)sender {
    if (self.typeOf16Than9Block) {
        self.typeOf16Than9Block();
    }
}

- (IBAction)tailorEqWidth:(UIButton *)sender {
    if (self.typeOfEqurlBlock) {
        self.typeOfEqurlBlock();
    }
}

- (IBAction)tailorThreeAction:(UIButton *)sender {
    if (self.typeOf3Than4Block) {
        self.typeOf3Than4Block();
    }
}

- (IBAction)tailorNineAction:(UIButton *)sender {
    if (self.typeOf9Than16Block) {
        self.typeOf9Than16Block();
    }
}

- (IBAction)tailorCustomAction:(UIButton *)sender {
    if (self.typeOfCustomBlock) {
        self.typeOfCustomBlock();
    }
}


@end
