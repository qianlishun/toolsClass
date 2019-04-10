//
//  QEatEditView.h
//  toolsDemo
//
//  Created by mrq on 2019/4/10.
//  Copyright © 2019 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditBlock)(NSArray *list);

@interface QEatEditView : UIView

@property (nonatomic,copy) EditBlock doneBlock;

- (void)setList:(NSArray*)list;

- (NSArray*)getList;
@end

