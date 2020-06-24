//
//  USAnnotate.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USMark.h"
@class USRect;

@interface USAnnotate : USMark{
    @protected
    NSString *annotateString;
    USRect *rectPos;
    
    BOOL selected;
    
}

- (void)setRect:(USRect*)rect;

- (USRect*)getRect;

- (NSString*)getString;

- (void)setString:(NSString*)str;

- (void)setColor:(UIColor*)color;
- (void)setFontSize:(float)size;

- (void)select;
@end
