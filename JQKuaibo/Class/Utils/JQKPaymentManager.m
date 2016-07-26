//
//  JQKPaymentManager.m
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import "JQKPaymentManager.h"
#import "JQKPaymentInfo.h"
#import "JQKPaymentViewController.h"
#import "JQKProgram.h"
#import "JQKPaymentConfigModel.h"

#import "WXApi.h"
#import "WeChatPayQueryOrderRequest.h"
#import "WeChatPayManager.h"

#import "JQKSystemConfigModel.h"
#import "IappPayMananger.h"
#import <PayUtil/PayUtil.h>

static NSString *const kAlipaySchemeUrl = @"comjqkuaibo2016appalipayurlscheme";

@interface JQKPaymentManager () <WXApiDelegate,stringDelegate>//
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;
@property (nonatomic,copy) JQKPaymentCompletionHandler completionHandler;
@property (nonatomic,retain) WeChatPayQueryOrderRequest *wechatPayOrderQueryRequest;
@end

@implementation JQKPaymentManager

DefineLazyPropertyInitialization(WeChatPayQueryOrderRequest, wechatPayOrderQueryRequest)

typedef NS_ENUM(NSUInteger, JQKVIAPayType) {
    JQKVIAPayTypeNone,
    JQKVIAPayTypeWeChat = 2,
    JQKVIAPayTypeQQ = 3,
    JQKVIAPayTypeUPPay = 4,
    JQKVIAPayTypeShenZhou = 5
};

+ (instancetype)sharedManager {
    static JQKPaymentManager *_sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (void)setup {
    [[PayUitls getIntents] initSdk];
    [paySender getIntents].delegate = self;
    
    [[JQKPaymentConfigModel sharedModel] fetchConfigWithCompletionHandler:^(BOOL success, id obj) {
      
    }];
    
    Class class = NSClassFromString(@"VIASZFViewController");
    if (class) {
        [class aspect_hookSelector:NSSelectorFromString(@"viewWillAppear:")
                       withOptions:AspectPositionAfter
                        usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated)
         {
             UIViewController *thisVC = [aspectInfo instance];
             if ([thisVC respondsToSelector:NSSelectorFromString(@"buy")]) {
                 UIViewController *buyVC = [thisVC valueForKey:@"buy"];
                 [buyVC.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                     if ([obj isKindOfClass:[UIButton class]]) {
                         UIButton *buyButton = (UIButton *)obj;
                         if ([[buyButton titleForState:UIControlStateNormal] isEqualToString:@"购卡支付"]) {
                             [buyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
                         }
                     }
                 }];
             }
         } error:nil];
    }
}

- (JQKPaymentType)wechatPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JQKSubPayTypeWeChat) {
        return JQKPaymentTypeVIAPay;
    }
//    else if ([JQKPaymentConfig sharedConfig].wftPayInfo) {
//        return JQKPaymentTypeSPay;
//    } else if ([JQKPaymentConfig sharedConfig].iappPayInfo) {
//        return JQKPaymentTypeIAppPay;
//    } else if ([JQKPaymentConfig sharedConfig].haitunPayInfo) {
//        return JQKPaymentTypeHTPay;
//    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)alipayPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.integerValue & JQKSubPayTypeAlipay) {
        return JQKPaymentTypeVIAPay;
    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)cardPayPaymentType {
    if ([JQKPaymentConfig sharedConfig].iappPayInfo) {
        return JQKPaymentTypeIAppPay;
    }
    return JQKPaymentTypeNone;
}

- (JQKPaymentType)qqPaymentType {
    if ([JQKPaymentConfig sharedConfig].syskPayInfo.supportPayTypes.unsignedIntegerValue & JQKSubPayTypeQQ) {
        return JQKPaymentTypeVIAPay;
    }
    return JQKPaymentTypeNone;
}

- (void)handleOpenURL:(NSURL *)url  {
    [[PayUitls getIntents] paytoAli:url];
}

- (JQKPaymentInfo *)startPaymentWithType:(JQKPaymentType)type
                                 subType:(JQKSubPayType)subType
                                   price:(NSUInteger)price
                              forProgram:(JQKProgram *)program
                         programLocation:(NSUInteger)programLocation
                               inChannel:(JQKChannels *)channel
                       completionHandler:(JQKPaymentCompletionHandler)handler
{
    if (type == JQKPaymentTypeNone ) {
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, nil);
        }
        return nil;
    }
