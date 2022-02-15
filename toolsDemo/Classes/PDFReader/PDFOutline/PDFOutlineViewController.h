//
//  PDFOutlineViewController.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFKit.h>
NS_ASSUME_NONNULL_BEGIN

@class PDFOutlineViewController;

@protocol PDFOutlineDelegate <NSObject>

- (void)outlineViewcontroller:(PDFOutlineViewController*)controller didSelectOutline:(PDFOutline *)outline;

@end

@interface PDFOutlineViewController : UIViewController

@property(nonatomic, strong) PDFOutline *outlineRoot;
@property(nonatomic, weak) id<PDFOutlineDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
