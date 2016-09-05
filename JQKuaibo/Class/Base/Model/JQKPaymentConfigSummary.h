//
//  JQKPaymentConfigSummary.h
//  JQKuaibo
//
//  Created by Liang on 16/9/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kJQKWeChatPayConfigName;
extern NSString *const kJQKAlipayPayConfigName;
extern NSString *const kJQKUnionPayConfigName;
extern NSString *const kJQKQQPayConfigName;

@interface JQKPaymentConfigSummary : NSObject <JQKResponseParsable>

@property (nonatomic) NSString *wechat;
@property (nonatomic) NSString *alipay;
@property (nonatomic) NSString *unionpay;
@property (nonatomic) NSString *qqpay;


@end
