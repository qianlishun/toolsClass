//
//  QPDFReader.h
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/14.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PDFKit/PDFView.h>

NS_ASSUME_NONNULL_BEGIN

@interface QPDFReader : UIViewController
@property (nonatomic, strong) PDFView *pdfView;
@property (nonatomic, strong) PDFDocument *document;

@end

NS_ASSUME_NONNULL_END
