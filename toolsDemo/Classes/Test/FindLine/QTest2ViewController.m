//
//  QTest2ViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/15.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "QTest2ViewController.h"
#import <Vision/Vision.h>

@interface QTest2ViewController ()
@property(nonatomic, strong) UIImageView *imageView;
@end

@implementation QTest2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (@available(iOS 14.0, *)) {
        NSArray *supportLanguageArray = [VNRecognizeTextRequest supportedRecognitionLanguagesForTextRecognitionLevel:VNRequestTextRecognitionLevelAccurate revision:VNRecognizeTextRequestRevision2 error:nil];
    } else {

    }

    self.imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.imageView];
    self.imageView.image = [UIImage imageNamed:@"textImage.png"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
