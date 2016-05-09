//
//  Contact.m
//  toolsDemo
//
//  Created by Mr.Q on 16/5/9.
//  Copyright © 2016年 钱立顺. All rights reserved.
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
