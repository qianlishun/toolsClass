//
//  USMarkView.m
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMarkView.h"
#import "USMark.h"
#import "USMeasure.h"
#import "USMarkGroup.h"
#import "MeasureHeader.h"
#import "USAnnotateGroup.h"
#import "USScrawlGroup.h"

#define UP 0
#define DOWN 1
#define CONFIRM 2
#define LEFT 3
#define RIGHT 4

@interface USMarkView ()<UITextViewDelegate>{
    UITextView *annoteEditext;
    UIButton *deleteBtn;
    
    int moveOrientation; // 移动方向 up down center left right
    UIView *pointCrtView;
    NSTimer *timer;
    float scale;
}
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@property (nonatomic,weak) id theDelegate;
@property (nonatomic,strong) NSArray *gesList;;


@end

@implementation USMarkView

- (void)addMark:(USMark*)marker{
    if (self.selectedAnnotate) {
        [self finishAnnotateEdit];
    }
    
    [self.theMarks deSelect];
    [self.theMarks addMark:marker];

    if (marker.markType == MARK_MEASURE) {//&& ![[mark isKindOfClass:[USMeasureEFW class]
        self.creatingMeasure = (USMeasure*) marker;

        UIImage *anchorBmp = [self getAnchorImage:[self.creatingMeasure getAnchorType] selected:NO];
        
        UIImage *selectedBmp = [self getAnchorImage:[self.creatingMeasure getAnchorType] selected:YES];
        [self.creatingMeasure setAnchorImage:anchorBmp selectedImage:selectedBmp];
        self.selectedMeasure = nil;
    } else if (marker.markType == MARK_ANNOTATE) {
        self.creatingAnnotate = (USAnnotate*)marker;
        [self.creatingAnnotate select];
        self.selectedAnnotate = nil;
    }else if(marker.markType == MARK_SCRAWL){
        self.creatingScrawl = (USScrawl*)marker;
    }
    [self updateLayer];
}

