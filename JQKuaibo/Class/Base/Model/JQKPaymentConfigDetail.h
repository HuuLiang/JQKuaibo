//
//  JQKPaymentConfigDetail.h
//  JQKuaibo
//
//  Created by Liang on 16/9/5.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JQKIAppPayConfig;
@class JQKVIAPayConfig;
@class JQKMingPayConfig;
@class JQKSPayConfig;
@class JQKHTPayConfig;

extern NSString *const kJQKIAppPayConfigName;
extern NSString *const kJQKVIAPayConfigName;
extern NSString *const kJQKMingPayConfigName;
extern NSString *const kJQKSPayConfigName;
extern NSString *const kJQKHTPayConfigName;

@interface JQKPaymentConfigDetail : NSObject <JQKResponseParsable>

@property (nonatomic,retain) JQKIAppPayConfig *iAppPayConfig; //爱贝支付
@property (nonatomic,retain) JQKVIAPayConfig *viaPayConfig; //首游时空
@property (nonatomic,retain) JQKMingPayConfig *mingPayConfig; //明鹏支付
@property (nonatomic,retain) JQKSPayConfig *spayConfig; //威富通
@property (nonatomic,retain) JQKHTPayConfig *haitunConfig;//海豚支付
@end

@interface JQKIAppPayConfig : NSObject
@property (nonatomic) NSString *appid;
@property (nonatomic) NSString *privateKey;
@property (nonatomic) NSString *publicKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defauJQKConfig;
@end

@interface JQKVIAPayConfig : NSObject

//@property (nonatomic) NSString *packageId;
@property (nonatomic) NSNumber *supportPayTypes;

+ (instancetype)defauJQKConfig;

@end

@interface JQKMingPayConfig : NSObject

@property (nonatomic) NSString *payUrl;
@property (nonatomic) NSString *queryOrderUrl;
@property (nonatomic) NSString *mch;

@end

@interface JQKSPayConfig : NSObject
@property (nonatomic) NSString *signKey;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end

@interface JQKHTPayConfig : NSObject
@property (nonatomic) NSString *key;
@property (nonatomic) NSString *mchId;
@property (nonatomic) NSString *notifyUrl;
@end
