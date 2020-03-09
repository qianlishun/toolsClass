//
//  USQSegmentedView.m
//  PVUS
//
//  Created by mrq on 2020/3/4.
//  Copyright © 2020 SonopTek. All rights reserved.
//

#import "USQSegmentedView.h"
#import "UIImage+AssetUrl.h"

@interface USQSegmentedView(){
    NSInteger theStateCount;
}

@property (nonatomic,strong) NSArray *listState;

@property (nonatomic,assign) NSInteger count;

@end

@implementation USQSegmentedView

- (void)setName:(NSString *)name state:(NSString *)state{
    [self.titleLabel setText:name];
    
    [self updateItemList:state];
}

- (void)updateItemList:(NSString *)state{
    if([state containsString:@"|"]){
        self.listState = [state componentsSeparatedByString:@"|"];
        self.count = self.listState.count;
    }else if([state hasPrefix:@"-+"]){
        state = [state stringByReplacingOccurrencesOfString:@"-+" withString:@""];
        int n = state.intValue;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = -n; i <= n; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.listState = array.copy;
        self.count = self.listState.count;
    }else{
        self.count = state.intValue;
        NSMutableArray *array = [NSMutableArray array];
        for (int i = 0; i < self.count; i++) {
            [array addObject:[NSString stringWithFormat:@"%d",i]];
        }
        self.listState = array.copy;
    }
    self.currentState = self.listState[0];
    
    [self.segmentedControl removeAllSegments];
    for(int i = 0; i < self.listState.count; i++){
        [self.segmentedControl insertSegmentWithTitle:self.listState[i] atIndex:i animated:NO];
    }
    
    [self layoutSubviews];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    [self.segmentedControl addTarget:target action:action forControlEvents:UIControlEventValueChanged];
}

- (void)setStateStr:(NSString *)str{
    for (int i=0; i<self.listState.count; i++) {
        if ([str isEqualToString:self.listState[i]]) {
            [self setTheCurrentState:i];
            return;
        }
    }
    _currentState = str;
    [self layoutSubviews];
}

- (void)setTheCurrentState:(NSInteger)index{
    theStateCount = index;
    
    [self.segmentedControl setSelectedSegmentIndex:index];
    
    NSString *str;
    if (self.listState.count>1) {
        str = self.listState[theStateCount];
    }else{
        str = [NSString stringWithFormat:@"%zd",theStateCount];
    }
    
    _currentState = str;
    [self layoutSubviews];
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    [self.titleLabel setTextColor:color];
}

- (void)setDetailColor:(UIColor *)color forState:(UIControlState)state{
    NSDictionary *dics = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName,nil];
   
    [self.segmentedControl setTitleTextAttributes:dics forState:state];
}

- (void)setSegBackgroundColor:(UIColor *)color{
    
    UIImage *img = [UIImage createImageWithColor:color];
    
    [self.segmentedControl setBackgroundImage:img forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)setSeletedSegBackgroundColor:(UIColor *)color{
    UIImage *img = [UIImage createImageWithColor:color];

    [self.segmentedControl setBackgroundImage:img forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.segmentedControl];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
            
        self.listState = [NSArray array];
                
        theStateCount = 0;
    }
    return self;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [_titleLabel setTextColor:[UIColor blackColor]];
        
    }
    return _titleLabel;
}

- (UISegmentedControl *)segmentedControl{
    if(!_segmentedControl){
        _segmentedControl = [[UISegmentedControl alloc]initWithItems:@[@"    ",@"     "]];
        [_segmentedControl setFrame:CGRectMake(0, 0, 100, 40)];
        [_segmentedControl setApportionsSegmentWidthsByContent:YES];
        [_segmentedControl sizeToFit];
        [_segmentedControl setDividerImage:[UIImage createImageWithColor:[UIColor clearColor]] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
        _segmentedControl.layer.cornerRadius = 5;
        _segmentedControl.layer.masksToBounds = YES;
        
    }
    return _segmentedControl;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    _titleLabel.height = self.height*0.8;
    [_titleLabel sizeToFit];
    [_segmentedControl setApportionsSegmentWidthsByContent:YES];
    [_segmentedControl sizeToFit];
    _segmentedControl.height = self.height*0.8;
    
    _titleLabel.x = 0;
    _segmentedControl.x = self.width - _segmentedControl.width;
    _titleLabel.centerY = _segmentedControl.centerY = self.height/2;
}

@end
