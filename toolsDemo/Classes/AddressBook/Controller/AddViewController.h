//
//  AddViewController.h
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@class AddViewController;

@protocol AddViewControllerDelegate <NSObject>

@optional
- (void)addViewController:(AddViewController*)addViewController withContact:(Contact*)contact;

@end

@interface AddViewController : UIViewController

@property (nonatomic, weak) id<AddViewControllerDelegate> delegate;

@end