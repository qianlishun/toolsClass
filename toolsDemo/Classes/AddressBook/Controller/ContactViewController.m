//
//  ContactViewController.m
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "ContactViewController.h"
#import "AddViewController.h"
#import "EditViewController.h"


#define kFilePath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"contacts.data"]

@interface ContactViewController () <UIActionSheetDelegate, AddViewControllerDelegate, EditViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray<Contact*> *contacts;

@end
static NSString *const ID = @"contact_cell";

@implementation ContactViewController

// 懒加载
- (NSMutableArray*)contacts
{
    if (!_contacts) {
        _contacts = [NSMutableArray array];
    }
    return _contacts;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:(1.0)];
    // 添加左上角注销的按钮
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:@selector(logOut)];
    self.navigationItem.leftBarButtonItem = item;

    UIBarButtonItem *addItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContact)];
    self.navigationItem.rightBarButtonItem = addItem;

    // 根据传过来的用户名设置标题
    self.navigationItem.title = [NSString stringWithFormat:@"%@的联系人", self.username];

    // 取消分割线(iOS8无效)
    [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];

    //    // 获取沙盒路径
    NSString *home = NSHomeDirectory();
    NSLog(@"%@",home);
    //    NSString *kFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"contacts.data"];


    //    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:ID];

    // 解档
    self.contacts = [NSKeyedUnarchiver unarchiveObjectWithFile:kFilePath];
}


// 某一组有多少行
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}

// cell 长啥样儿!!!
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    // 去缓存池找

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    // 赋值
    cell.textLabel.text = [self.contacts[indexPath.row] name];
    cell.detailTextLabel.text = [self.contacts[indexPath.row] number];

    return cell;
}

// 滑动删除  有该方法就能能出现滑动删除按钮,但是只有在点击删除后才会调用该方法
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    // 删除cell时要先删除相对应的模型
    [self.contacts removeObjectAtIndex:indexPath.row];

    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];

    [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
}

// 添加联系人的代理方法(逆传)
- (void)addViewController:(AddViewController*)addViewController withContact:(Contact*)contact
{
    // 把模型数据放到 contacts 的数组当中
    [self.contacts addObject:contact];

    // 刷新
    [self.tableView reloadData];

    // 归档
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
}

// 编辑联系人的代理方法
- (void)editViewController:(EditViewController*)editViewController withContact:(Contact*)contact
{
    [self.tableView reloadData];
    [NSKeyedArchiver archiveRootObject:self.contacts toFile:kFilePath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    // 顺传赋值
    EditViewController* edit = [[EditViewController alloc]init];

    // 设置代理
    edit.delegate = self;

    // 获取模型
    Contact* con = self.contacts[indexPath.row];

    // 赋值
    edit.contact = con;

    [self.navigationController pushViewController:edit animated:YES];
}

-(void)addContact{

    AddViewController *add = [[AddViewController alloc]init];

    add.delegate = self;

    [self.navigationController pushViewController:add animated:YES];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

// 注册按钮的点击事件
- (void)logOut
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:@"你确定要注销嘛?!" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"注销" otherButtonTitles:nil, nil];

    [sheet showInView:self.view];
}

// acitonSheet的点击事件 buttonIndex: 从0开始 从上往下依次递增
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        // 返回上一个控制器
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// item 枚举的区别
- (void)test
{
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStylePlain target:self action:nil]; // 细

    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithTitle:@"注销" style:UIBarButtonItemStyleDone target:self action:nil]; // 粗
    
    self.navigationItem.leftBarButtonItems = @[ item, item1 ];
}

@end
