//
//  KGEditPhotoCell.h
//  KGPhotosLibary
//
//  Created by 北师智慧 on 2020/5/9.
//  Copyright © 2020 Heart likes static water. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KGEditPhotoCell : UICollectionViewCell

- (void)contentWithDic:(NSDictionary *)dic;

- (void)editImg:(BOOL)allow;

@end

NS_ASSUME_NONNULL_END
