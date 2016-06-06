//
//  QWave.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/25.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "QWaveController.h"
#import "WaveView.h"


#define MAXVALUE 100

#define COUNTOFWAVEVIEWS 4


@interface QWaveController ()

@property (nonatomic, strong) NSMutableArray *waveViews;

@end

@implementation QWaveController



- (NSMutableArray *)waveViews
{
    if (_waveViews == nil)
        {
        _waveViews = [NSMutableArray array];
        }
    return _waveViews;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    for (int i = 0;  i < COUNTOFWAVEVIEWS ; i++)
        {
        CGFloat x = 0;
        CGFloat y = (ViewSize.height -64)/ COUNTOFWAVEVIEWS * i +64;
        CGFloat w = ViewSize.width;
        CGFloat h = (ViewSize.height -64)  / COUNTOFWAVEVIEWS ;

        WaveView *waveView = [[WaveView alloc] initWithFrame:CGRectMake(x, y, w, h)];

        waveView.backgroundColor = [UIColor whiteColor];

        [self.waveViews addObject:waveView];

        [self.view addSubview:waveView];
        }

    [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(changeWaveView) userInfo:nil repeats:YES];
}

- (void)changeWaveView
{


    for (int i = 0; i < COUNTOFWAVEVIEWS; i++)
        {
        unsigned int random = arc4random_uniform(MAXVALUE);

        WaveView *waveView = (WaveView *)self.waveViews[i];

        [waveView refreshWaveWithValue:random];
        }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    NSLog(@"内存溢出");
}



@end
