//
//  USPickerView.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/1/24.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "USPickerView.h"

@interface USPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, assign) NSInteger count;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) NSMutableArray *scaleList;
@end

@implementation USPickerView

- (void)setCount:(NSInteger)count{
    _count = count;
    [self.pickerView reloadComponent:0];
    
    self.scaleList = [NSMutableArray array];
    for (int i = 0; i < count; i++) {
        [self.scaleList addObject:[NSNumber numberWithFloat:1.0]];
    }
}

- (void)setIndex:(NSInteger)index{
    _index = index;
    [self.pickerView selectRow:index inComponent:0 animated:YES];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, frame.size.height, frame.size.width)];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.transform = CGAffineTransformRotate(self.transform,-M_PI_2);
        [self addSubview:_pickerView];
        _pickerView.center = self.center;
        
    }
    return self;
}

// Mark pickerViewDelegate

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.count;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
//    _index = row;
    NSLog(@"didSelectRow %ld",row);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    NSLog(@"viewForRow %ld",row);
    
    UIView  *itemView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, pickerView.height, pickerView.height/9.0)];
    itemView.backgroundColor = [UIColor whiteColor];
    itemView.tag = row;
    itemView.clipsToBounds = YES;
       
//    float scale = [self.scaleList[row] floatValue];
    float width = itemView.width;

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.name = [NSString stringWithFormat:@"%ld",row];
    [itemView.layer addSublayer:layer];
    layer.frame = itemView.bounds;
    layer.strokeColor = [UIColor orangeColor].CGColor;
    layer.lineWidth = 1.0;

    
//    itemView.width = scale * width;
//    NSLog(@"%ld %.2f",row, scale);
    
    NSInteger index = [pickerView selectedRowInComponent:0];
    if(_index != index){
        _index = index;
        [self.scaleList removeAllObjects];
        for (int i = 0; i < self.count; i++) {
            [self.scaleList addObject:[NSNumber numberWithFloat:1.0]];
        }
        for (int i = -5; i <= 5; i++) {
            NSInteger rowIndex = index+i;
            if(rowIndex >= 0 && rowIndex < _count-1){
                float scale = 2*cos( (60+abs(i))/180.0 * M_PI );
                self.scaleList[rowIndex] = [NSNumber numberWithFloat:scale];
                
                UIView *v = [pickerView viewForRow:rowIndex forComponent:0];
                CGFloat itemWidth = scale * width;
                UIBezierPath *path = [UIBezierPath bezierPath];
                [path moveToPoint:CGPointMake( width/2.0 - itemWidth/2.0, itemView.height/2-0.5)];
                [path addLineToPoint:CGPointMake( width/2.0 + itemWidth/2.0, itemView.height/2-0.5)];
                CAShapeLayer *slayer = (CAShapeLayer*)v.layer.sublayers.lastObject;
                slayer.path = path.CGPath;
                
                NSLog(@"tag %ld index %ld layer %@ %.2f",(long)v.tag,rowIndex,slayer.name,itemWidth);
            }
        }
    }
//    NSLog(@"selectedRowInComponent %ld",[pickerView selectedRowInComponent:0]);

    
    return itemView;
}


@end
