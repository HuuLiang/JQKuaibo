//
//  JQKPaymentConfigSummary.m
//  JQKuaibo
//
//  Created by Liang on 16/9/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentConfigSummary.h"

NSString *const kJQKWeChatPayConfigName = @"WEIXIN";
NSString *const kJQKAlipayPayConfigName = @"ALIPAY";
NSString *const kJQKUnionPayConfigName = @"UNIONPAY";
NSString *const kJQKQQPayConfigName = @"QQPAY";

@implementation JQKPaymentConfigSummary

- (NSString *)LT_propertyOfParsing:(NSString *)parsingName {
    NSDictionary *mapping = @{kJQKWeChatPayConfigName:NSStringFromSelector(@selector(wechat)),
                              kJQKAlipayPayConfigName:NSStringFromSelector(@selector(alipay)),
                              kJQKUnionPayConfigName:NSStringFromSelector(@selector(unionpay)),
                              kJQKQQPayConfigName:NSStringFromSelector(@selector(qqpay))};
    return mapping[parsingName];
}

@end
