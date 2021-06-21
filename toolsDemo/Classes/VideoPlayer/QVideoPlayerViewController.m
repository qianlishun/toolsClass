//
//  QVideoPlayerViewController.m
//  toolsDemo
//
//  Created by mrq on 2021/1/15.
//  Copyright © 2021 钱立顺. All rights reserved.
//

#import "QVideoPlayerViewController.h"
#import "USMediaBrowserView.h"
#import <Photos/Photos.h>

@interface QVideoPlayerViewController ()
@property (nonatomic,strong) USMediaBrowserView *mediaBrowserView;

@end

@implementation QVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
        
    self.mediaBrowserView =  [[USMediaBrowserView alloc]initWithFrame:CGRectMake(self.view.width*0.2, self.view.height*0.3, self.view.width*0.6, self.view.height*0.4)];
    [self.view addSubview:self.mediaBrowserView];
    

//    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
//
//    PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
     
    PHFetchOptions *options = [[PHFetchOptions alloc] init];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
     

    PHAsset *asset = assetsFetchResults[0];

    PHImageManager *manager = [PHImageManager defaultManager];

    
    
    [manager requestAVAssetForVideo:asset options:nil resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        NSURL *url = urlAsset.URL;
        [self.mediaBrowserView setVideoURL:url];
    }];
    
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
