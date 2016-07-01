//
//  EditViewController.m
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "EditViewController.h"
#import "UIView+SDAutoLayout.h"

@interface EditViewController ()
@property (strong, nonatomic)  UITextField* nameField;
@property (strong, nonatomic)  UITextField* numberField;
@property (strong, nonatomic)  UIButton* saveButton;

@end

@implementation EditViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:(1.0)];
    self.navigationItem.title = @"编辑联系人";

    self.nameField = [[UITextField alloc]init];
    [self.view addSubview:self.nameField ];

    self.numberField = [[UITextField alloc]init];
    [self.view addSubview:self.numberField];

    self.saveButton = [[UIButton alloc]init];
    [self.view addSubview:self.saveButton];

    // 设置初始的文本框的内容(传过来的内容)
    self.nameField.text = self.contact.name;
    self.numberField.text = self.contact.number;

    self.nameField.enabled = NO;
    self.numberField.enabled = NO;
    self.saveButton.hidden = YES;

    // 监听保存按钮的点击事件
    [self.saveButton addTarget:self
                        action:@selector(saveClick)
              forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick:)];

    self.navigationItem.rightBarButtonItem = item;
}

// 保存按钮的点击事件
- (void)saveClick
{

    self.contact.name = self.nameField.text;
    self.contact.number = self.numberField.text;

    Contact* con = [[Contact alloc] init];
    //    con.name = self.nameField.text;
    //    con.number = self.numberField.text;

    // 判断代理方法是不是能够响应
    if ([self.delegate
         respondsToSelector:@selector(editViewController:withContact:)]) {

        // 如果可以响应那么执行代理方法
        [self.delegate editViewController:self withContact:con];
    }

    // 返回到上一个页面
    [self.navigationController popViewControllerAnimated:YES];
}

// 右上角编辑按钮点击事件
- (void)editClick:(UIBarButtonItem*)sender
{
    if (self.saveButton.hidden) { // 点击编辑
        sender.title = @"取消";
        self.nameField.enabled = YES;
        self.numberField.enabled = YES;
        self.saveButton.hidden = NO;

        // 让电话的文本框成为第一响应者
        [self.numberField becomeFirstResponder];
    }
    else { // 点击取消
        sender.title = @"编辑";
        self.nameField.enabled = NO;
        self.numberField.enabled = NO;
        self.saveButton.hidden = YES;

        // 恢复到传过来的模型的数据
        self.nameField.text = self.contact.name;
        self.numberField.text = self.contact.number;
    }
}


- (void)viewWillLayoutSubviews{

    CGFloat margin = 30;

    self.nameField.keyboardAppearance = UIKeyboardTypeNamePhonePad;
    self.nameField.placeholder = @"姓名";
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.view,margin+80).rightSpaceToView(self.view,margin).heightIs(30);

    self.numberField.keyboardAppearance = UIKeyboardTypeNumberPad;
    self.numberField.placeholder = @"手机号";
    self.numberField.borderStyle = UITextBorderStyleRoundedRect;
    self.numberField.sd_layout.leftSpaceToView(self.view,margin).topSpaceToView(self.nameField,1).rightSpaceToView(self.view,margin).heightIs(30);

    [self.saveButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];

    self.saveButton.backgroundColor = [UIColor colorWithRed:88/255.0 green:183/255.0 blue:219/255.0 alpha:0.8];

    self.saveButton.sd_layout.centerXEqualToView(self.view).topSpaceToView(self.numberField,margin/2).heightIs(40).widthRatioToView(self.view,0.7);
}


@end