//
//  AddViewController.m
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "AddViewController.h"
#import "UIView+SDAutoLayout.h"
@interface AddViewController ()

@property (strong, nonatomic)  UITextField* nameField;
@property (strong, nonatomic)  UITextField* numberField;
@property (strong, nonatomic)  UIButton* addButton;

@end

@implementation AddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor whiteColor];

    self.nameField = [[UITextField alloc]init];
    [self.view addSubview:self.nameField ];

    self.numberField = [[UITextField alloc]init];
    [self.view addSubview:self.numberField];

    self.addButton = [[UIButton alloc]init];
    [self.view addSubview:self.addButton];

    // 实时监听两个文本框的内容的变化
    [self.nameField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];
    [self.numberField addTarget:self action:@selector(textChange) forControlEvents:UIControlEventEditingChanged];

    // 监听添加按钮的点击事件
    [self.addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];

    // 让姓名文本框 成为第一响应者
    [self.nameField becomeFirstResponder];
}

// 添加按钮的点击事件
- (void)addClick
{

    // 判断代理方法是不是能够响应
    if ([self.delegate respondsToSelector:@selector(addViewController:withContact:)]) {

        Contact* con = [[Contact alloc] init];
        con.name = self.nameField.text;
        con.number = self.numberField.text;

        // 如果可以响应 那么执行代理方法
        [self.delegate addViewController:self withContact:con];
    }

    // 返回上一个控制器(联系人列表)
    [self.navigationController popViewControllerAnimated:YES];
}

// 文本框中文本发生改变的时候调用
- (void)textChange
{
    self.addButton.enabled = self.nameField.text.length > 0 && self.numberField.text.length > 0;
}

-(void)viewWillLayoutSubviews{

    CGFloat margin = 30;

    self.nameField.keyboardAppearance = UIKeyboardTypeNamePhonePad;
    self.nameField.placeholder = @"姓名";
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.view,margin+80).rightSpaceToView(self.view,margin).heightIs(30);

    self.numberField.keyboardAppearance = UIKeyboardTypeNumberPad;
    self.numberField.placeholder = @"手机号";
    self.numberField.borderStyle = UITextBorderStyleRoundedRect;
    self.numberField.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.nameField,margin/2).rightSpaceToView(self.view,margin).heightIs(30);

    [self.addButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.addButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    self.addButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:183/255.0 blue:219/255.0 alpha:0.8];

    self.addButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.numberField,margin/2).heightIs(40).widthRatioToView(self.view,0.7);
}


@end
