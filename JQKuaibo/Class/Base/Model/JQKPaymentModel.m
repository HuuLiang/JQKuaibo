//
//  JQKPaymentModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/15.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKPaymentModel.h"
#import "NSDictionary+JQKSign.h"
#import "JQKPaymentInfo.h"

static const NSTimeInterval kRetryingTimeInterval = 180;

//static NSString *const kSignKey = @"qdge^%$#@(sdwHs^&";
//static NSString *const kPaymentEncryptionPassword = @"wdnxs&*@#!*qb)*&qiang";

@interface JQKPaymentModel ()
@property (nonatomic,retain) NSTimer *retryingTimer;
@end

@implementation JQKPaymentModel

+ (instancetype)sharedModel {
    static JQKPaymentModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[JQKPaymentModel alloc] init];
    });
    return _sharedModel;
}

- (NSURL *)baseURL {
    return nil;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

- (JQKURLRequestMethod)requestMethod {
    return JQKURLPostRequest;
}

+ (NSString *)signKey {
    return JQK_PAYMENT_SIGN_KEY;
}

- (NSDictionary *)encryptWithParams:(NSDictionary *)params {
    NSDictionary *signParams = @{  @"appId":JQK_REST_APP_ID,
                                   @"key":JQK_PAYMENT_SIGN_KEY,
                                   @"imsi":@"999999999999999",
                                   @"channelNo":JQK_CHANNEL_NO,
                                   @"pV":JQK_PAYMENT_PV };
    
    NSString *sign = [signParams signWithDictionary:[self class].commonParams keyOrders:[self class].keyOrdersOfCommonParams];
    NSString *encryptedDataString = [params encryptedStringWithSign:sign password:JQK_PAYMENT_ENCRYPTION_PASSWORD excludeKeys:@[@"key"]];
    return @{@"data":encryptedDataString, @"appId":JQK_REST_APP_ID};
}

- (void)startRetryingToCommitUnprocessedOrders {
    if (!self.retryingTimer) {
        @weakify(self);
        self.retryingTimer = [NSTimer bk_scheduledTimerWithTimeInterval:kRetryingTimeInterval block:^(NSTimer *timer) {
            @strongify(self);
            DLog(@"Payment: on retrying to commit unprocessed orders!");
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
                [self commitUnprocessedOrders];
            });
        } repeats:YES];
    }
}

- (void)stopRetryingToCommitUnprocessedOrders {
    [self.retryingTimer invalidate];
    self.retryingTimer = nil;
}

- (void)commitUnprocessedOrders {
    NSArray<JQKPaymentInfo *> *unprocessedPaymentInfos = [JQKUtil paidNotProcessedPaymentInfos];
    [unprocessedPaymentInfos enumerateObjectsUsingBlock:^(JQKPaymentInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self commitPaymentInfo:obj];
    }];
}

- (BOOL)commitPaymentInfo:(JQKPaymentInfo *)paymentInfo {
    return [self commitPaymentInfo:paymentInfo withCompletionHandler:nil];
}

- (BOOL)commitPaymentInfo:(JQKPaymentInfo *)paymentInfo withCompletionHandler:(JQKCompletionHandler)handler {
    NSDictionary *statusDic = @{@(PAYRESULT_SUCCESS):@(1), @(PAYRESULT_FAIL):@(0), @(PAYRESULT_ABANDON):@(2), @(PAYRESULT_UNKNOWN):@(0)};
    
    if (nil == [JQKUtil userId] || paymentInfo.orderId.length == 0) {
        return NO;
    }
    
    NSDictionary *params = @{@"uuid":[JQKUtil userId],
                             @"orderNo":paymentInfo.orderId,
                             @"imsi":@"999999999999999",
                             @"imei":@"999999999999999",
                             @"payMoney":paymentInfo.orderPrice.stringValue,
                             @"channelNo":JQK_CHANNEL_NO,
                             @"contentId":paymentInfo.contentId.stringValue ?: @"0",
                             @"contentType":paymentInfo.contentType.stringValue ?: @"0",
                             @"pluginType":paymentInfo.paymentType,
                             @"payPointType":paymentInfo.payPointType ?: @"1",
                             @"appId":JQK_REST_APP_ID,
                             @"versionNo":@([JQKUtil appVersion].integerValue),
                             @"status":statusDic[paymentInfo.paymentResult],
                             @"pV":JQK_PAYMENT_PV,
                             @"payTime":paymentInfo.paymentTime};
    
    BOOL success = [super requestURLPath:JQK_PAYMENT_COMMIT_URL
                              withParams:params
                         responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
    {
        if (respStatus == JQKURLResponseSuccess) {
            paymentInfo.paymentStatus = @(JQKPaymentStatusProcessed);
            [paymentInfo save];
        } else {
            DLog(@"Payment: fails to commit the order with orderId:%@", paymentInfo.orderId);
        }
                        
        if (handler) {
            handler(respStatus == JQKURLResponseSuccess, errorMessage);
        }
    }];
    return success;
}

- (void)processResponseObject:(id)responseObject withResponseHandler:(JQKURLResponseHandler)responseHandler {
    NSDictionary *decryptedResponse = [self decryptResponse:responseObject];
    DLog(@"Payment response : %@", decryptedResponse);
    NSNumber *respCode = decryptedResponse[@"response_code"];
    JQKURLResponseStatus status = (respCode.unsignedIntegerValue == 100) ? JQKURLResponseSuccess : JQKURLResponseFailedByInterface;
    if (responseHandler) {
        responseHandler(status, nil);
    }
}
@end
