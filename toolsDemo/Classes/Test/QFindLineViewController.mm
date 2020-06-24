//
//  QFindLineViewController.m
//  toolsDemo
//
//  Created by mrq on 2020/6/3.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import "QFindLineViewController.h"
#import "HoughLineDetector.h"
#import "UIImage+AssetUrl.h"

@interface QFindLineViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) Byte *imageBytes;
@property (nonatomic) NSData* rawImage;
@property (nonatomic,strong) CAShapeLayer *shapeLayer;

@end

@implementation QFindLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(!_shapeLayer){
        _shapeLayer = [CAShapeLayer new];
        _shapeLayer.fillColor = [UIColor clearColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        [self.imageView.layer addSublayer:_shapeLayer];
    }
    
}

- (IBAction)onImage1:(id)sender {
    UIImage *image = [UIImage imageNamed:@"IMG_0119.jpg"];
    self.imageView.image = image;
    
   _imageBytes = [image pixelRGBBytes];
}

- (IBAction)onImage2:(id)sender {
    [self getBytesWithFile:@"blood2.txt"];
}


- (IBAction)onTest:(id)sender {
    
    int width = self.imageView.image.size.width;
    int height = self.imageView.image.size.height;

    UIBezierPath *path = [UIBezierPath bezierPath];

    boundingbox_t bbox = { 0,50,width,height-50 };

    std::vector<line_float_t> lines;

     
    int result =
    HoughLineDetector(_imageBytes,width,height,1,1,150,200,1, M_PI/180.0,
                      0, M_PI, width/2.5, HOUGH_LINE_STANDARD,bbox,lines);

         
    for(int i = 0; i < lines.size(); i ++){
        line_float_t line = lines[i];
     
        [path moveToPoint:CGPointMake(line.startx, line.starty)];
        [path addLineToPoint:CGPointMake(line.endx, line.endy)];
    }
    
    _shapeLayer.path = path.CGPath;
    
}


- (void)getBytesWithFile:(NSString *)fileName{
    NSString *path = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
    
    NSString *bytesStr = [[NSString alloc] initWithData:[NSData dataWithContentsOfFile:path] encoding:NSUTF8StringEncoding];
    bytesStr = [bytesStr stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    bytesStr = [bytesStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    NSArray<NSString*> *arr = [bytesStr componentsSeparatedByString:@","];
    int length = (int)arr.count-1;

   _imageBytes =  (Byte *) calloc(length, sizeof(Byte));
    
    int lineCount = length / 512;
    for (int l=0;l<lineCount;l++) {
        for (int s=0;s<512;s++) {
            Byte c = arr[l*512+s].integerValue;
            //_imageBytes[(lineCount-1-l)*512+s] = c;
            _imageBytes[lineCount*s+l] = c;
        }
    }
    
    CGSize size = CGSizeMake(lineCount, 512);
    [self showImageWithBytes:_imageBytes withSize:size];
    
    self.rawImage = [[NSData alloc]initWithBytes:_imageBytes length:length];
    
//    free(_imageBytes);
}

- (void)showImageWithBytes:(unsigned char[])bytes withSize:(CGSize)size{
    UIImage *img = [self getImageWithBytes:bytes withSize:CGSizeMake(size.width,size.height)];
    _imageView.image = img;
    _imageView.size = img.size;
}

- (UIImage *)getImageWithBytes:(unsigned char[])bytes withSize:(CGSize)size{
    int w = size.width;
    int h = size.height;
    int count = w*h;
    
    //转 rgb 数组
    unsigned char drawImg[w * h * 4];
    for (int m = 0; m < count; m++)
    {
        drawImg[m * 4] = bytes[m];
        drawImg[m * 4 + 1] = bytes[m];
        drawImg[m * 4 + 2] = bytes[m];
        drawImg[m * 4 + 3] = 255;
    }
    return  [self getImageWithRgbBytes:drawImg withSize:size];
}

- (UIImage *)getImageWithRgbBytes:(unsigned char[])bytes withSize:(CGSize)size{
    int w = size.width;
    int h = size.height;
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * w;
    NSUInteger bitsPerComponent = 8;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(bytes, w, h, bitsPerComponent, bytesPerRow,
                                                       colorSpace,   kCGImageAlphaPremultipliedLast);
    
    CGImageRef cgRef;
    UIImage *img;
    
    if (!bitmapContext)
    {
        CGContextRelease(bitmapContext);
        CGColorSpaceRelease(colorSpace);
        NSLog(@"位图上下文为空！");
        return nil;
    }
    cgRef = CGBitmapContextCreateImage(bitmapContext);
    img = [[UIImage alloc]initWithCGImage:cgRef];
    CGImageRelease(cgRef);
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    
    return img;
}

@end
