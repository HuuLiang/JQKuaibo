//
//  HTPayManager.m
//  JFVideo
//
//  Created by Liang on 16/9/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "HTPayManager.h"
#import "HaiTunPay.h"
#import "SPayClient.h"
#import "JQKPaymentConfig.h"

static NSString * const kHTPayBaseUrl       = @"http://p.ylsdk.com/";
static NSString * const kHTPaySelectedUrl   = @"http://c.ylsdk.com/";
static NSString * const kHTPayType          = @"b";

@interface HTPayManager ()
{
    JQKPaymentConfig *_config;
}
@property (nonatomic,copy) JQKPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;
@end

@implementation HTPayManager

+ (instancetype)sharedManager {
    static HTPayManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)registerHaitunSDKWithApplication:(UIApplication *)application Options:(NSDictionary *)options {
    _config = [JQKPaymentConfig sharedConfig];
    
    
    SPayClientWechatConfigModel *wechatConfigModel = [[SPayClientWechatConfigModel alloc] init];
    wechatConfigModel.appScheme = @"wxd3c9c179bb827f2c";
    wechatConfigModel.wechatAppid = @"wxd3c9c179bb827f2c";
    //配置微信APP支付
    [[SPayClient sharedInstance] wechatpPayConfig:wechatConfigModel];
    
    [[SPayClient sharedInstance] application:application
               didFinishLaunchingWithOptions:options];
    
    [HaiTunPay RequestManagerWithHaiTunPaySignVal:_config.configDetails.haitunConfig.key
                                 haiTunPayBaseUrl:kHTPayBaseUrl
                                            merId:_config.configDetails.haitunConfig.mchId
                                  haiTunSelectUrl:kHTPaySelectedUrl
                                      Sjt_Paytype:kHTPayType];
    
}

- (void)payWithPaymentInfo:(JQKPaymentInfo *)paymentInfo completionHandler:(JQKPaymentCompletionHandler)completionHandler {
    self.completionHandler = completionHandler;
    self.paymentInfo = paymentInfo;
    self.isAutoForeground = NO;

    NSDictionary *postInfo = @{@"p2_Order": paymentInfo.orderId,//商户订单号
                               @"p3_Amt": [NSString stringWithFormat:@"%ld",[paymentInfo.orderPrice integerValue]/100],//支付金额
                               @"p7_Pdesc": @"VIP",//paymentInfo.orderDescription,//商品描述
                               @"p8_Url": _config.configDetails.haitunConfig.notifyUrl,//支付成功后会跳转此地址
                               @"Sjt_UserName": [NSString stringWithFormat:@"%@$%@", JQK_REST_APP_ID, JQK_CHANNEL_NO],//支付用户
                               };
    //调用支付方法
    [[HaiTunPay shareInstance] requestWithUrl:[HaiTunPay shareInstance].haiTunPayBaseUrl
                               viewcontroller:[JQKUtil currentVisibleViewController]
                                  requestType:RequestTypePOST
                                       parDic:postInfo finish:^(NSData *data)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        DLog(@"dic=%@",dic);

    } error:^(NSError *error) {
        DLog(@"error=%ld",error.code);
        [self sendPayResultStateWithStr:[NSString stringWithFormat:@"%ld",error.code]];
    } failure:^(NSString *failure) {
        self.isAutoForeground = YES;
        [self sendPayResultStateWithStr:failure];
        DLog(@"failure=%@",failure);
    }];
}

- (void)searchOrderState {
    if (!self.isAutoForeground && self.paymentInfo != nil) {
        NSDictionary *transDic = @{@"Sjt_TransID": self.paymentInfo.orderId};
        [[HaiTunPay shareInstance] requestWithUrl:[HaiTunPay shareInstance].haiTunSelectUrl
                                      requestType:RequestTypePOST
                                           parDic:transDic
                                           finish:^(NSData *data)
        {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            DLog(@"dic=%@",dic);
        } error:^(NSError *error) {
            [self sendPayResultStateWithStr:[NSString stringWithFormat:@"%ld",error.code]];
            DLog(@"error=%ld",error.code);
        } result:^(NSString *state) {
            [self sendPayResultStateWithStr:state];
            DLog(@"failure=%@",state);
        }];
    }
}

- (void)sendPayResultStateWithStr:(NSString *)statusCode {
    NSNumber *paymentResult;
    if ([statusCode isEqualToString:@"201"] || [statusCode isEqualToString:@"1"]) {
        paymentResult = @(PAYRESULT_SUCCESS);
    } else if ([statusCode isEqualToString:@"601"] || [statusCode isEqualToString:@"0"]) {
        paymentResult = @(PAYRESULT_FAIL);
    } else {
        paymentResult = @(PAYRESULT_UNKNOWN);
    }

    SafelyCallBlock(self.completionHandler, paymentResult.unsignedIntegerValue, self.paymentInfo);
    self.completionHandler = nil;
    self.paymentInfo = nil;
    
}


@end
