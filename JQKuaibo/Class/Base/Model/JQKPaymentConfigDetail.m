//
//  JQKPaymentConfigDetail.m
//  JQKuaibo
//
//  Created by Liang on 16/9/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKPaymentConfigDetail.h"
#import "JQKPaymentConfigSummary.h"

NSString *const kJQKIAppPayConfigName = @"IAPPPAY";
NSString *const kJQKVIAPayConfigName = @"SYSK";
NSString *const kJQKMingPayConfigName = @"MPENG";
NSString *const kJQKSPayConfigName = @"WFT";
NSString *const kJQKHTPayConfigName = @"HAITUN";
NSString *const kJQKDXTXPayConfigName = @"DXTX";

@implementation JQKPaymentConfigDetail

- (Class)JQK_classOfProperty:(NSString *)propName {
    if ([propName isEqualToString:NSStringFromSelector(@selector(iAppPayConfig))]) {
        return [JQKIAppPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(viaPayConfig))]) {
        return [JQKVIAPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(mingPayConfig))]) {
        return [JQKMingPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(spayConfig))]) {
        return [JQKSPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(haitunConfig))]) {
        return [JQKHTPayConfig class];
    } else if ([propName isEqualToString:NSStringFromSelector(@selector(dxtxPayConfig))]) {
        return [JQKDXTXPayConfig class];
    }
    return nil;
}

- (NSString *)JQK_propertyOfParsing:(NSString *)parsingName {
    if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKIAppPayConfigName]]) {
        return NSStringFromSelector(@selector(iAppPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKVIAPayConfigName]]) {
        return NSStringFromSelector(@selector(viaPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKMingPayConfigName]]) {
        return NSStringFromSelector(@selector(mingPayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKSPayConfigName]]) {
        return NSStringFromSelector(@selector(spayConfig));
    } else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKHTPayConfigName]]) {
        return NSStringFromSelector(@selector(haitunConfig));
    }else if ([parsingName hasSuffix:[@"-" stringByAppendingString:kJQKDXTXPayConfigName]]) {
        return NSStringFromSelector(@selector(dxtxPayConfig));
    }
    return nil;
}
@end

@implementation JQKIAppPayConfig

+ (instancetype)defauJQKConfig {
    JQKIAppPayConfig *config = [[self alloc] init];
    config.appid = @"3006339410";
    config.privateKey = @"MIICWwIBAAKBgQCHEQCLCZujWicF6ClEgHx4L/OdSHZ1LdKi/mzPOIa4IRfMOS09qDNV3+uK/zEEPu1DgO5Cl1lsm4xpwIiOqdXNRxLE9PUfgRy4syiiqRfofAO7w4VLSG4S0VU5F+jqQzKM7Zgp3blbc5BJ5PtKXf6zP3aCAYjz13HHH34angjg0wIDAQABAoGASOJm3aBoqSSL7EcUhc+j2yNdHaGtspvwj14mD0hcgl3xPpYYEK6ETTHRJCeDJtxiIkwfxjVv3witI5/u0LVbFmd4b+2jZQ848BHGFtZFOOPJFVCyJQKy5j5O79mEx0nJN0EJ/qadwezXr4UZLDIaJdWxhhvS+yDe0e0foz5AxWmkCQQDhd9U1uUasiMmH4WvHqMfq5l4y4U+V5SGb+IK+8Vi03Zfw1YDvKrgv1Xm1mdzYHFLkC47dhTm7/Ko8k5Kncf89AkEAmVtEtycnSYciSqDVXxWtH1tzsDeIMz/ZlDGXCAdUfRR2ZJ2u2jrLFunoS9dXhSGuERU7laasK0bDT4p0UwlhTwJAVF+wtPsRnI1PxX6xA7WAosH0rFuumax2SFTWMLhGduCZ9HEhX97/sD7V3gSnJWRsDJTasMEjWtrxpdufvPOnDQJAdsYPVGMItJPq5S3n0/rv2Kd11HdOD5NWKsa1mMxEjZN5lrfhoreCb7694W9pI31QWX6+ZUtvcR0fS82KBn3vVQJAa0fESiiDDrovKHBm/aYXjMV5anpbuAa5RJwCqnbjCWleZMwHV+8uUq9+YMnINZQnvi+C62It4BD+KrJn5q4pwg==";
    config.publicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCbNQyxdpLeMwE0QMv/dB3Jn1SRqYE/u3QT3ig2uXu4yeaZo4f7qJomudLKKOgpa8+4a2JAPRBSueDpiytR0zN5hRZKImeZAu2foSYkpBqnjb5CRAH7roO7+ervoizg6bhAEx2zlJQKV9wZKQZ0Di5wCCV+bMSEXkYqfASRplYUvHwIDAQAB";
    config.waresid = @(1);
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyIpay.json";
    config.supportPayTypes = @(JQKSubPayTypeWeChat|JQKSubPayTypeAlipay);
    return config;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKIAppPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.appid forKey:@"appid"];
    [dicRep safelySetObject:self.privateKey forKey:@"privateKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    [dicRep safelySetObject:self.waresid forKey:@"waresid"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    [dicRep safelySetObject:self.publicKey forKey:@"publicKey"];
    return dicRep;
}
@end

@implementation JQKVIAPayConfig

+ (instancetype)defauJQKConfig {
    JQKVIAPayConfig *config = [[self alloc] init];
    //config.packageId = @"5361";
    config.supportPayTypes = @(JQKSubPayTypeAlipay|JQKSubPayTypeWeChat);
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    //    [dicRep safelySetObject:self.packageId forKey:@"packageId"];
    [dicRep safelySetObject:self.supportPayTypes forKey:@"supportPayTypes"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKVIAPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKSPayConfig

//+ (instancetype)defauJQKConfig {
//    JQKSPayConfig *config = [[self alloc] init];
//    config.mchId = @"5712000010";
//    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyWft.json";
//    config.signKey = @"5afe11de0df374f5f78839db1904ff0d";
//    return config;
//}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.signKey forKey:@"signKey"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKSPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end

@implementation JQKHTPayConfig

+ (instancetype)defauJQKConfig {
    JQKHTPayConfig *config = [[self alloc] init];
    config.mchId = @"10605";
    config.key = @"e7c549c833cb9108e6524d075942119d";
    config.notifyUrl = @"http://phas.ihuiyx.com/pd-has/notifyHtPay.json";
    return config;
}

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mchId forKey:@"mchId"];
    [dicRep safelySetObject:self.key forKey:@"key"];
    [dicRep safelySetObject:self.notifyUrl forKey:@"notifyUrl"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKHTPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}

@end

@implementation JQKMingPayConfig

- (NSDictionary *)dictionaryRepresentation {
    NSMutableDictionary *dicRep = [NSMutableDictionary dictionary];
    [dicRep safelySetObject:self.mch forKey:@"mch"];
    return dicRep;
}

+ (instancetype)configFromDictionary:(NSDictionary *)dic {
    JQKMingPayConfig *config = [[self alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj) {
            [config setValue:obj forKey:key];
        }
    }];
    return config;
}
@end
@implementation JQKDXTXPayConfig

@end
