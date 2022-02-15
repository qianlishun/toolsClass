//
//  PDFThumbnailViewController.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PDFThumbnailViewController;

@protocol PDFThumbnailDelegate <NSObject>
- (void)thumbnailViewController:(PDFThumbnailViewController *)controller didSelectAtIndex:(NSIndexPath *)selection;
@end

@interface PDFThumbnailViewController : UIViewController
@property(nonatomic, strong) PDFDocument *document;
@property(nonatomic, weak) id<PDFThumbnailDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
