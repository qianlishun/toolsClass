//
//  Contact.m
//  toolsDemo
//
//  Created by Mr.Q on 15/12/20.
//  Copyright © 2015年 QLS. All rights reserved.
//

#import "Contact.h"

@implementation Contact


// 告诉系统要归档哪些属性
- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_number forKey:@"number"];

}

// 告诉系统解档哪些属性
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if(self){

        _name  =   [coder decodeObjectForKey:@"name"];
        _number =  [coder decodeObjectForKey:@"number"];
    }
    return self;
}

@end
