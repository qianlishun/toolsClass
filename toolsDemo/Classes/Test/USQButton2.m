//
//  USQButton.m
//  MyTechUS_iOS
//
//  Created by mrq on 2020/1/9.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import "USQButton2.h"
#import "UIColor+Common.h"

@implementation USQButton2{
    UIImage *normalImage;
    UIImage *lightImage;
    
    UIImage *bgNormalImage;
    UIImage *bgLightImage;

//    UIColor *textColor;
//    UIColor *disableTextColor;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initButton];
    }
    return self;
}

- (void)initButton{
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageBgView = [[UIImageView alloc]init];
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:self.imageBgView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)updateStyle{
    if(self.imageView.image==nil){
        self.titleLabel.font = FONT_SIZE;
    }else if(self.titleLabel.text.length == 0){

    }else{
        self.titleLabel.font = FONT_SMALLSIZE;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat w = self.width/10.0;
    CGFloat h = self.height;

    [self.imageView setFrame:CGRectMake(w, 0, w*4, h)];
    [self.imageBgView setFrame:self.bounds];
    if(self.imageView.image==nil){
        self.imageView.hidden = YES;
        [self.titleLabel setFrame:CGRectMake(0, 0, w*10, h)];
    }else if(self.titleLabel.text.length == 0){
        self.imageView.hidden = NO;
        [self.imageView setFrame:CGRectMake(0, 0, self.width, self.height)];
    }else{
        self.imageView.hidden = NO;
        
        float imageH = h*4/5.0;
        float imageW = self.imageView.image.size.width * imageH / self.imageView.image.size.height;
        [self.imageView setFrame:CGRectMake(0, 0, imageW, imageH)];
        self.imageView.centerX = self.width/2.0;

        [self.titleLabel setFrame:CGRectMake(w, h*3/5.0, w*8, h*2/5.0)];
    }
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state{
    if(state == UIControlStateNormal){
        normalImage = image;
        self.imageView.image = image;
    }else{
        lightImage = image;
    }
    [self updateStyle];
}

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state{
    if(state == UIControlStateNormal){
        bgNormalImage = image;
        self.imageBgView.image = image;
    }else{
        bgLightImage = image;
    }
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    self.titleLabel.text = title;
    [self updateStyle];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    if(state == UIControlStateNormal)
        self.titleLabel.textColor = color;
}

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        if(lightImage){
            self.imageView.image = lightImage;
        }
        if(bgLightImage){
            self.imageBgView.image = bgLightImage;
        }
    }else{
        self.imageView.image = normalImage;
        self.imageBgView.image = bgNormalImage;
    }
}

- (void)setUsEnabled:(BOOL)usEnabled{
    self.enabled = usEnabled;
    
    if (usEnabled){
        for (UIView *v in self.subviews) {
            [v setAlpha:1.0];
        }
    }else{
        for (UIView *v in self.subviews) {
            [v setAlpha:0.6];
        }
    }
}

- (BOOL)usEnabled{
    return self.enabled;
}

- (void)sendActionsForControlEvents:(UIControlEvents)controlEvents{
    [super sendActionsForControlEvents:controlEvents];
    
    [self highLightAnimation];
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event{

    [super endTrackingWithTouch:touch withEvent:event];

    [self highLightAnimation];
}

- (void)highLightAnimation{
    __block UIColor *tColor = self.titleLabel.textColor;
    [self.titleLabel setTextColor:[tColor inverseColor]];
    self.alpha = 0.6;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleLabel setTextColor:tColor];
        self.alpha = 1.0;
    });
}
@end