- (void)clearMarks{
    if (_theMarks) {
        [_theMarks clear];
        [self finishAnnotateEdit];
        [self updateLayer];
    }
    deleteBtn.hidden = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _theMarks = [USMarkGroup new];
        float screenW = [UIApplication sharedApplication].keyWindow.rootViewController.view.size.width;
        CGFloat width = screenW>1024?160:120;
        annoteEditext = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, width, 30)];
        [annoteEditext setText:@"ANNOTATE"];
        annoteEditext.textColor = [UIColor whiteColor];
        annoteEditext.hidden = YES;
        [annoteEditext setDelegate:self];
        annoteEditext.backgroundColor = [UIColor clearColor];
        annoteEditext.layer.borderColor = UIColor.greenColor.CGColor;
        annoteEditext.layer.borderWidth = 0.6f;
        [self addSubview:annoteEditext];
        
        deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        [self addSubview:deleteBtn];
        [deleteBtn setImage:[UIImage imageNamed:@"m_del.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(didDelteClick:) forControlEvents:UIControlEventTouchUpInside];
        deleteBtn.hidden = YES;
        /*
        [self initFiveDirection];
        
        UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOperator:)];
        [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
        
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOperator:)];
        [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
        
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOperator:)];
        [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeOperator:)];
        [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];

        _gesList = @[swipeLeft,swipeRight,swipeDown,swipeUp];
        
        [self addGestureRecognizer:swipeLeft];
        [self addGestureRecognizer:swipeRight];
        [self addGestureRecognizer:swipeDown];
        [self addGestureRecognizer:swipeUp];
        */
        // 监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];

        [annoteEditext addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];

        if(!_shapeLayer){
            _shapeLayer = [CAShapeLayer layer];
            _shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
            [_shapeLayer setFrame:self.bounds];
            _shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
            _shapeLayer.fillColor = [UIColor clearColor].CGColor;
            _shapeLayer.lineCap = kCALineCapRound;
            _shapeLayer.lineJoin = kCALineJoinRound;
            _shapeLayer.opacity = 0.9;
            _shapeLayer.lineWidth = 2.0;
            NSNumber *lineWidth = @1, *lineSpecing = @10;
            _shapeLayer.lineDashPattern = @[lineWidth,lineSpecing];
            [self.layer addSublayer:_shapeLayer];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if(annoteEditext.hidden == YES)
        return;
    if (object == annoteEditext && [keyPath isEqualToString:@"frame"]) {
        CGRect rect = [((NSValue *)[change objectForKey:@"old"]) CGRectValue];
        if(rect.origin.y != annoteEditext.y){
//            NSLog(@"annoteEditext.y = %f", annoteEditext.y);
            deleteBtn.y = annoteEditext.y;
        }
    }
}

- (void)setNeedsDisplay{
    [self updateLayer];
}

- (UIImage*)getAnchorImage:(int)anchorType selected:(BOOL)selected{
    UIImage *image = nil;
    if (selected) {
        switch (anchorType) {
            case ANCHOR_TYPE0:
                image = [UIImage imageNamed:@"m_point1h.png"];
                break;
            case ANCHOR_TYPE1:
                image = [UIImage imageNamed:@"m_point2h.png"];
                break;
            case ANCHOR_TYPE2:
                image = [UIImage imageNamed:@"m_point3h.png"];
                break;
            case ANCHOR_TYPE3:
                image = [UIImage imageNamed:@"m_point4h.png"];
                break;
            default:
                image = [UIImage imageNamed:@"m_point1h.png"];
                break;
        }
    }else{
        switch (anchorType) {
            case ANCHOR_TYPE0:
                image = [UIImage imageNamed:@"m_point1.png"];
                break;
            case ANCHOR_TYPE1:
                image = [UIImage imageNamed:@"m_point2.png"];
                break;
            case ANCHOR_TYPE2:
                image = [UIImage imageNamed:@"m_point3.png"];
                break;
            case ANCHOR_TYPE3:
                image = [UIImage imageNamed:@"m_point4.png"];
                break;
            default:
                image = [UIImage imageNamed:@"m_point1.png"];
                break;
        }
    }
    return image;
}


- (void)updateLayer{
    if (_theMarks) {
        self.shapeLayer.path = [UIBezierPath bezierPath].CGPath;
        [self.shapeLayer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
        [_theMarks draw:_shapeLayer];
    }
}

- (void)updateMarks:(USMarkGroup *)marks{
    _theMarks = marks;

    USRect *rect = [[USRect alloc]initWithLeft:self.width-200 top:160 width:180 height:60];
    if (self.width<self.height) {
        rect = [[USRect alloc]initWithLeft:15 top:self.height-80 width:150 height:60];
//        rect->top = 100;
    }

    [USMeasureGroup setTopResultRect:rect];
    
    _creatingMeasure = nil;
    _selectedMeasure = nil;
    _creatingAnnotate = nil;
    _selectedAnnotate = nil;
    
    [self showFiveDirectionButtons:NO];
    [self updateLayer];
}

- (void)updateMeasurePoint{
    float cm = 0.7/2.54 * [MeasureHeader getScreenDPI];
    if ([_selectedMeasure getSelectedAnchor]) {
        [_selectedMeasure getSelectedAnchor]->positionX -= cm;
        [_selectedMeasure getSelectedAnchor]->positionY -= cm;
    }
    [self updateLayer];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (UIImage*)screenImage{
    CGSize size = CGSizeMake(self.bounds.size.width, self.bounds.size.height);
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return viewImage;
}

#pragma mark - Touch  Func
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (!_theMarks) {
        return;
    }
    
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    USPoint *point = [[USPoint alloc]initWith:locationPoint.x and:locationPoint.y];
   
    if (_creatingMeasure && !_creatingMeasure.isCreatYet) {
        [_creatingMeasure addAnchor:point];
        _selectedMeasure =  (USMeasure *)[_theMarks hitTest:point];
          if ([_selectedMeasure isKindOfClass:[USAnnotate class]]) {
              _selectedMeasure = nil;
          }else{
          }
    }else if(_creatingAnnotate && !_creatingAnnotate.isCreatYet){
        point.x -= 5;
        if (point.x+annoteEditext.width > self.width-15) {
            point = [[USPoint alloc]initWith:self.width-15-annoteEditext.width and:point.y];
        }
        USRect *rect = [[USRect alloc]initWithLeft:point.x top:point.y width:annoteEditext.width height:30];
        [_creatingAnnotate setRect:rect];
        annoteEditext.height = 30;
        annoteEditext.x = point.x;
        annoteEditext.y = point.y;
        if (_creatingAnnotate.isCreatYet) {
            _selectedAnnotate = _creatingAnnotate;
            _creatingAnnotate = nil;
        }
        [annoteEditext setText:@"ANNOTATE"];
        annoteEditext.hidden = deleteBtn.hidden = NO;
        [deleteBtn setX:self.selectedAnnotate.getRect->left + self.selectedAnnotate.getRect->width];
        [deleteBtn setY:self.selectedAnnotate.getRect->top];

        [annoteEditext becomeFirstResponder];
    }else if(_creatingScrawl && !_creatingScrawl.isCreatYet){
        [_creatingScrawl addPoint:point];
    }else{
        if(!_creatingMeasure || !_creatingAnnotate || _creatingMeasure.isCreatYet || _creatingAnnotate.isCreatYet){
            [_theMarks deSelect];
            USMark *mark = [_theMarks hitTest:point];
            if (mark) {
                if (mark.markType == MARK_MEASURE) {
                    self.selectedMeasure = (USMeasure*)mark;
                    [self finishAnnotateEdit];
                    [self performSelector:@selector(updateMeasurePoint) withObject:self afterDelay:0.3];
                }else if(mark.markType  == MARK_ANNOTATE){
                    self.selectedAnnotate = (USAnnotate*)mark;
                }
            }else{
                self.selectedMeasure = nil;
                [self finishAnnotateEdit];
            }
        }
        if (_selectedMeasure) {
            if (_selectedMeasure.isResultSelected) {
                deleteBtn.x = _selectedMeasure.getResultRect->left + _selectedMeasure.getResultRect->width-deleteBtn.width;
                deleteBtn.y = _selectedMeasure.getResultRect->top;
                deleteBtn.hidden = NO;
            }else{
                deleteBtn.hidden = YES;
            }
        }else if(_selectedAnnotate){
            [deleteBtn setX:self.selectedAnnotate.getRect->left + self.selectedAnnotate.getRect->width];
            [deleteBtn setY:self.selectedAnnotate.getRect->top];
            deleteBtn.hidden = NO;
        }else{
            deleteBtn.hidden = YES;
        }
        
        if (!_selectedMeasure) {
            [self showFiveDirectionButtons:NO];
        }else{
            if (_selectedMeasure.isResultSelected){
                [self showFiveDirectionButtons:NO];
            }else{
                [self showFiveDirectionButtons:YES];
            }
        }
        
        if (_selectedAnnotate) {
            USRect *pos = _selectedAnnotate.getRect;
            annoteEditext.x = pos->left;
            annoteEditext.y = pos->top;
            [annoteEditext setWidth:pos->width];
            
            deleteBtn.x = annoteEditext.right;
            deleteBtn.y = annoteEditext.y;
            deleteBtn.hidden = NO;
            
            NSString *text = _selectedAnnotate.getString;
            if (!text) {
                [annoteEditext setText:@"ANNOTATE"];
            }else{
                if (text.length<=0) {
                    [annoteEditext setText:@"ANNOTATE"];
                }else{
                    [annoteEditext setText:text];
                }
            }
            annoteEditext.hidden = NO;
            [annoteEditext becomeFirstResponder];
        }
    }
    
    [self updateLayer];
}
static int moveCount = 0;
- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    moveCount++;
    if(moveCount<5)
        return;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    CGPoint locationPoint = [[touches anyObject] locationInView:self];
    USPoint *point = [[USPoint alloc]initWith:locationPoint.x and:locationPoint.y];
    
    if (_selectedMeasure) {
        if ([_selectedMeasure getSelectedAnchor]) {
            float selX = [_selectedMeasure getSelectedAnchor]->positionX;
            float selY = [_selectedMeasure getSelectedAnchor]->positionY;
            float diffX = fabsf(selX - point.x);
            float diffY = fabsf(selY - point.y);
            if( diffX < 10 && diffY < 10 ){
                return;
            }
            // DPI(dot per inch)是每英寸（1英寸=2.54厘米）的逻辑点的个数 ,所以根据不同屏幕的 DPI 去移动7毫米 要除以2.54
            float cm = 0.7/2.54 * [MeasureHeader getScreenDPI];
            float x = point.x - cm;
            float y = point.y -cm;
            
            if(![self.layer containsPoint:CGPointMake(x, y)]) return;
            
            float mx = selX - x;
            float my = selY - y;
            if (fabsf(mx)>3 || fabsf(my)>3) {
                [_selectedMeasure getSelectedAnchor]->positionX = x;
                [_selectedMeasure getSelectedAnchor]->positionY = y;
            }
           
            [self updateLayer];
        }
    }else if(_creatingScrawl && !_creatingScrawl.isCreatYet){
//        USPoint *lastPoint = [_creatingScrawl getPoint:_creatingScrawl.pointCount-1];
//        float diffX = fabsf(point.x - lastPoint.x);
//        float diffY = fabsf(point.y - lastPoint.y);
//        float lineWidth = _creatingScrawl.getLineWidth;
//        if(diffX >= 1 || diffY >= 1){
            [_creatingScrawl addPoint:point];
            [self updateLayer];
//        }
    }
}

- (void)endScrawl{
    [(USScrawl*)_creatingScrawl scrawlEnd];
    _creatingScrawl = nil;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(_creatingScrawl && !_creatingScrawl.isCreatYet){
        [_creatingScrawl addPoint:[[USPoint alloc]initWith:-1 and:-1]];

        if(self.autoEndScrawl){
             // 开启此代码表示手指抬起即结束此次涂鸦
            [self endScrawl];
            [self updateLayer];
        }
    }
    if (_creatingMeasure.isCreatYet) {
        _creatingMeasure = nil;
    }
    moveCount=0;
    [self updateMarkState];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)didDelteClick:(UIButton*)sender{
    if (_selectedMeasure) {

        [_theMarks removeMark:_selectedMeasure];

        sender.hidden = YES;
        [self updateLayer];
        pointCrtView.hidden = YES;
    }else if(_selectedAnnotate){
        [_theMarks removeMark:_selectedAnnotate];
        [annoteEditext setText:@"ANNOTATE"];
        annoteEditext.hidden = YES;
        sender.hidden = YES;
        [annoteEditext endEditing:YES];
        [self updateLayer];
    }
}

#pragma mark - FiveDirection Buttons
- (void)showFiveDirectionButtons:(BOOL)isShow{
    if (isShow) {
        pointCrtView.hidden = NO;
    }else{
        pointCrtView.hidden = YES;
    }
}


- (void)initFiveDirection{
    UILongPressGestureRecognizer *uplongPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(uplongPressed:)];
    uplongPressGR.allowableMovement = YES;
    uplongPressGR.minimumPressDuration = 0.3;
    
    UILongPressGestureRecognizer *downlongPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(downlongPressed:)];
    downlongPressGR.allowableMovement = YES;
    downlongPressGR.minimumPressDuration = 0.3;
    
    UILongPressGestureRecognizer *leftlongPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(leftlongPressed:)];
    leftlongPressGR.allowableMovement = YES;
    leftlongPressGR.minimumPressDuration = 0.3;
    
    UILongPressGestureRecognizer *rightlongPressGR =
    [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                  action:@selector(rightlongPressed:)];
    rightlongPressGR.allowableMovement = YES;
    rightlongPressGR.minimumPressDuration = 0.3;
    
    pointCrtView = [[UIView alloc] initWithFrame:CGRectMake(self.layer.frame.size.width - 150, self.layer.frame.size.height - 170, 150, 150)];
    [pointCrtView setBackgroundColor:[UIColor clearColor]];
    [self addSubview:pointCrtView];
    pointCrtView.hidden = YES;
    
    NSArray *grs = @[uplongPressGR,downlongPressGR,@1,leftlongPressGR,rightlongPressGR];
    NSArray *names = @[@"btn_up",@"btn_down",@"btn_save",@"btn_left",@"btn_right"];
    for (int i = 0; i<5; i++) {
        CGRect rect;
        if (i==0) {
            rect = CGRectMake(50, 0, 38, 38);
        }else if(i==1){
            rect = CGRectMake(50, 100, 38, 38);
        }else if(i==2){
            rect = CGRectMake(50, 50, 38, 38);
        }else if(i==3){
            rect = CGRectMake(0, 50, 38, 38);
        }else{
            rect = CGRectMake(100, 50, 38, 38);
        }
        UIButton *btn = [[UIButton alloc]initWithFrame:rect];
        [btn setBackgroundImage:[UIImage imageNamed:names[i]] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(moveClicked:) forControlEvents:UIControlEventTouchUpInside];
        if (i!=2) {
            [btn addGestureRecognizer:grs[i]];
        }
        btn.tag = i;
        [pointCrtView addSubview:btn];
    }
    names = nil;
    grs = nil;
}

