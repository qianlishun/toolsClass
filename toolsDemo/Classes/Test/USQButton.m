//
//  USQButton.m
//  MyTechUS_iOS
//
//  Created by mrq on 2020/1/9.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import "USQButton.h"
#import "UIColor+Common.h"

static BOOL highLight = NO;
static UIColor *originColor;

@implementation USQButton{
    UIImage *normalImage;
    UIImage *lightImage;
    
    UIImage *normalImage2;

    UIImage *bgNormalImage;
    UIImage *bgLightImage;

    USQButtonPosition titlePostion;

    USQButtonPosition imagePostion;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initButton];
    }
    return self;
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
    titlePostion = USQButton_Center;
    imagePostion = USQButton_Left;
    
    self.imageView = [[UIImageView alloc]init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.imageBgView = [[UIImageView alloc]init];
    self.titleLabel = [UILabel new];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    
    [self addSubview:self.imageBgView];
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat w = self.width/10.0;
    CGFloat h = self.height;
    float imageScale =  1.25;
    [self.imageBgView setFrame:self.bounds];
    if(self.imageView.image==nil){
        self.imageView.hidden = YES;
        [self.titleLabel setFrame:CGRectMake(0, 0, w*10, h)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }else{
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.imageView.hidden = NO;
        [self.titleLabel sizeToFit];
        self.titleLabel.x = self.width*0.3;
        self.titleLabel.centerY = h/2;
        
        if(titlePostion == USQButton_Left){
            self.titleLabel.x = w;
        }else if(titlePostion == USQButton_Right){
            self.titleLabel.x = self.width-w - self.titleLabel.width;
        }
        float imageH = self.titleLabel.height*imageScale;
        [self.imageView setFrame:CGRectMake(0, (h - imageH)/2.0, self.width/4, imageH)];
        CGFloat x = 0;
        if(imagePostion == USQButton_Center)
            x = self.width/2.0 - self.imageView.width/2;
        else if(imagePostion == USQButton_Right)
            x = self.width - self.imageView.width;
        self.imageView.x = x;
    }
    if(!self.imageView2) return;
    
    if(self.imageView2.image==nil){
        self.imageView2.hidden = YES;
    }else{
        float imageH = self.titleLabel.height*imageScale;
        self.imageView.hidden = NO;
        [self.imageView2 setFrame:CGRectMake(self.width*3/4.0, (h - imageH)/2.0, self.width/4.0, imageH)];
    }
}

- (void)setImage:(UIImage*)image forState:(UIControlState)state{
    if(state == UIControlStateNormal){
        normalImage = image;
        self.imageView.image = image;
    }else{
        lightImage = image;
    }
}

- (void)setImage2:(UIImage *)image forState:(UIControlState)state{
    if(!_imageView2){
        self.imageView2 = [[UIImageView alloc]init];
        self.imageView2.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView2];
    }
    normalImage2 = image;
    self.imageView2.image = image;
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
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    self.titleLabel.textColor = color;
}

- (void)setHighlighted:(BOOL)highlighted{
    if(highlighted){
        self.imageView.image = lightImage ?: normalImage;
        self.imageBgView.image = bgLightImage ?: bgNormalImage;
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


- (void)setTouchHighLight:(BOOL)touchHighLight{
    highLight = touchHighLight;
    originColor = self.titleLabel.textColor;
}

- (BOOL)touchHighLight{
    return highLight;
}

- (void)setTitlePosition:(USQButtonPosition)postion{
    titlePostion = postion;
    [self layoutIfNeeded];
}

- (void)setImagePosition:(USQButtonPosition)postion{
    imagePostion = postion;
    [self layoutIfNeeded];
}

- (void)endTrackingWithTouch:(nullable UITouch *)touch withEvent:(nullable UIEvent *)event{

    [super endTrackingWithTouch:touch withEvent:event];

    __block UIColor *tColor = self.titleLabel.textColor;
    [self.titleLabel setTextColor:[tColor inverseColor]];
    self.alpha = 0.6;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.titleLabel setTextColor:tColor];
        self.alpha = 1.0;
    });
}

@end
