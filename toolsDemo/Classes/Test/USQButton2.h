//
//  USQButton.h
//  MyTechUS_iOS
//
//  Created by mrq on 2020/1/9.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface USQButton2 : UIControl

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UIImageView *imageBgView;
@property (nonatomic,strong) UILabel *titleLabel;

@property(nonatomic,assign) BOOL usEnabled;

- (void)setImage:(UIImage*)image forState:(UIControlState)state;

- (void)setBackgroundImage:(UIImage*)image forState:(UIControlState)state;

- (void)setTitle:(NSString*)title forState:(UIControlState)state;

- (void)setTitleColor:(UIColor*)color forState:(UIControlState)state;

//- (void)setBackgroundColor:(UIColor *)backgroundColor;
@end

NS_ASSUME_NONNULL_END
