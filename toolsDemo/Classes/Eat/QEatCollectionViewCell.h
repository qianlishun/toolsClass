//
//  QCollectionViewCell.h
//  toolsDemo
//
//  Created by mrq on 2019/4/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QEatCellModel : NSObject
@property (nonatomic,copy) NSString *title;
@end

@interface QEatCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) UILabel *descLabel;
@property(nonatomic,strong)UIButton *deleteButton;

@end

NS_ASSUME_NONNULL_END
