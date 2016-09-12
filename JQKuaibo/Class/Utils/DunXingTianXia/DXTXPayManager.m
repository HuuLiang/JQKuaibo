//
//  DXTXPayManager.m
//  YYKuaibo
//
//  Created by Sean Yue on 16/9/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "DXTXPayManager.h"
#import <AFNetworking.h>
#import "PayuPlugin.h"

@implementation DXTXPayManager

+ (instancetype)sharedManager {
    static DXTXPayManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setAppKey:(NSString *)appKey {
    _appKey = appKey;
    [[PayuPlugin defaultPlugin] registWithAppKey:appKey];
}

- (void)handleOpenURL:(NSURL *)url {
    [[PayuPlugin defaultPlugin] processOrderWithPaymentResult:url];
}

- (void)payWithPaymentInfo:(JQKPaymentInfo *)paymentInfo
         completionHandler:(JQKPaymentCompletionHandler)completionHandler
{
    if (self.appKey.length == 0 || self.waresid == nil || paymentInfo.orderId.length == 0 || paymentInfo.orderDescription.length == 0) {
        SafelyCallBlock(completionHandler, PAYRESULT_FAIL, paymentInfo);
        return ;
    }
    
    PayType type = 0;
    
    if (paymentInfo.paymentSubtype.unsignedIntegerValue == JQKSubPayTypeAlipay) {
        type = PayTypeAliPay;
    } else if (paymentInfo.paymentSubtype.unsignedIntegerValue == JQKSubPayTypeWeChat) {
        type = PayTypeWX;
    } else {
        SafelyCallBlock(completionHandler, PAYRESULT_FAIL, paymentInfo);
        return ;
    }

    [[PayuPlugin defaultPlugin] payWithViewController:[JQKUtil currentVisibleViewController]
                                         o_paymode_id:type
                                            O_bizcode:paymentInfo.orderId
                                           o_goods_id:[self.waresid intValue]
                                         o_goods_name:paymentInfo.orderDescription
                                              o_price:[paymentInfo.orderPrice doubleValue] /100.
                                        o_privateinfo:[NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO]
                                               Scheme:self.urlScheme
                                               AppKey:self.appKey
                                        completeBlock:^(NSDictionary *result)
    {
        DLog(@"%@",result);
        NSInteger payResult = PAYRESULT_UNKNOWN;
        if ([result[@"resultStatus"] integerValue] ==  9000) {
            payResult = PAYRESULT_SUCCESS;
        } else if ([result[@"resultStatus"] integerValue] ==  703 || [result[@"resultStatus"] integerValue] == 6001) {
            payResult = PAYRESULT_ABANDON;
        } else {
            payResult = PAYRESULT_FAIL;
        }
        
        SafelyCallBlock(completionHandler,payResult,paymentInfo);

    }];
}

@end
