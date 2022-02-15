//
//  PDFOutlineCell.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/15.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^PDFOutlineButtonBlock)(UIButton *button);

@interface PDFOutlineCell : UITableViewCell
@property (nonatomic,strong) UIButton *selBtn;
@property (nonatomic,strong) UILabel *leftLabel;
@property (nonatomic,strong) UILabel *rightLabel;
@property (nonatomic, copy) PDFOutlineButtonBlock outlineBlock;
@property(nonatomic, assign) CGFloat offsetX;

@end

NS_ASSUME_NONNULL_END
