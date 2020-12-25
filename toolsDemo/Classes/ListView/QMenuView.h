//
//  QMenuView.h
//  toolsDemo
//
//  Created by mrq on 2020/12/11.
//  Copyright © 2020 钱立顺. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QMenuView : UIView

/*
 cells NSArray
 [
    {"ID1":[label1,view1,lablel2,view2]},
    {"ID2":[label,view]},
    {"ID3":[view]}
 ]
 */
- (void)setCellList:(NSArray*)cells;


/*
 cell NSDictionary
 {
    "ID":[label1,view1,label2,view2]
 }
 */
- (void)appendCell:(NSDictionary*)cell;

- (void)insertCell:(NSDictionary*)cell afterID:(NSString*)afterID;

- (BOOL)deleteCellWithID:(NSString*)ID;

- (NSArray*)findCellWithID:(NSString*)ID;

- (void)setCellSize:(CGSize)size;

@end
