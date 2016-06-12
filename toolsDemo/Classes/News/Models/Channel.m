//
//  Channel.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/10.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "Channel.h"


@implementation Channel
+ (instancetype)channelWithDic:(NSDictionary *)dic {
    Channel *channel = [self new];
    [channel setValuesForKeysWithDictionary:dic];
    return channel;
}

//频道对应的新闻的路径
- (NSString *)urlString {
    return [NSString stringWithFormat:@"article/headline/%@/0-140.html",self.tid];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}


+ (NSArray *)channels {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"topic_news.json" ofType:nil];

    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    NSArray *array = dic[@"tList"];
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSDictionary *subDic in array) {
        Channel *channel = [Channel channelWithDic:subDic];
        [tmpArray addObject:channel];
    }

    return [tmpArray sortedArrayUsingComparator:^NSComparisonResult(Channel *obj1, Channel *obj2) {
        return [obj1.tid compare:obj2.tid];
    }];

}
@end
