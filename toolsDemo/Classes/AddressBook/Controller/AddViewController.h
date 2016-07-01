//
//  AddViewController.h
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
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