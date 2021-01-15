#import "KGPhotosLibary.h"
#import "KGPhotosCell.h"
#import "KGPhotosManager.h"
#import "KGEditPhotoVC.h"

#define KGScreen_width [UIScreen mainScreen].bounds.size.width
#define KGScreen_height [UIScreen mainScreen].bounds.size.height
#define KGNavHeight ([UIApplication sharedApplication].statusBarFrame.size.height+49.f)
#define KGAppInfoDic [[NSBundle mainBundle] infoDictionary]
#define KGBundle(name,type) [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"KGLibary" ofType:@"bundle"]] pathForResource:name ofType:type]

@interface KGPhotosLibary ()<UICollectionViewDelegate,UICollectionViewDataSource>

/** 相册列表 */
@property (nonatomic, strong) UICollectionView *listView;
/** 约束 */
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
/** 未获取权限前的空页面 */
@property (nonatomic, strong) UIView *emtpyView;
/** 导航栏 */
@property (nonatomic, strong) UIView *navView;
/** 确定按钮 */
@property (nonatomic, strong) UIButton *shureBtu;
/** 照片数组 */
@property (nonatomic, strong) NSMutableArray *photosArr;
/** 选择图片 */
@property (nonatomic, strong) NSMutableArray *chooseArr;

@end

@implementation KGPhotosLibary

- (void)viewDidAppear:(BOOL)animated{
  [super viewDidAppear:animated];
  
  [[KGPhotosManager shareInstance] loadPhotosWithSize:CGSizeMake((KGScreen_width - 25)/3, (KGScreen_width - 25)/3) type:self.type];
}

- (void)viewWillDisappear:(BOOL)animated{
  [super viewWillDisappear:animated];
  
  [[NSNotificationCenter defaultCenter] removeObserver:self];
  [SVProgressHUD dismiss];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.view.backgroundColor = [UIColor whiteColor];
  self.photosArr = [NSMutableArray array];
  self.chooseArr = [NSMutableArray array];
  
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeListViewDataSource:) name:KGPhotosLibary_Send_Photos_Image object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAuthorizationStatusAlert) name:KGPhotosLibary_AuthorizationStatusDenied object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHUD) name:KGPhotosLibary_Authorization_Allow object:nil];
  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createUI) name:KGPhotosLibary_Send_All_Image object:nil];
  
  [self createNav];
}

/// 设置默认只选择1张
- (NSInteger)photoCount{
  return _photoCount?_photoCount:1;
}

/// 创建导航栏
- (void)createNav{
  
  _navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KGScreen_width, KGNavHeight)];
  _navView.backgroundColor = [UIColor colorWithRed:55/255.0 green:182/255.0 blue:255/255.0 alpha:1];
  [self.view addSubview:_navView];
  
  UIButton *cancelBtu = [UIButton buttonWithType:UIButtonTypeCustom];
  cancelBtu.frame = CGRectMake(15, KGNavHeight - 38, 100, 30);
  [cancelBtu setImage:[UIImage imageWithContentsOfFile:KGBundle(@"back", @"png")] forState:UIControlStateNormal];
  [cancelBtu addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
  cancelBtu.imageEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
  cancelBtu.imageView.contentMode = UIViewContentModeScaleAspectFit;
  cancelBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
  [_navView addSubview:cancelBtu];
}