- (void)moveClicked:(UIButton*)sender{
    Anchor *anchor = [_selectedMeasure getSelectedAnchor];
    CGPoint p = CGPointMake(anchor->positionX, anchor->positionY);
  
    if (!anchor) {
        return;
    }
    if ([sender tag] == UP){
        moveOrientation = 1;
        p.y -= 2;
    }
    else if ([sender tag] == DOWN){
        moveOrientation = 2;
        p.y += 2;
    }
    else if ([sender tag] == CONFIRM){
        moveOrientation = 3;
        [_selectedMeasure deSelect];
        _selectedMeasure = nil;
        [self showFiveDirectionButtons:NO];
        [self updateMarkState];
        [self updateLayer];
        return;
    }
    else if ([sender tag] == LEFT)
    {
        moveOrientation = 4;
        p.x -= 2;
    }
    else{
        moveOrientation = 5;
        p.x += 2;
    }
    if([self.layer containsPoint:p]){
        anchor->positionX = p.x;
        anchor->positionY = p.y;
        [self updateLayer];
    }
}

- (void)uplongPressed:(UILongPressGestureRecognizer *)sender
{
    moveOrientation = 1;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"began");
        [self countdownTimer];
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timer invalidate];
        NSLog(@"ended");
    }
}

- (void)downlongPressed:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPressed");
    moveOrientation = 2;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"began");
        [self countdownTimer];
        
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timer invalidate];
        NSLog(@"ended");
    }
    
}

