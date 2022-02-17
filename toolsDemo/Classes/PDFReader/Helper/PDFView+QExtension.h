//
//  PDFView+QExtension.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/17.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <PDFKit/PDFKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PDFView (QExtension)

- (UIScrollView*)scrollView;

- (void)setBounces:(BOOL)bounces;
@end

NS_ASSUME_NONNULL_END