/// 创建图片加载列表
- (void)setUI{
  
  self.shureBtu = [UIButton buttonWithType:UIButtonTypeCustom];
  self.shureBtu.frame = CGRectMake(KGScreen_width - 115, KGNavHeight - 38, 100, 30);
  [self.shureBtu setTitle:@"确定" forState:UIControlStateNormal];
  [self.shureBtu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  self.shureBtu.titleLabel.font = [UIFont systemFontOfSize:13.0];
  self.shureBtu.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
  [self.shureBtu addTarget:self action:@selector(shureAction) forControlEvents:UIControlEventTouchUpInside];
  [self.navView addSubview:self.shureBtu];
  
  self.layout = [[UICollectionViewFlowLayout alloc] init];
  self.layout.minimumLineSpacing = 5;
  self.layout.minimumInteritemSpacing = 5;
  self.layout.itemSize = CGSizeMake((KGScreen_width - 25)/3, (KGScreen_width - 25)/3);
  
  self.listView = [[UICollectionView alloc] initWithFrame:CGRectMake(5, KGNavHeight, KGScreen_width - 10, KGScreen_height - KGNavHeight - (self.allowEdit?(50 + (KGScreen_height > 800 ? 34.f:0.f)):0)) collectionViewLayout:self.layout];
  self.listView.showsVerticalScrollIndicator = NO;
  self.listView.showsHorizontalScrollIndicator = NO;
  self.listView.bounces = NO;
  self.listView.delegate = self;
  self.listView.dataSource = self;
  self.listView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.listView];
  
  [self.listView registerNib:[UINib nibWithNibName:@"KGPhotosCell" bundle:nil] forCellWithReuseIdentifier:@"KGPhotosCell"];
}

/// 创建空页面显示界面
- (void)showAlert{
  
  NSString *app_name= [KGAppInfoDic objectForKey:@"CFBundleName"];
  
  self.emtpyView = [[UIView alloc] initWithFrame:CGRectMake(0, KGNavHeight, KGScreen_width, KGScreen_height - KGNavHeight)];
  self.emtpyView.backgroundColor = [UIColor whiteColor];
  [self.view addSubview:self.emtpyView];
  
  UILabel *centerLab = [[UILabel alloc] initWithFrame:CGRectMake(0, self.emtpyView.bounds.size.height/2 - 50, self.emtpyView.bounds.size.width/2, 80)];
  centerLab.center = CGPointMake(self.emtpyView.center.x, self.emtpyView.bounds.size.height/2 - 80);
  centerLab.text = [NSString stringWithFormat:@"%@未获得相册访问权限，请点击下方按钮，前往设置中心，打开%@访问相册权限",app_name,app_name];
  centerLab.font = [UIFont systemFontOfSize:12.0];
  centerLab.numberOfLines = 0;
  centerLab.textAlignment = NSTextAlignmentCenter;
  centerLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
  [self.emtpyView addSubview:centerLab];
  
  UIButton *btu = [UIButton buttonWithType:UIButtonTypeCustom];
  btu.frame = CGRectMake(0, 0, 100, 45);
  btu.center = CGPointMake(self.emtpyView.center.x, self.emtpyView.bounds.size.height/2 + 10);
  [btu addTarget:self action:@selector(upSetting) forControlEvents:UIControlEventTouchUpInside];
  btu.layer.cornerRadius = 5;
  btu.layer.masksToBounds = YES;
  btu.backgroundColor = [UIColor colorWithRed:55/255.0 green:182/255.0 blue:255/255.0 alpha:1];
  [btu setTitle:@"前往打开" forState:UIControlStateNormal];
  [btu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  btu.titleLabel.font = [UIFont systemFontOfSize:12.0];
  [self.emtpyView addSubview:btu];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
  return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
  return _photosArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
  KGPhotosCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KGPhotosCell" forIndexPath:indexPath];
  BOOL have = NO;
  NSDictionary *dic = _photosArr[indexPath.row];
  for (NSDictionary *obj in self.chooseArr) {
    if ([obj isEqual:dic]) {
      have = YES;
      break;
    }
  }
  if (have) {
    cell.chooseMask.hidden = NO;
  }else{
    cell.chooseMask.hidden = YES;
  }
  if (![dic[@"img"] isKindOfClass:[UIImage class]]) {
    cell.img.image = [KGPhotosManager getVideoPreViewImage:dic[@"img"]];
    cell.timeView.hidden = NO;
    cell.timeLab.text = [KGPhotosManager videoTimeWithVideoPath:dic[@"img"]];
  }else{
    cell.img.image = dic[@"img"];
    cell.timeView.hidden = YES;
    cell.timeLab.text = @"";
  }
  
  return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
  NSDictionary *dic = _photosArr[indexPath.row];
  if(![dic[@"img"] isKindOfClass:[UIImage class]]){
    if ([KGPhotosManager floatVideoTimeWithVideoPath:dic[@"img"]] > 300) {
      [SVProgressHUD showErrorWithStatus:@"视频不能超过5分钟"];
      [SVProgressHUD dismissWithDelay:1];
      return;
    }
  }
  __block BOOL allow = YES;
  [self.chooseArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    if ([dic isEqual:obj]) {
      allow = NO;
      *stop = YES;
    }
  }];
  if (allow) {
    if (self.chooseArr.count==self.photoCount) {
      [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"最多只能选择%ld%@",self.photoCount,self.type==List_Type_Video?@"个视频":self.type==List_Type_Photo?@"张图片":@"个图片或视频"]];
      [SVProgressHUD dismissWithDelay:1];
    }else{
      [self.chooseArr addObject:dic];
      [self.shureBtu setTitle:[NSString stringWithFormat:@"(%ld/%ld)确定",self.chooseArr.count,self.photoCount] forState:UIControlStateNormal];
    }
  }else{
    [self.chooseArr removeObject:dic];
    if (self.chooseArr.count > 0) {
      [self.shureBtu setTitle:[NSString stringWithFormat:@"(%ld/%ld)确定",self.chooseArr.count,self.photoCount] forState:UIControlStateNormal];
    }else{
      [self.shureBtu setTitle:@"确定" forState:UIControlStateNormal];
      
    }
  }
  [_listView reloadItemsAtIndexPaths:@[indexPath]];
}


