//
//  QMenuViewController.m
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QMenuViewController.h"
#import "QMenuView.h"

@interface QMenuViewController ()

@property (nonatomic,strong) QMenuView *menuView;

@property (nonatomic,strong) NSDateFormatter *dateFmt;

@property (nonatomic,strong) UIButton *insertBtn;

@property (nonatomic,strong) UIDatePicker *datePicker;


@end

@implementation QMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    self.dateFmt = [[NSDateFormatter alloc] init];
    self.dateFmt.dateFormat = @"yyyy-MM-dd";

    self.menuView = [[QMenuView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.menuView];
    
    NSArray *names = @[@"111111",@"222222",@"33333333",@"Insert"];
    
    UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField1.textAlignment = NSTextAlignmentRight;
    textField1.placeholder = names[0];
    UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField2.placeholder = names[1];
    UITextField *textField3 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField3.placeholder = names[2];
    UITextField *textField4 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField4.placeholder = @"append!";

    textField1.textColor = textField2.textColor = textField3.textColor
    = textField4.textColor = [UIColor darkTextColor];
    
    _insertBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_insertBtn setTitle:[self.dateFmt stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [_insertBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_insertBtn addTarget:self action:@selector(onDate:) forControlEvents:UIControlEventTouchUpInside];

    NSArray *views = @[textField1,textField2,textField3,_insertBtn];
    
    [self.menuView setViewList:views forNames:names];
    
    NSString *append = @"Append";
    [self.menuView appendView:textField4 name:append forID:append];
}


- (void)onDate:(id)sender{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, 300, 120)];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
    }
    if([self.menuView findViewWithID:@"pick"]){
        [self.menuView deleteViewWithID:@"pick"];
    }else{
        [self.menuView insertViewAfterID:@"Insert" view:_datePicker name:@"" forID:@"pick"];
    }
}

- (void)onDateChange:(UIDatePicker*)picker{
    [_insertBtn setTitle:[self.dateFmt stringFromDate:picker.date] forState:UIControlStateNormal];

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
