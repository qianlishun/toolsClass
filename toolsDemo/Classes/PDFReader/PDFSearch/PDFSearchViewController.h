//
//  PDFSearchViewController.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

@class PDFSearchViewController;

@protocol PDFSearchDelegate <NSObject>
- (void)searchViewController:(PDFSearchViewController *)controller didSelectSearchResult:(PDFSelection *)selection;
@end

@interface PDFSearchViewController : UIViewController
@property(nonatomic, strong) PDFDocument *document;
@property(nonatomic, weak) id<PDFSearchDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
