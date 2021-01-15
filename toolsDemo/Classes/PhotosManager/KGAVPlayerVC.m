//
//  KGAVPlayerVC.m
//  WD_HJ
//
//  Created by 北师智慧 on 2020/6/5.
//

#import "KGAVPlayerVC.h"
#import <AVFoundation/AVFoundation.h>
#import "RNCompress.h"
#import "KGPhotosManager.h"

#define KGScreen_width [UIScreen mainScreen].bounds.size.width
#define KGScreen_height [UIScreen mainScreen].bounds.size.height
#define KGNavHeight ([UIApplication sharedApplication].statusBarFrame.size.height+49.f)
#define KGAppInfoDic [[NSBundle mainBundle] infoDictionary]
#define KGBundle(name,type) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"KGLibary" ofType:@"bundle"]] pathForResource:name ofType:type]

@interface KGAVPlayerVC ()

/** 视频播放 */
@property (nonatomic, strong) AVPlayer *player;
/** 播放控件 */
@property (nonatomic, strong) AVPlayerItem *playerItem;
/** 顶部导航 */
@property (nonatomic, strong) UIView *navView;
/** 是否允许 */
@property (nonatomic, assign) BOOL allUsed;

@end

@implementation KGAVPlayerVC


- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor blackColor];
  
  [self setUI];
  
  [self setNavViewUI];
}

- (void)setUI{
  self.playerItem = [[AVPlayerItem alloc] initWithURL:self.url];
  self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
  AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
  layer.videoGravity = AVLayerVideoGravityResizeAspect;
  layer.frame = self.view.bounds;
  [self.player play];
  [self.view.layer addSublayer:layer];
  [self.player.currentItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)setNavViewUI{
  _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KGScreen_width, KGNavHeight)];
  _navView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.35];
  [self.view addSubview:_navView];
  
  UIButton *backBtu = [UIButton buttonWithType:UIButtonTypeCustom];
  backBtu.frame = CGRectMake(15, KGNavHeight - 44, 100, 44);
  [backBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"back", @"png")] forState:UIControlStateNormal];
  backBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  [backBtu addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
  [backBtu setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
  backBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [_navView addSubview:backBtu];
  
  UIButton *shureBtu = [UIButton buttonWithType:UIButtonTypeCustom];
  shureBtu.frame = CGRectMake(KGScreen_width - 115, KGNavHeight - 44, 100, 44);
  [shureBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"对号_blod", @"png")] forState:UIControlStateNormal];
  shureBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [shureBtu addTarget:self action:@selector(shureAction) forControlEvents:UIControlEventTouchUpInside];
  [shureBtu setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
  shureBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
  [_navView addSubview:shureBtu];
}

- (void)backAction{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shureAction{
  KGLog(@"%@",self.url.path);
  if ([KGPhotosManager floatVideoTimeWithVideoPath:self.url] > 300) {
    [SVProgressHUD showErrorWithStatus:@"请选择5分钟内视频进行上传"];
    [SVProgressHUD dismissWithDelay:1];
  }else{
    [SVProgressHUD showWithStatus:@"正在压缩视频..."];
    [[[RNCompress alloc] init] compressVideo:self.url.path byQuality:nil succ:^(NSDictionary *dic) {
      [SVProgressHUD dismiss];
      KGLog(@"%@====%@",[NSThread currentThread],dic);
      if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
          [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(sendVideoURL:)]) {
              [self.delegate sendVideoURL:dic[@"path"]];
            }
          }];
        });
      }else{
        dispatch_async(dispatch_get_main_queue(), ^{
          [self dismissViewControllerAnimated:YES completion:^{
            if ([self.delegate respondsToSelector:@selector(sendVideoURL:)]) {
              [self.delegate sendVideoURL:dic[@"path"]];
            }
          }];
        });
      }
    } fail:^(NSString *reason) {
      [SVProgressHUD dismiss];
      [SVProgressHUD showErrorWithStatus:@"视频压缩失败，请重试!"];
      [SVProgressHUD dismissWithDelay:1];
    }];
  }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
  if (self.navView.alpha > 0) {
    [UIView animateWithDuration:0.2 animations:^{
      self.navView.alpha = 0;
    }];
  }else{
    [UIView animateWithDuration:0.2 animations:^{
      self.navView.alpha = 1;
    }];
  }
}

//2.添加属性观察
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        //获取playerItem的status属性最新的状态
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusReadyToPlay:{
                //获取视频长度
                CMTime duration = playerItem.duration;
              if (CMTimeGetSeconds(duration)/3600>0) {
                
              }
                break;
            }
            case AVPlayerStatusFailed:{//视频加载失败，点击重新加载
                
                break;
            }
            case AVPlayerStatusUnknown:{//加载遇到未知问题:AVPlayerStatusUnknown
                
                break;
            }
            default:
                break;
        }
    }
}

@end
