//
//  JQKPaymentConfig.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentConfig.h"

static JQKPaymentConfig *_shardConfig;
static NSString *const kPaymentConfigKeyName = @"JQKkuaibo_payment_config_key_name";

@interface JQKPaymentConfig ()
@property (nonatomic) NSNumber *code;
@property (nonatomic,retain) NSDictionary *paymentTypeMapping;
@end


@implementation JQKPaymentConfig

+ (instancetype)sharedConfig {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *configDic = [[NSUserDefaults standardUserDefaults] objectForKey:kPaymentConfigKeyName];
        _shardConfig = [self objectFromDictionary:configDic withDecryptBlock:nil];
        
        if (!_shardConfig) {
            _shardConfig = [self defauJQKConfig];
        }
    });
    return _shardConfig;
}

+ (instancetype)defauJQKConfig {
    JQKPaymentConfig *defauJQKConfig = [[self alloc] init];
    
    defauJQKConfig.payConfig = [[JQKPaymentConfigSummary alloc] init];
    defauJQKConfig.payConfig.wechat = kJQKVIAPayConfigName;
    defauJQKConfig.payConfig.alipay = kJQKVIAPayConfigName;
    
    defauJQKConfig.configDetails = [[JQKPaymentConfigDetail alloc] init];
    defauJQKConfig.configDetails.viaPayConfig = [JQKVIAPayConfig defauJQKConfig];
    
    return defauJQKConfig;
}

- (NSDictionary *)paymentTypeMapping {
    if (_paymentTypeMapping) {
        return _paymentTypeMapping;
    }
    
    _paymentTypeMapping = @{kJQKVIAPayConfigName:@(JQKPaymentTypeVIAPay),
                            kJQKIAppPayConfigName:@(JQKPaymentTypeIAppPay),
                            kJQKSPayConfigName:@(JQKPaymentTypeSPay),
                            kJQKHTPayConfigName:@(JQKPaymentTypeHTPay)};
    return _paymentTypeMapping;
}

- (JQKPaymentType)wechatPaymentType {
    if (self.payConfig.wechat) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.wechat];
        return type ? type.unsignedIntegerValue : JQKPaymentTypeNone;
    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)alipayPaymentType {
    if (self.payConfig.alipay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.alipay];
        return type ? type.unsignedIntegerValue : JQKPaymentTypeNone;
    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)qqPaymentType {
    if (self.payConfig.qqpay) {
        NSNumber *type = self.paymentTypeMapping[self.payConfig.qqpay];
        return type ? type.unsignedIntegerValue : JQKPaymentTypeNone;
    }
    return JQKPaymentTypeNone;
}

- (NSNumber *)success {
    return self.code.unsignedIntegerValue == 100 ? @(YES) : @(NO);
}

- (NSString *)resuJQKCode {
    return self.code.stringValue;
}

- (Class)payConfigClass {
    return [JQKPaymentConfigSummary class];
}

- (Class)configDetailsClass {
    return [JQKPaymentConfigDetail class];
}

- (void)setAsCurrentConfig {
    JQKPaymentConfig *currentConfig = [[self class] sharedConfig];
    currentConfig.payConfig = self.payConfig;
    currentConfig.configDetails = self.configDetails;
    
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentationWithEncryptBlock:nil] forKey:kPaymentConfigKeyName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
