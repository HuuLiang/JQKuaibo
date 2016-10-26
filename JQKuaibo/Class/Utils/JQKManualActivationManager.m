//
//  JQKManualActivationManager.m
//  JQKuaibo
//
//  Created by ylz on 2016/10/26.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKManualActivationManager.h"
#import "JQKPaymentViewController.h"

@implementation JQKManualActivationManager

+ (instancetype)shareManager{
    static JQKManualActivationManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (void)doActivate {
    if ([JQKUtil isPaid]) {
        [UIAlertView bk_showAlertViewWithTitle:@"您已经购买了全部VIP，无需再激活！" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        return ;
    }
    NSArray<JQKPaymentInfo *> *paymentInfos = [JQKUtil allUnsuccessfulPaymentInfos];
   
    [[UIApplication sharedApplication].keyWindow beginLoading];
    [[QBPaymentManager sharedManager] activatePaymentInfos:paymentInfos withCompletionHandler:^(BOOL success, id obj) {
        [[UIApplication sharedApplication].keyWindow endLoading];
        
        if (success) {
            [UIAlertView bk_showAlertViewWithTitle:@"激活成功" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
            [[JQKPaymentViewController sharedPaymentVC] notifyPaymentResult:QBPayResultSuccess withPaymentInfo:obj];
        } else {
            [UIAlertView bk_showAlertViewWithTitle:@"未找到支付成功的订单" message:nil cancelButtonTitle:@"确定" otherButtonTitles:nil handler:nil];
        }
    }];

    
}

@end
