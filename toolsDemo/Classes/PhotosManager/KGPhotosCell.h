//
//  KGPhotosCell.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/8.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGPhotosCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UIView *chooseMask;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImg;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@end

NS_ASSUME_NONNULL_END
