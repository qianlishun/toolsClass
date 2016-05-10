//
//  LoginViewController.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "UIView+SDAutoLayout.h"
#import "ContactViewController.h"

#define kUsernameKey @"kUsernameKey"
#define kPasswordKey @"kPasswordKey"
#define kRemPasswordKey @"kRemPasswordKey"
#define kAutoLoginKey @"kAutoLoginKey"

// 1.SCREEN_WIDTH
// 2.kScreenWidth

@interface LoginViewController ()

@property (strong, nonatomic)  UITextField* usernameField;
@property (strong, nonatomic)  UITextField* passwordField;
@property (strong, nonatomic)  UIButton* loginButton;
//@property (nonatomic,strong) UILabel *lblUser ;
//@property (nonatomic,strong) UILabel *lblPW ;

@property (nonatomic,strong) UIView *remView;
@property (nonatomic,strong) UIView *autoView;

@property (nonatomic,strong) UILabel *lblRem ;
@property (nonatomic,strong) UILabel *lblAuto;
@property (strong, nonatomic)  UISwitch* remPassword;
@property (strong, nonatomic)  UISwitch* autoLogin;

@property (nonatomic,strong) UIView *logView;


@end

@implementation LoginViewController

// 记住密码开关的切换
- (void)remPasswordChange:(UISwitch*)sender
{

    // 如果关闭记住密码 那么同时关闭自动登录
    if (!sender.isOn) {
        //        self.autoLogin.on = NO;
        [self.autoLogin setOn:NO animated:YES];
    }
}

// 自动登录开关的切换
- (void)autoLoginChange:(UISwitch*)sender
{
    // 如果开启自动登录 那么同时开启记住密码
    if (sender.isOn) {
        //        self.remPassword.on = YES;
        [self.remPassword setOn:YES animated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:(1.0)];

    UIView *logView = [[UIView alloc]init];

//    logView.backgroundColor = [UIColor lightGrayColor];

    [self.view addSubview:logView];
    self.logView = logView;


    //创建子控件
    UITextField *usernameField = [[UITextField alloc]init];
    [self.logView addSubview:usernameField];
    self.usernameField = usernameField;

    UITextField *passwordField = [[UITextField alloc]init];
    [self.logView addSubview:passwordField];
    self.passwordField = passwordField;

    //    UILabel *lblUser = [[UILabel alloc]init];
    //    [self.logView addSubview:lblUser];
    //    self.lblUser = lblUser;
    //
    //    UILabel *lblPW = [[UILabel alloc]init];
    //    [self.logView addSubview:lblPW];
    //    self.lblPW = lblPW;

    UIButton* loginButton = [[UIButton alloc]init];

    [loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.logView addSubview:loginButton];
    self.loginButton = loginButton;
    loginButton.enabled = NO;


    UIView *remView =[[UIView alloc]init];
    [self.logView addSubview:remView];
    self.remView = remView;


    UILabel *lblRem = [[UILabel alloc]init];
    [self.remView addSubview:lblRem];
    self.lblRem = lblRem;

    UISwitch* remPassword = [[UISwitch alloc]init];
    remPassword.on = NO;
    [self.remView addSubview:remPassword];
    self.remPassword = remPassword;
    [remPassword addTarget:self action:@selector(remPasswordChange:) forControlEvents:UIControlEventValueChanged];

    UIView *autoView = [[UIView alloc]init];
    [self.logView addSubview:autoView];
    self.autoView = autoView;

    UILabel *lblAuto= [[UILabel alloc]init];
    [self.autoView addSubview:lblAuto];
    self.lblAuto = lblAuto;

    UISwitch* autoLogin = [[UISwitch alloc]init];
    autoLogin.on = NO;
    [self.autoView addSubview:autoLogin];
    self.autoLogin = autoLogin;

    [autoLogin addTarget:self action:@selector(autoLoginChange:) forControlEvents:UIControlEventValueChanged];

    // 监听文本框
    [self.usernameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.passwordField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    // 监听登陆按钮
    [self.loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];

    // 恢复开关状态
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

    self.remPassword.on = [ud boolForKey:kRemPasswordKey];
    self.autoLogin.on  = [ud boolForKey:kAutoLoginKey];

    // 恢复用户名密码
    self.usernameField.text = [ud objectForKey:kUsernameKey];
    if (self.autoLogin.isOn) {
        //如果记住密码打开,那么恢复密码
        self.passwordField.text = [ud objectForKey:kPasswordKey];
    }

    if (self.autoLogin.isOn) {
        // 如果自动登陆打开 那么直接登陆
        [self login];
    }
    [self textChange];

}

// 登陆按钮的点击事件
- (void)login
{

    // 第三方框架 第三方库

    [SVProgressHUD showWithStatus:@"正在登陆" maskType:SVProgressHUDMaskTypeBlack];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        // 隐藏
        [SVProgressHUD dismiss];

        // 当用户名和密码正确的时候 进行跳转
        if ([self.usernameField.text isEqualToString:@"1"] && [self.passwordField.text isEqualToString:@"1"]) {

            ContactViewController *vc = [[ContactViewController alloc]init];

            vc.username = self.usernameField.text;


            [self.navigationController pushViewController:vc animated:YES];

            // 保存状态
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

            [ud setBool:self.remPassword.isOn forKey:kRemPasswordKey];
            [ud setBool:self.autoLogin.isOn forKey:kAutoLoginKey];
            [ud setObject:self.usernameField.text forKey:kUsernameKey];
            [ud setObject:self.passwordField.text forKey:kPasswordKey];

            [ud synchronize];// 立即写入
        }
        else {
            // 提示错误消息
            [SVProgressHUD showErrorWithStatus:@"用户名或密码错误"];
        }

    });
}


