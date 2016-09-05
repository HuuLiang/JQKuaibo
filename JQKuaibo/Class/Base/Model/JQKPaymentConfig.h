//
//  JQKPaymentConfig.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKURLResponse.h"

#import "JQKPaymentConfigSummary.h"
#import "JQKPaymentConfigDetail.h"

@interface JQKPaymentConfig : JQKURLResponse

@property (nonatomic,retain) JQKPaymentConfigSummary *payConfig;
@property (nonatomic,retain) JQKPaymentConfigDetail *configDetails;

+ (instancetype)sharedConfig;
- (void)setAsCurrentConfig;

- (JQKPaymentType)wechatPaymentType;
- (JQKPaymentType)alipayPaymentType;
- (JQKPaymentType)qqPaymentType;

@end
