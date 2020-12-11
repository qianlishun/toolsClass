//
//  QMenuView.h
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QMenuView : UIView

- (void)setViewList:(NSArray*)views forNames:(NSArray*)names;

- (void)appendView:(UIView*)view name:(NSString*)name forID:(NSString*)ID;

- (void)insertViewAfterID:(NSString *)afterID view:(UIView*)view name:(NSString*)name forID:(NSString*)ID;

- (BOOL)deleteViewWithID:(NSString*)ID;

- (UIView*)findViewWithID:(NSString*)ID;
@end
