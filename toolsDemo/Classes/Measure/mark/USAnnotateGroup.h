//
//  USAnnotateGroup.h
//  WirelessUSG3
//
//  Created by mrq on 2017/6/8.
//  Copyright © 2017年 SonopTek. All rights reserved.
//

#import "USAnnotate.h"

@interface USAnnotateGroup : USAnnotate{
    @protected
    NSMutableArray<USAnnotate*> *annotateList;
}

- (void)addAnnotate:(USAnnotate *)annotate;

- (void)removeAnnotate:(USAnnotate*)annotate;

- (void)clear;

- (int)annotateCount;


@end
