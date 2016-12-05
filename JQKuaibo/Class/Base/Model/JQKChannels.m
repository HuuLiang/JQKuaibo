//
//  Channel.m
//  JQKuaibo
//
//  Created by ylz on 16/6/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKChannels.h"

@implementation JQKChannels

- (Class)programListElementClass {
    return [JQKProgram class];
}
//- (BOOL)isEqual:(id)object {
//    if (![object isKindOfClass:[JQKChannel class]]) {
//        return NO;
//    }
//    
//    return [self.columnId isEqualToNumber:[object columnId]];
//}
//
//- (NSUInteger)hash {
//    return self.columnId.hash;
//}
//
//- (Class)programListElementClass {
//    return [JQKProgram class];
//}
//
//+ (NSString *)cryptPasswordForProperty:(NSString *)propertyName withInstance:(id)instance {
//    if ([instance class] == [JQKChannel class]) {
//        NSArray *cryptProperties = @[@"columnDesc",@"name",@"columnImg",@"spreadUrl"];
//        if ([cryptProperties containsObject:propertyName]) {
//            return kPersistenceCryptPassword;
//        }
//    } else if ([instance class] == [JQKProgram class]) {
//        NSArray *cryptProperties = @[@"videoUrl",@"coverImg",@"offUrl",@"title",@"specialDesc"];
//        if ([cryptProperties containsObject:propertyName]) {
//            return kPersistenceCryptPassword;
//        }
//    }
//    return nil;
//}
@end
