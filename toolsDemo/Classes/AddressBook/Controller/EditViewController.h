//
//  EditViewController.h
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact.h"
@class EditViewController;

@protocol EditViewControllerDelegate <NSObject>

@optional
- (void)editViewController:(EditViewController*)editViewController withContact:(Contact*)contact;

@end

@interface EditViewController : UIViewController

@property (nonatomic, strong) Contact* contact;

@property (nonatomic, weak) id<EditViewControllerDelegate> delegate;

@end
