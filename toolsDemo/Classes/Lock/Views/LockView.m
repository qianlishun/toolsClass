
//
//  LockView.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "LockView.h"


#define ScreenSize self.bounds.size

@interface LockView ()

//所有按钮的数组
@property (nonatomic,strong) NSArray *buttons;

//所有选中状态的按钮数组
@property (nonatomic,strong) NSMutableArray *selectedButtons;

//手指当前的位置
@property (nonatomic,assign) CGPoint  currentPoint;


@end


@implementation LockView

//懒加载来实现所有选中状态按钮的可变数组
-(NSMutableArray *)selectedButtons{
    if(!_selectedButtons){

        _selectedButtons = [NSMutableArray array];
    }
    return _selectedButtons;
}

// 懒加载来实例化用for循环来创建按钮,并添加到数组
-(NSArray *)buttons{
    if (!_buttons) {
        NSMutableArray *arrayM = [NSMutableArray array];

        for (int i= 0; i < 9 ; i++) {

            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];

            //                        btn.backgroundColor = [UIColor redColor];

            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"]forState:UIControlStateNormal];

            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];

            [btn setBackgroundImage:[UIImage imageNamed:@"gesture_node_error"] forState:UIControlStateDisabled];

            [arrayM addObject:btn];

            [self addSubview:btn];

            //禁用按钮的用户交互
            btn.userInteractionEnabled = NO;

            //设置按钮的tag,以便生成解锁密码
            btn.tag = i + 1;
        }

        _buttons = arrayM;
    }
    return _buttons;
}


//布局子视图位置，设置所有子控件的位置
- (void)layoutSubviews
{
    //千万不要省略
    [super layoutSubviews];

    //九宫格布局按钮
    CGFloat w =ScreenSize.width / 4;
    CGFloat h =ScreenSize.height / 4;

    int count =3;

    //计算间距
    CGFloat marginX = (ScreenSize.width- count * w) / (count +1);
    CGFloat marginY = (ScreenSize.height- count * h) / (count +1);

    //循环计算每个按钮的位置
    for(int i =0; i <9; i++) {
        //计算出按钮所在的行&列
        int row = i / count;           // => Y
        int col = i % count;           // => X

        CGFloat x = marginX + (marginX + w) * col;
        CGFloat y = marginY + (marginY + h) * row;

        //设置按钮位置
        // ***按钮的懒加载！！！
        UIButton *btn =self.buttons[i];

        btn.frame = CGRectMake(x, y, w, h);
        //        NSLog(@"%f,%f,%f,%f",x,y,w,h);
    }
}

//触摸LockView时调用
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //拿到触摸对象
    UITouch *touch = touches.anyObject;
    //获取点击的坐标
    CGPoint point = [touch locationInView:touch.view];

    //判断点击的坐标 是否在按钮的区域范围
    for (int i=0; i<self.buttons.count; i++) {
        //如果在,那么让这个按钮 变成  高亮状态
        if (CGRectContainsPoint([self.buttons[i] frame], point)) {
            [self.buttons[i] setSelected:YES];

            // 添加到 选中状态按钮的数组中
            // 先判断该按钮在数组中是否已经存在
            if (![self.selectedButtons containsObject:self.buttons[i]]) {
                [self.selectedButtons addObject:self.buttons[i]];
            }
        }
    }
}
//摁住移动时
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //拿到触摸对象
    UITouch *touch = touches.anyObject;
    //获取点击的坐标
    CGPoint point = [touch locationInView:touch.view];

    //获取当前手指位置
    self.currentPoint = point;

    //判断点击的坐标 是否在按钮的区域范围
    for (int i=0; i<self.buttons.count; i++) {
        //如果在,那么让这个按钮 变成  高亮状态
        if (CGRectContainsPoint([self.buttons[i] frame], point)) {
            [self.buttons[i] setSelected:YES];

            // 添加到 选中状态按钮的数组中
            // 先判断该按钮在数组中是否已经存在
            if (![self.selectedButtons containsObject:self.buttons[i]]) {
                [self.selectedButtons addObject:self.buttons[i]];
            }
        }
    }
    // 重绘
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //判断需要连线的按钮是否有东西,如果没有直接返回
    if ( !self.selectedButtons.count) {
        return;
    }
    self.currentPoint = [[self.selectedButtons lastObject]center];
    //重绘
    [self setNeedsDisplay];
    //拼接密码
    NSString *pwd = @"";
    for (int i = 0; i<self.selectedButtons.count; i++) {
        pwd = [pwd stringByAppendingString:[NSString stringWithFormat:@"%ld",[self.selectedButtons[i] tag]]];
    }
    NSLog(@"%@",pwd);

    // 绘制上次手势状态的截图
    // 开启上下文
    UIGraphicsBeginImageContext(ScreenSize);
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 截图
    [self.layer renderInContext:ctx];

    // 通过上下文获取截图image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

    // 关闭上下文
    UIGraphicsEndImageContext();

    // 将密码传递给控制器, 再进行判断
    if(self.lockBlock){
        if (self.lockBlock(pwd,image)) {
            //正确(lockBlock返回值是yes)
            //恢复到原始状态
            [self clear];
        }
        else{
            //错误(lockBlock返回值是no)
            // 禁用控件
            [self setUserInteractionEnabled:NO];

            // 将按钮状态变成错误状态
            for (int i = 0 ; i<self.selectedButtons.count; i++) {
                [self.selectedButtons[i] setEnabled:NO];
                [self.selectedButtons[i] setSelected:NO];
            }

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self clear];
                [self setUserInteractionEnabled:YES];
            });
        }
    }
}

-(void)clear{
    for (int i = 0; i<self.buttons.count; i++) {
        UIButton *btn = self.buttons[i];
        btn.selected = NO;
        btn.highlighted = NO;
        btn.enabled  = YES;
    }
    // 清空
    [self.selectedButtons removeAllObjects];
    // 重绘
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //设置路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    //设置连线样式
    [path setLineWidth:10];
    [path setLineCapStyle:kCGLineCapRound];
    [path setLineJoinStyle:kCGLineJoinRound];

    [[UIColor whiteColor]set];

    for (int i = 0; i<self.selectedButtons.count; i++) {
        if (i == 0) {
            // 如果是第一个点 应该 移动到这个点的位置上
            [path moveToPoint:[self.selectedButtons[i] center]];
        }
        else{
            // 如果是其他的点,那么应该直接连线 addLine
            [path addLineToPoint:[self.selectedButtons[i] center]];
        }
    }
    // 如果需要画线的按钮的数组没有值,那么就不要画链接到手指位置的线
    if (self.selectedButtons.count) {
        [path addLineToPoint:self.currentPoint];
    }
    [path stroke];
}

@end