- (void)leftlongPressed:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPressed");
    moveOrientation = 4;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"began");
        [self countdownTimer];
        
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timer invalidate];
        NSLog(@"ended");
    }
    
}

- (void)rightlongPressed:(UILongPressGestureRecognizer *)sender
{
    NSLog(@"longPressed");
    moveOrientation = 5;
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        NSLog(@"began");
        [self countdownTimer];
        
    }
    if (sender.state == UIGestureRecognizerStateEnded)
    {
        [timer invalidate];
        NSLog(@"ended");
    }
    
}

- (void)countdownTimer
{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (void)updateCounter:(NSTimer *)theTimer
{
    UIButton *btn = [UIButton new];
    btn.tag = moveOrientation-1;
    
    [self moveClicked:btn];
}


- (void)finishAnnotateEdit{
    if (_selectedAnnotate) {
        if (annoteEditext.text.length<1) {
//            annoteEditext.text = @"ANNOTATE";
            annoteEditext.textColor = [UIColor lightGrayColor];
            [_theMarks removeMark:_selectedAnnotate];
        }else{
            NSString *text = annoteEditext.text;
            [_selectedAnnotate setString:text];
            int width = annoteEditext.width;
            int height = annoteEditext.height;
            USRect *rect = _selectedAnnotate.getRect;
            rect->width = (float)width;
            rect->height = (float)height;
            [_selectedAnnotate setRect:rect];
            [_selectedAnnotate setTextSize:14];
        }
      
        [self.selectedAnnotate deSelect];
        
        self.selectedAnnotate = nil;
        [annoteEditext setText:@""];
        annoteEditext.hidden = YES;
        deleteBtn.hidden = YES;
        
        [self showFiveDirectionButtons:NO];
        
        [self endEditing:YES];
        [self updateLayer];
    }
}

- (void)setDelegate:(id)delegate{
    _theDelegate = delegate;
}

- (void)setCreatingMeasure:(USMeasure *)creatingMeasure{
    _creatingMeasure = creatingMeasure;
//    if (_creatingMeasure||_selectedMeasure || _selectedAnnotate) {
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = NO;
//        }
//    }else{
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = YES;;
//        }
//    }
}

- (void)setSelectedMeasure:(USMeasure *)selectedMeasure{
    _selectedMeasure = selectedMeasure;
//    if (_selectedMeasure || _creatingMeasure || _selectedAnnotate) {
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = NO;
//        }
//    }else{
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = YES;;
//        }
//    }
}

- (void)setSelectedAnnotate:(USAnnotate *)selectedAnnotate{
    _selectedAnnotate = selectedAnnotate;
//    if (_selectedAnnotate || _selectedMeasure || _creatingMeasure) {
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = NO;
//        }
//    }else{
//        for (UIGestureRecognizer *ges in _gesList) {
//            ges.enabled = YES;;
//        }
//    }
}
//- (void)swipeOperator:(UISwipeGestureRecognizer *)swipe{
//    if (_selectedMeasure || _selectedAnnotate || _creatingMeasure) {
//        return;
//    }
//    if ([_theDelegate respondsToSelector:@selector(onSwipe:)]) {
//        [_theDelegate onSwipe:swipe.direction];
//    }
//}

- (void)updateMarkState{
    if ([_theDelegate respondsToSelector:@selector(didUpdateMarkState)]) {
        [_theDelegate didUpdateMarkState];
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text hasPrefix:@"ANNOTATE"]) {
        textView.text = [textView.text substringFromIndex:8];
        [textView setTextColor:[UIColor whiteColor]];
    }else if([textView.text hasPrefix:@"ANNOTAT"]){
        textView.text = @"";
        [textView setTextColor:[UIColor whiteColor]];
    }
    CGSize tempsize = [textView sizeThatFits:CGSizeMake(textView.width, MAXFLOAT)];
    float tempx = (float) textView.frame.origin.x;
    float tempy = (float) textView.frame.origin.y;
    if (tempsize.height>=100) {
        tempsize.height = 100;
    }
    UIView *view = [self findKeyboard];
    if(tempy+tempsize.height > mScreenH - view.height){
        tempy = mScreenH - view.height - tempsize.height-30;
    }
    [textView setFrame:CGRectMake(tempx, tempy, textView.width, tempsize.height)];
}


