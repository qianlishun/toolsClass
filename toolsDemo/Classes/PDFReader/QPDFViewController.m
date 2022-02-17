//
//  QPDFViewController.m
//  toolsDemo
//
//  Created by Qianlishun on 2022/2/10.
//  Copyright © 2022 钱立顺. All rights reserved.
//

#import "QPDFViewController.h"
#import "QStateModel.h"
#import "UIView+SDAutoLayout.h"
#import "QPDFReader.h"


@interface QPDFViewController ()
@property (nonatomic,copy) NSArray<NSDictionary*>  *contenArray;
@property(nonatomic, strong) QPDFReader *pdfReader;

@end

@implementation QPDFViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pdfReader = [QPDFReader new];
        
        [QStateModel createFolderPath:customPDFPath];
        
        NSMutableArray<NSDictionary*> *array = [NSMutableArray array];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSDirectoryEnumerator *enumerator = [fileManager enumeratorAtPath:customPDFPath];
        for (NSString *path in enumerator) {
            if([path.pathExtension isEqualToString:@"pdf"]){
                NSString *filePath =  [customPDFPath stringByAppendingPathComponent:path];
                [array addObject:@{@"Name":path.lastPathComponent,@"Path":filePath}];
            }
        }
        self.contenArray = array.copy;
        
        
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
        
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (void)openPDFWithPath:(NSString *)path{
   
    PDFDocument *docunment = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:path]];
    
    self.pdfReader.document = docunment;
    
    [self.navigationController pushViewController:self.pdfReader animated:YES];
    
}

#pragma mark - tableView date source
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contenArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"PDFCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    NSDictionary *dict = self.contenArray[indexPath.row];
    cell.textLabel.text = dict[@"Name"];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = self.contenArray[indexPath.row];
    
    PDFDocument *docunment = [[PDFDocument alloc] initWithURL:[NSURL fileURLWithPath:dict[@"Path"]]];
    self.pdfReader.document = docunment;
    
    [self.navigationController pushViewController:self.pdfReader animated:YES];
}

-(void)dealloc{
    NSLog(@"%@ dealloc",NSStringFromClass([self class]));
}
@end
