//
//  USQButton.h
//  MyTechUS_iOS
//
//  Created by mrq on 2020/1/9.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    USQButton_Left,
    USQButton_Center,
    USQButton_Right,
}  USQButtonPosition;

@interface USQButton : UIControl

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *imageView2;
@property (nonatomic,strong) UIImageView *imageBgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,assign) BOOL touchHighLight;
@property(nonatomic,assign) BOOL usEnabled;

- (void)setImage:(UIImage*)image forState:(UIControlState)state;

- (void)setImage2:(UIImage*)image forState:(UIControlState)state;

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state;

- (void)setTitle:(NSString*)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state;

//- (void)setBackgroundColor:(UIColor *)backgroundColor;

- (void)setImagePosition:(USQButtonPosition)postion;

- (void)setTitlePosition:(USQButtonPosition)postion;

@end

NS_ASSUME_NONNULL_END