// 文本框内容发生改变的时候调用
- (void)textChange
{
    self.loginButton.enabled = self.usernameField.text.length > 0 && self.passwordField.text.length > 0;
}
- (void)viewDidLayoutSubviews{
    CGFloat margin = 30;

    self.logView.sd_layout.leftSpaceToView(self.view,margin/10).topSpaceToView(self.view,margin+80).rightSpaceToView(self.view,margin/10).heightIs(self.view.bounds.size.height*0.3);

    //    self.lblUser.text = @"账号:";
    //    self.lblUser.sd_layout.leftSpaceToView(self.logView,margin/5).topSpaceToView(self.logView,margin).widthIs(50).heightIs(20);
    //    self.lblPW.text = @"密码:";
    //    self.lblPW.sd_layout.leftSpaceToView(self.logView,margin/5).topSpaceToView(self.lblUser,margin).widthIs(50).heightIs(20);

    self.usernameField.placeholder = @"账号/手机号/银行卡号";
    self.usernameField.borderStyle = UITextBorderStyleRoundedRect;
    self.usernameField.sd_layout.leftSpaceToView(self.logView,margin/5).topSpaceToView(self.logView,margin).rightSpaceToView(self.logView,margin/5).heightIs(30);

    self.passwordField.placeholder = @"密码/银行口令";
    [self.passwordField setSecureTextEntry:YES];
    self.passwordField.borderStyle = UITextBorderStyleRoundedRect;
    self.passwordField.sd_layout.leftSpaceToView(self.logView,margin/5).topSpaceToView(self.usernameField,1).rightSpaceToView(self.logView,margin/5).heightIs(30);

    self.remView.sd_layout.leftSpaceToView(self.logView,self.view.bounds.size.width*0.14).topSpaceToView(self.passwordField,margin/2).heightIs(30).widthRatioToView(self.view,0.4);

    self.lblRem.text = @"记住密码:";
    self.lblRem.sd_layout.leftSpaceToView(self.remView,0).topSpaceToView(self.remView,5).heightIs(20).widthIs(80);
    self.remPassword.sd_layout.leftSpaceToView(self.lblRem,0).topSpaceToView(self.remView,0);

    self.autoView.sd_layout.leftSpaceToView(self.remView,0).topSpaceToView(self.passwordField,margin/2).heightIs(30).widthRatioToView(self.logView,0.4);

    self.lblAuto.text = @"自动登录:";
    self.lblAuto.sd_layout.leftSpaceToView(self.autoView,0).topSpaceToView(self.autoView,5).heightIs(20).widthIs(80);
    self.autoLogin.sd_layout.leftSpaceToView(self.lblAuto,0).topSpaceToView(self.autoView,0);


    [self.loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    self.loginButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:183/255.0 blue:219/255.0 alpha:0.8];


    self.loginButton.sd_layout.centerXEqualToView(self.logView).topSpaceToView(self.remView,margin/3).heightIs(40).widthRatioToView(self.logView,0.8);

}
@end