/// 接受从读取相册管理类发送过来的图片
/// @param notification 通知内容
- (void)changeListViewDataSource:(NSNotification *)notification{
  if (![[NSThread currentThread] isMainThread]) {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      NSDictionary *dic = notification.object;
      if (dic) {
        [weakSelf.photosArr addObject:dic];
        [weakSelf.listView reloadData];
      }
    });
  }else{
    NSDictionary *dic = notification.object;
    if (dic) {
      [_photosArr addObject:dic];
      [self.listView reloadData];
    }
  }
}

/// 接受从管理类发送过来的权限检测通知，不允许访问相册，展示提示信息，前往APP目录开启相册权限
- (void)showAuthorizationStatusAlert{
  if (![[NSThread currentThread] isMainThread]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self showAlert];
    });
  }else{
    [self showAlert];
  }
}

/// 接受从管理类发送过来的通知，图片发送完毕，开始加载图片预览列表，影藏菊花
- (void)createUI{
  if (![[NSThread currentThread] isMainThread]) {
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
      [SVProgressHUD dismiss];
      [self setUI];
      [weakSelf.listView reloadData];
    });
  }else{
    [SVProgressHUD dismiss];
    [self setUI];
    [_listView reloadData];
  }
}

/// 接受从管理类发送过来的权限检测通知，允许访问相册，展示菊花
- (void)showHUD{
  if (![[NSThread currentThread] isMainThread]) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [SVProgressHUD showWithStatus:@"图片较多，请耐心等待..."];
    });
  }else{
    [SVProgressHUD showWithStatus:@"图片较多，请耐心等待..."];
  }
}

/// 前往APP目录设置APP访问相册权限
- (void)upSetting{
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}

/// 导航栏返回按钮点击事件
- (void)cancelAction{
  [self dismissViewControllerAnimated:YES completion:nil];
}

/// 导航栏确定按钮点击事件
- (void)shureAction{
  if (self.chooseArr.count < 1) {
    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",self.type==List_Type_Video?@"请选择视频":self.type==List_Type_Photo?@"请选择图片":@"请选择图片或视频"]];
    [SVProgressHUD dismissWithDelay:1];
  }else{
    if (self.sendChooseImage) {
      NSMutableArray *arr = [NSMutableArray array];
      for (NSDictionary *dic in self.chooseArr) {
        [arr addObject:dic[@"img"]];
      }
      self.sendChooseImage(arr.copy);
      [self dismissViewControllerAnimated:YES completion:nil];
    }
  }
}

@end
