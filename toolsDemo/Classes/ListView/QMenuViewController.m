//
//  QMenuViewController.m
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QMenuViewController.h"
#import "UIView+QLSFrame.h"
#import "QMenuView.h"
#import "Masonry.h"

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

    /*
    后面考虑修改成cell里面套UIStackView,自适应宽度布局，每个cell可以添加多个view
    设置时的格式修改为（初始化、添加、插入）
     {
     "ID1":{label1,view1,lablel1,view2},
     "ID2":{label,view},
     "ID3":{view}
     }
     cell stackview 高度计算问题
     */
    CGFloat top = self.navigationController.navigationBar.bottom;
    
    self.menuView = [[QMenuView alloc]initWithFrame:CGRectMake(0, top, self.view.width, self.view.height- top)];
    [self.view addSubview:self.menuView];
    
    NSArray *names = @[@"111111",@"222222",@"33333333",@"Insert"];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label1.text  = names[0];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label2.text = names[1];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label3.text = names[2];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label4.text = names[3];

    UITextField *textField1 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField1.textAlignment = NSTextAlignmentRight;
    textField1.placeholder = names[0];
    UITextField *textField2 = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    textField2.placeholder = names[1];
    
    UITextView *textField3 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
    textField3.text = @"TEXT";
    textField3.scrollEnabled = NO;

    
    UITextView *textField4 = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    textField4.text = @"text view";
    textField4.backgroundColor = [UIColor orangeColor];
    textField4.scrollEnabled = NO;
    
    textField1.textColor = textField2.textColor = textField3.textColor
    = textField4.textColor = [UIColor blueColor];
    
    _insertBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    [_insertBtn setTitle:[self.dateFmt stringFromDate:[NSDate date]] forState:UIControlStateNormal];
    [_insertBtn setTitleColor:[UIColor systemBlueColor] forState:UIControlStateNormal];
    [_insertBtn addTarget:self action:@selector(onDate:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.menuView setCellList:@[
        @{names[0]:@[label1,textField1]},
        @{names[1]:@[label2,textField2]},
        @{names[2]:@[label3,textField3]},
        @{names[3]:@[label4,_insertBtn]}
                                ]];
    
    NSString *append = @"Append";
    [self.menuView appendCell:@{append:@[textField4]}];
    
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
    label5.text = @"5555";
    
    [self.menuView appendCell:@{@"555":@[label5]}];

}


- (void)onDate:(id)sender{
    if(!_datePicker){
        _datePicker = [[UIDatePicker alloc]init];
        [_datePicker setDatePickerMode:UIDatePickerModeDate];
        [_datePicker addTarget:self action:@selector(onDateChange:) forControlEvents:UIControlEventValueChanged];
    }
    if([self.menuView findCellWithID:@"pick"]){
        [self.menuView deleteCellWithID:@"pick"];
    }else{
        [self.menuView
         insertCell:@{@"pick":@[_datePicker]} afterID:@"Insert"];
        
        [_datePicker mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_datePicker.superview);
            make.right.equalTo(_datePicker.superview).offset(-10);
        }];
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