//            price  =  1;
    NSString *channelNo = JQK_CHANNEL_NO;
    channelNo = [channelNo substringFromIndex:channelNo.length-14];
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    
    JQKPaymentInfo *paymentInfo = [[JQKPaymentInfo alloc] init];
    paymentInfo.contentLocation = @(programLocation+1);
    paymentInfo.columnId = channel.realColumnId;
    paymentInfo.columnType = channel.type;
    
    paymentInfo.orderId = orderNo;
    paymentInfo.orderPrice = @(price);
    paymentInfo.contentId = program.programId;
    paymentInfo.contentType = program.type;
    paymentInfo.payPointType = program.payPointType;
    paymentInfo.paymentType = @(type);
    paymentInfo.paymentResult = @(PAYRESULT_UNKNOWN);
    paymentInfo.paymentStatus = @(JQKPaymentStatusPaying);
    paymentInfo.reservedData = JQK_PAYMENT_RESERVE_DATA;
    if (type == JQKPaymentTypeWeChatPay) {
        paymentInfo.appId = [JQKPaymentConfig sharedConfig].weixinInfo.appId;
        paymentInfo.mchId = [JQKPaymentConfig sharedConfig].weixinInfo.mchId;
        paymentInfo.signKey = [JQKPaymentConfig sharedConfig].weixinInfo.signKey;
        paymentInfo.notifyUrl = [JQKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
    }
    [paymentInfo save];
    self.paymentInfo = paymentInfo;
    self.completionHandler = handler;
    
    BOOL success = YES;
    
    if (type == JQKPaymentTypeVIAPay &&(subType == JQKSubPayTypeWeChat || subType == JQKSubPayTypeAlipay || subType == JQKSubPayTypeQQ)) {   //首游
        NSDictionary *viaPayTypeMapping = @{@(JQKSubPayTypeAlipay):@(JQKVIAPayTypeShenZhou),
                                            @(JQKSubPayTypeWeChat):@(JQKVIAPayTypeWeChat),
                                            @(JQKSubPayTypeQQ):@(JQKVIAPayTypeQQ)};
        NSString *tradeName = @"VIP会员";
        [[PayUitls getIntents] gotoPayByFee:@(price).stringValue
                               andTradeName:tradeName
                            andGoodsDetails:tradeName
                                  andScheme:kAlipaySchemeUrl
                          andchannelOrderId:[orderNo stringByAppendingFormat:@"$%@", JQK_REST_APP_ID] andType:[viaPayTypeMapping[@(subType)] stringValue]
                           andViewControler:[JQKUtil currentVisibleViewController]];
        
    } else if (type == JQKPaymentTypeIAppPay){
        IappPayMananger *iAppMgr = [IappPayMananger sharedMananger];
        iAppMgr.appId = [JQKPaymentConfig sharedConfig].iappPayInfo.appid;
        iAppMgr.privateKey = [JQKPaymentConfig sharedConfig].iappPayInfo.privateKey;
        iAppMgr.waresid = [JQKPaymentConfig sharedConfig].iappPayInfo.waresid.stringValue;
        iAppMgr.appUserId = [JQKUtil userId].md5 ?: @"UnregisterUser";
        iAppMgr.privateInfo = JQK_PAYMENT_RESERVE_DATA;
        iAppMgr.notifyUrl = [JQKPaymentConfig sharedConfig].iappPayInfo.notifyUrl;
        iAppMgr.publicKey = [JQKPaymentConfig sharedConfig].iappPayInfo.publicKey;
        @weakify(self);
        [iAppMgr payWithPaymentInfo:paymentInfo completionHandler:^(PAYRESULT payResult, JQKPaymentInfo *paymentInfo) {
            @strongify(self);
            if (self.completionHandler) {
                self.completionHandler(payResult, self.paymentInfo);
            }
            
        }];
        
    } else {
        success = NO;
        
        if (self.completionHandler) {
            self.completionHandler(PAYRESULT_FAIL, self.paymentInfo);
        }
    }
    
    
    
    return success ? paymentInfo : nil;
}


//- (void)onPaymentResult:(PAYRESULT)payResult withPaymentInfo:(JQKPaymentInfo *)paymentInfo {
//    if (payResult == PAYRESULT_SUCCESS && [JQKSystemConfigModel sharedModel].notificationLaunchSeq > 0) {
////        [[JQKLocalNotificationManager sharedManager] cancelAllNotifications];
//    }
//}

