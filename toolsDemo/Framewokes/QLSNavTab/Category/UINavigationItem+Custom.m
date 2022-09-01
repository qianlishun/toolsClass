//
//  UINavigationItem+Custom.m
//  QLSNavTab
//
//  Created by Mr.Q on 15/9/17.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "UINavigationItem+Custom.h"

@implementation UINavigationItem (Custom)

-(void)setMyTitle:(NSString*)title{

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];

    titleLabel.textColor = [UIColor whiteColor];

    titleLabel.textAlignment = NSTextAlignmentCenter;

    titleLabel.text = title;

    self.titleView=titleLabel;
}


- (void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem{
    if(!rightBarButtonItem){
        return;
    }
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                          initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                          target:nil action:nil];
    /**
        *  width为负数时，相当于btn向右移动width数值个像素，
        由于按钮本身和边界间距为5pix，所以width设为-5时，间距正好调整为0；
        width为正数时，正好相反，相当于往左移动width数值个像素
         */
    negativeSpacer.width = 15;
    
    self.rightBarButtonItems = @[negativeSpacer,rightBarButtonItem];

}
@end
