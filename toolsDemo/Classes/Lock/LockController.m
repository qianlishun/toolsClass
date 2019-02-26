//
//  LockController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "LockController.h"
#import "LockView.h"
#import "SVProgressHUD.h"

@interface LockController ()

@property (nonatomic,strong) LockView *lockView;
@property (nonatomic,strong) UIImageView *imageView;


@end

@implementation LockController

-(LockView *)lockView{

    if (!_lockView) {

        _lockView = [[LockView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH*0.9, kWIDTH*0.9)];

        _lockView.center = self.view.center;

        [self.view addSubview:_lockView];
    }
    return  _lockView;
}
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(kWIDTH *0.35, kWIDTH * 0.2, kWIDTH * 0.3, kWIDTH *  0.3)];

        [self.view addSubview:_imageView];
    }
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];

    [self lockView];

    [self imageView];
    //清空背景颜色
    self.lockView.backgroundColor= [UIColor clearColor];
    //不透明属性，默认是YES
    // ***苹果官方文档建议：所有的视图都要将opaque设置为YES，如果需要透明，可以指定背景颜色clearColor

    __weak LockController *weakSlef = self;

    __block int n = 0;
    self.lockView.lockBlock = ^(NSString *pwd,UIImage *img){
        weakSlef.imageView.image = img;

        if(n%2==0){
            weakSlef.imageView.transform = CGAffineTransformMakeScale(-1,-1);
        }else{
            weakSlef.imageView.transform = CGAffineTransformMakeScale(1,1);
        }
        
        n++;
        if ([pwd isEqualToString:@"135"]) {
            weakSlef.imageView.image = nil;

            [SVProgressHUD showSuccessWithStatus:@"密码正确"];

            //创建需要跳转的vc
            // xxxxController *vc = [[xxxxController alloc]init]
            // weakSelf presentViewController:vc animated:YES completion:nil];

            return YES; // 正确返回YES
        }else{
            [SVProgressHUD showErrorWithStatus:@"密码错误"];

            return NO;
        }
    };

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