// 监听键盘的frame即将改变的时候调用
- (void)keyboardWillChange:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIView *view = [UIApplication sharedApplication].keyWindow.rootViewController.view;
    // 修改底部约束
    if (frame.origin.y == view.frame.size.height ||
        frame.origin.y == view.superview.height) {
        if(_selectedAnnotate){
            annoteEditext.x = _selectedAnnotate.getRect->left;
            annoteEditext.y = _selectedAnnotate.getRect->top;
            [self finishAnnotateEdit];
        }
    }else{
        if (_selectedAnnotate) { // 标签
            CGFloat h = 20;
            if (M_VIEW_BOTTOM || M_VIEW_BOTTOM_h) {
                 h += M_VIEW_TOP ? M_VIEW_TOP:M_VIEW_TOP_h;
            }
            if(_selectedAnnotate.getRect->top + _selectedAnnotate.getRect->height - frame.origin.y > -28-h){
                annoteEditext.y = frame.origin.y-60-annoteEditext.height;
            }
        }
    }
    // 执行动画
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        // 如果有需要,重新排版
        [self layoutIfNeeded];
    }];
}


- (UIView *)findKeyboard
{
    UIView *keyboardView = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in [windows reverseObjectEnumerator])//逆序效率更高，因为键盘总在上方
    {
        keyboardView = [self findKeyboardInView:window];
        if (keyboardView && !keyboardView.hidden)
        {
            return keyboardView;
        }
    }
    return nil;
}

- (UIView *)findKeyboardInView:(UIView *)view
{
    for (UIView *subView in [view subviews])
    {
        if (strstr(object_getClassName(subView), "UIKeyboard"))
        {
            return subView;
        }
        else
        {
            UIView *tempView = [self findKeyboardInView:subView];
            if (tempView)
            {
                return tempView;
            }
        }
    }
    return nil;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));

}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    if (!newSuperview) {
        [timer invalidate];
        timer = nil;
    }
}

@end
