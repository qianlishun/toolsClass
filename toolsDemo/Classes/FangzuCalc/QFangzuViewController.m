//
//  QFangzuViewController.m
//  toolsDemo
//
//  Created by mrq on 2020/12/2.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QFangzuViewController.h"
#import "UIView+QLSFrame.h"

@interface QFangzuViewController (){
    UITextField *textfield1;
    UITextField *textfield2;
    UITextField *textfield3;
    UITextField *textfield4;
    UITextField *textfield5;

    UILabel *label;

    NSMutableArray *moneyList;
}

@end

@implementation QFangzuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
    
    moneyList = [NSMutableArray array];
    
    textfield1 = [[UITextField alloc]initWithFrame:CGRectMake(20, 80, 80, 40)];
    textfield1.placeholder = @"租金/月";
    
    textfield2 = [[UITextField alloc]initWithFrame:CGRectMake(110, 80, 80, 40)];
    textfield2.placeholder = @"服务费/月";
    
    textfield3 = [[UITextField alloc]initWithFrame:CGRectMake(200, 80, 80, 40)];
    textfield3.placeholder = @"N月一付";
    
    textfield4 = [[UITextField alloc]initWithFrame:CGRectMake(290, 80, 80, 40)];
    textfield4.placeholder = @"年化";
    
    textfield5 = [[UITextField alloc]initWithFrame:CGRectMake(10, 150, 80, 40)];
    textfield5.placeholder = @"其他/年";

    
    textfield1.keyboardType = textfield2.keyboardType =
    textfield3.keyboardType = textfield4.keyboardType =
    textfield5.keyboardType = UIKeyboardTypeNumberPad;
    
    textfield1.borderStyle = textfield2.borderStyle =
    textfield3.borderStyle = textfield4.borderStyle =
    textfield5.borderStyle = UITextBorderStyleRoundedRect;

    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 150, 80, 40)];
    button.centerX = self.view.width/2;
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"计算" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(calc:) forControlEvents:UIControlEventTouchUpInside];
    
    
    label = [[UILabel alloc]initWithFrame:CGRectMake(20, 230, 300, 100)];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor blackColor];
    
    [self.view addSubview:textfield1];
    [self.view addSubview:textfield2];
    [self.view addSubview:textfield3];
    [self.view addSubview:textfield4];
    [self.view addSubview:textfield5];
    [self.view addSubview:button];
    [self.view addSubview:label];
}

- (void)calc:(id)sender{
    int fuwufei = [textfield2.text intValue];
    
    int yuezu = [textfield1.text intValue] + fuwufei;

    int type = [textfield3.text intValue];
    
    int nianhua = [textfield4.text intValue];
    
    int qita = [textfield5.text intValue];
    
    int zong = yuezu * 12 + qita;
    
    int temp = zong-qita, lixi = 0;
    
    for (int i = 1; i <= 12 / type; i++) {
        temp -= yuezu * type;
        
        lixi += ( (temp * ( 12 - (i*type) ) / 12 * nianhua) / 100 );
        
    }
    
    int zuizhong = zong - lixi;
    
    NSLog(@"%d-%d=%d",zong,lixi,zuizhong);
    
    [moneyList addObject:[NSNumber numberWithInt:zuizhong]];
    
    label.text = [NSString stringWithFormat:@"%d",zuizhong];
    
    if(moneyList.count>=2){
        int last = [moneyList[moneyList.count-2] intValue];
        
        label.text = [NSString stringWithFormat:@"上一个%d，当前%d，差：%d",last,zuizhong, zuizhong-last];
    }
}

@end