//- (void)checkPayment {
//    NSArray<JQKPaymentInfo *> *payingPaymentInfos = [JQKUtil payingPaymentInfos];
//    [payingPaymentInfos enumerateObjectsUsingBlock:^(JQKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        JQKPaymentType paymentType = obj.paymentType.unsignedIntegerValue;
//        if (paymentType == JQKPaymentTypeWeChatPay) {
//            if (obj.appId.length == 0 || obj.mchId.length == 0 || obj.signKey.length == 0 || obj.notifyUrl.length == 0) {
//                obj.appId = [JQKPaymentConfig sharedConfig].weixinInfo.appId;
//                obj.mchId = [JQKPaymentConfig sharedConfig].weixinInfo.mchId;
//                obj.signKey = [JQKPaymentConfig sharedConfig].weixinInfo.signKey;
//                obj.notifyUrl = [JQKPaymentConfig sharedConfig].weixinInfo.notifyUrl;
//            }
//            
//            [self.wechatPayOrderQueryRequest queryPayment:obj withCompletionHandler:^(BOOL success, NSString *trade_state, double total_fee) {
//                if ([trade_state isEqualToString:@"SUCCESS"]) {
//                    JQKPaymentViewController *paymentVC = [JQKPaymentViewController sharedPaymentVC];
//                    [paymentVC notifyPaymentResult:PAYRESULT_SUCCESS withPaymentInfo:obj];
//                }
//            }];
//        }
//    }];
//}

- (void)applicationWillEnterForeground {
//    [[SPayUtil sharedInstance] applicationWillEnterForeground];
}

#pragma mark - stringDelegate

- (void)getResult:(NSDictionary *)sender {
    PAYRESULT paymentResult = [sender[@"result"] integerValue] == 0 ? PAYRESULT_SUCCESS : PAYRESULT_FAIL;
    if (paymentResult == PAYRESULT_FAIL) {
        DLog(@"首游时空支付失败：%@", sender[@"info"]);
        //    } else if (paymentResult == PAYRESULT_SUCCESS) {
        //        UIViewController *currentController = [JQKUtil currentVisibleViewController];
        //        if ([currentController isKindOfClass:NSClassFromString(@"SZFViewController")]) {
        //            [currentController dismissViewControllerAnimated:YES completion:nil];
        //        }
    }
    
    //    [self onPaymentResult:paymentResult withPaymentInfo:self.paymentInfo];
    
    if (self.completionHandler) {
        if ([NSThread currentThread].isMainThread) {
            self.completionHandler(paymentResult, self.paymentInfo);
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.completionHandler(paymentResult, self.paymentInfo);
            });
        }
    }
}

//
//#pragma mark - IapppayAlphaKitPayRetDelegate
//
//- (void)iapppayAlphaKitPayRetCode:(IapppayAlphaKitPayRetCode)statusCode resultInfo:(NSDictionary *)resultInfo {
//    NSDictionary *paymentStatusMapping = @{@(IapppayAlphaKitPayRetSuccessCode):@(PAYRESULT_SUCCESS),
//                                           @(IapppayAlphaKitPayRetFailedCode):@(PAYRESULT_FAIL),
//                                           @(IapppayAlphaKitPayRetCancelCode):@(PAYRESULT_ABANDON)};
//    NSNumber *paymentResult = paymentStatusMapping[@(statusCode)];
//    if (!paymentResult) {
//        paymentResult = @(PAYRESULT_UNKNOWN);
//    }
//
//    if (self.completionHandler) {
//        self.completionHandler(paymentResult.integerValue, self.paymentInfo);
//    }
//}
//
//#pragma mark - WeChat delegate
//
//- (void)onReq:(BaseReq *)req {
//    
//}
//
//- (void)onResp:(BaseResp *)resp {
//    if([resp isKindOfClass:[PayResp class]]){
//        PAYRESULT payResult;
//        if (resp.errCode == WXErrCodeUserCancel) {
//            payResult = PAYRESULT_ABANDON;
//        } else if (resp.errCode == WXSuccess) {
//            payResult = PAYRESULT_SUCCESS;
//        } else {
//            payResult = PAYRESULT_FAIL;
//        }
//        [[WeChatPayManager sharedInstance] sendNotificationByResult:payResult];
//    }
//}


@end
