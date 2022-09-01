//
//  USQControlButtons.m
//  HU01
//
//  Created by Qianlishun on 2022/4/20.
//

#import "USQControlButtons.h"
#import "Masonry.h"


@interface USQControlButtons()

@property(nonatomic, strong) UILabel *label;

@property(nonatomic, strong) UIButton *plusView;
@property(nonatomic, strong) UIButton *minusView;

@property(nonatomic, strong) UIControl *leftControl;
@property(nonatomic, strong) UIControl *rightControl;

@property(nonatomic, assign) float min;
@property(nonatomic, assign) float max;
@property(nonatomic, assign) float step;
@property(nonatomic, copy) ClickBlock valueChange;

@end

@implementation USQControlButtons
- (instancetype)initWithValue:(float)value min:(float)min max:(float)max step:(float)step valueChange:(nullable ClickBlock)valueChange{
    
    self = [super init];
    if (self) {

        _label = [UILabel new];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.adjustsFontSizeToFitWidth = YES;

        _plusView = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        _plusView.contentMode = UIViewContentModeScaleAspectFit;
        if (@available(iOS 13.0, *)) {
            [_plusView setImage:[UIImage systemImageNamed:@"plus"] forState:UIControlStateNormal];
            [_plusView setBackgroundImage:[UIImage imageNamed:@"icon_black_cover"] forState:UIControlStateHighlighted];
            [_plusView setBackgroundImage:[UIImage imageNamed:@"icon_green_sel"] forState:UIControlStateSelected];
        }
        [_plusView addTarget:self action:@selector(onPlus) forControlEvents:UIControlEventTouchUpInside];

        
        _minusView = [UIButton new];
        _minusView.contentMode = UIViewContentModeScaleAspectFit;
        if (@available(iOS 13.0, *)) {
            
            [_minusView setImage:[UIImage systemImageNamed:@"minus"] forState:UIControlStateNormal];
            [_minusView setBackgroundImage:[UIImage imageNamed:@"icon_black_cover"] forState:UIControlStateHighlighted];
            [_minusView setBackgroundImage:[UIImage imageNamed:@"icon_green_sel"] forState:UIControlStateSelected];

        }
        [_minusView addTarget:self action:@selector(onMinus) forControlEvents:UIControlEventTouchDown];

        _leftControl = [UIControl new];
        [_leftControl addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_leftControl addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_leftControl addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

        _rightControl = [UIControl new];
        [_rightControl addTarget:self action:@selector(onTouchDown:) forControlEvents:UIControlEventTouchDown];;
        [_rightControl addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_rightControl addTarget:self action:@selector(onTouchUp:) forControlEvents:UIControlEventTouchUpOutside];

        
        [self addSubview:_label];
        [self addSubview:_plusView];
        [self addSubview:_minusView];
        [self addSubview:self.leftControl];
        [self addSubview:self.rightControl];
                
        
        self.min = min;
        self.max = max;
        self.step = step;
        self.value = value;
        
        if(valueChange){
            self.valueChange = ^(float value) {
                valueChange(value);
            };
        }
        
    }
    
    return self;
}


- (void)setEnabled:(BOOL)enabled{
    _enable = enabled;
    self.userInteractionEnabled = enabled;
    self.alpha = enabled ? 1.0 : 0.2;
}


- (void)onPlus{
    self.value += self.step;
    if(self.valueChange){
        self.valueChange(self.value);
    }
    if(self.rightControl.enabled){

    }
}

- (void)onMinus{
    self.value -= self.step;
    if(self.valueChange){
        self.valueChange(self.value);
    }
    if(self.leftControl.enabled){

    }
}

- (void)onTouchDown:(UIControl*)sender{
    if(sender == _leftControl){
        [_minusView sendActionsForControlEvents:UIControlEventTouchDown];
    }else if(sender == _rightControl){
        [_plusView sendActionsForControlEvents:UIControlEventTouchDown];
    }
}

- (void)onTouchUp:(UIControl*)sender{
    if(sender == _leftControl){
        [_minusView sendActionsForControlEvents:UIControlEventTouchUpInside];
    }else if(sender == _rightControl){
        [_plusView sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setValue:(float)value{
    if(value >= self.max){
        self.rightControl.enabled = NO;
        self.plusView.alpha = 0.2;
    }else if(value <= self.min){
        self.leftControl.enabled = NO;
        self.minusView.alpha = 0.2;
    }else{
        self.plusView.alpha = 1.0;
        self.minusView.alpha = 1.0;
        self.rightControl.enabled = YES;
        self.leftControl.enabled = YES;
    }
    
    if(value >= self.min && value <= self.max ){
        _value = value;
        [self updateText];
    }
   
}

- (void)setTitle:(NSString *)title{
    _title = title;
    [self updateText];
}

- (void)updateText{
    NSString *text = [NSString stringWithFormat:@"%0.f",self.value] ;//[NSString stringWithFloat:self.value];
    if(self.title && self.title.length>0){
        text = [self.title stringByAppendingFormat:@" %@",text];
    }
    _label.text = text;
}

- (void)setValue:(float)value min:(float)min max:(float)max step:(float)step{
    _min = min;
    _max = max;
    _step = step;

    [self setValue:value];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 15;
    CGFloat iconWidth = 18;
    
    [self.minusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(margin);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(iconWidth);
    }];
    
    [self.plusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-margin);
        make.centerY.width.height.equalTo(self.minusView);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minusView.mas_right).offset(margin);
        make.right.equalTo(self.plusView.mas_left).offset(-margin);
        make.centerY.equalTo(self);
        make.height.equalTo(self).multipliedBy(0.8);
    }];
    
    [self.leftControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.height.centerY.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
    [self.rightControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.height.centerY.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.5);
    }];
}


@end
