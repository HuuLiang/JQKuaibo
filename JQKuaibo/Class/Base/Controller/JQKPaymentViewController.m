//
//  JQKPaymentViewController.m
//  kuaibov
//
//  Created by Sean Yue on 15/12/9.
//  Copyright © 2015年 kuaibov. All rights reserved.
//

#import "JQKPaymentViewController.h"
#import "JQKPaymentPopView.h"
#import "JQKSystemConfigModel.h"
#import <objc/runtime.h>
#import "JQKProgram.h"
//#import "WeChatPayManager.h"
//#import "JQKPaymentInfo.h"
//#import "JQKPaymentConfig.h"

@interface JQKPaymentViewController ()
@property (nonatomic,retain) JQKPaymentPopView *popView;
@property (nonatomic) NSNumber *payAmount;

@property (nonatomic) NSUInteger programLocationToPayFor;
@property (nonatomic,retain) JQKChannels *channelToPayFor;

@property (nonatomic,retain) JQKProgram *programToPayFor;
@property (nonatomic,retain) JQKPaymentInfo *paymentInfo;

@property (nonatomic,readonly,retain) NSDictionary *paymentTypeMap;
@property (nonatomic,copy) dispatch_block_t completionHandler;
@end

@implementation JQKPaymentViewController
@synthesize paymentTypeMap = _paymentTypeMap;

+ (instancetype)sharedPaymentVC {
    static JQKPaymentViewController *_sharedPaymentVC;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPaymentVC = [[JQKPaymentViewController alloc] init];
    });
    return _sharedPaymentVC;
}

- (JQKPaymentPopView *)popView {
    if (_popView) {
        return _popView;
    }
    
    @weakify(self);
//    void (^Pay)(QBPayType type, QBPaySubType subType) = ^(QBPayType type, QBPaySubType subType)
//    {
//        @strongify(self);
//        if (!self.payAmount) {
//            [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
//            return ;
//        }
////        
////        [self payForProgram:self.programToPayFor
////                      price:self.payAmount.doubleValue*100
////                paymentType:type
////             paymentSubType:subType];
//        
////        [self payForProgram:self.programToPayFor withPrice:self.payAmount.doubleValue *100 PayType:];
//        
//        [self hidePayment];
//    };
//    
    void (^Pay)(QBOrderPayType type) = ^(QBOrderPayType type){
        @strongify(self);
        if (!self.payAmount) {
                        [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
                        return ;
                    }
        [self payForProgram:self.programToPayFor withPrice:self.payAmount.doubleValue *100 PayType:type];
        [self hidePayment];
    };
    
    _popView = [[JQKPaymentPopView alloc] init];
    
    _popView.headerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payment_background" ofType:@"jpg"]];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    
    
    
    //    JQKPaymentType cardType = [[JQKPaymentManager sharedManager] cardPayPaymentType];
    
    
//    QBPayType wechatPaymentType = [[QBPaymentManager sharedManager] wechatPaymentType];
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeWeChatPay]) {
        //微信支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon-1"] title:@"微信支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#05c30b"] action:^(id sender) {
            Pay(QBOrderPayTypeWeChatPay);
        }];
    }
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeAlipay]) {
        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon-1"] title:@"支付宝" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#02a0e9"] action:^(id sender) {
            Pay (QBOrderPayTypeAlipay);
        }];
    }
    
    if ([[QBPaymentManager sharedManager] isOrderPayTypeAvailable:QBOrderPayTypeQQPay]) {
        [_popView addPaymentWithImage:[UIImage imageNamed:@"qq_icon"] title:@"QQ钱包" subtitle:nil backgroundColor:[UIColor redColor] action:^(id sender) {
            Pay (QBOrderPayTypeQQPay);
        }];

    }
    

    
    _popView.closeAction = ^(id sender){
        @strongify(self);
        [self hidePayment];
        [[JQKStatsManager sharedManager] statsPayWithOrderNo:nil
                                                   payAction:JQKStatsPayActionClose
                                                   payResult:PAYRESULT_UNKNOWN
                                                  forProgram:self.programToPayFor
                                             programLocation:self.programLocationToPayFor
                                                   inChannel:self.channelToPayFor
                                                 andTabIndex:[JQKUtil currentTabPageIndex]
                                                 subTabIndex:[JQKUtil currentSubTabPageIndex]];
        
    };
    return _popView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:self.popView];
    {
        [self.popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            
            make.centerX.equalTo(self.view);
            const CGFloat width = MAX(kScreenWidth * 0.85, 275);
            const CGFloat height = [self.popView viewHeightRelativeToWidth:width];
            make.size.mas_equalTo(CGSizeMake(width, height));
            make.centerY.equalTo(self.view).offset(-height/20);
        }];
    }
}

- (void)popupPaymentInView:(UIView *)view
                forProgram:(JQKProgram *)program
           programLocation:(NSUInteger)programLocation
                 inChannel:(JQKChannels *)channel
     withCompletionHandler:(void (^)(void))completionHandler {
    self.completionHandler = completionHandler;
    
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    
    self.payAmount = nil;
    self.programToPayFor = program;
    self.programLocationToPayFor = programLocation;
    self.channelToPayFor = channel;
    self.view.frame = view.bounds;
    self.view.alpha = 0;
    
    if (view == [UIApplication sharedApplication].keyWindow) {
        [view insertSubview:self.view belowSubview:[JQKHudManager manager].hudView];
    } else {
        [view addSubview:self.view];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 1.0;
    }];
    
    [self fetchPayAmount];
}

- (void)fetchPayAmount {
    @weakify(self);
    JQKSystemConfigModel *systemConfigModel = [JQKSystemConfigModel sharedModel];
    [systemConfigModel fetchSystemConfigWithCompletionHandler:^(BOOL success) {
        @strongify(self);
        if (success) {
            self.payAmount = @(systemConfigModel.payAmount);
        }else {
            self.payAmount = @(systemConfigModel.payAmount);
        }
    }];
}

- (void)setPayAmount:(NSNumber *)payAmount {
    //#ifdef DEBUG
    //    payAmount = @(0.01);
    //#endif
    _payAmount = payAmount;
    self.popView.showPrice = payAmount;
}

- (void)hidePayment {
    [UIView animateWithDuration:0.25 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.completionHandler) {
            self.completionHandler();
            self.completionHandler = nil;
        }
        self.programToPayFor = nil;
        self.programLocationToPayFor = 0;
        self.channelToPayFor = nil;
    }];
}


- (void)payForProgram:(JQKProgram *)program withPrice:(double)price PayType:(QBOrderPayType)payType {
    
    @weakify(self);
    QBPayPointType payPointType = JQKPayPointTypeVIP;
    if (price == 0) {
        [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
        return ;
    }
    
//#ifdef DEBUG
//    if (paymentType == QBPayTypeIAppPay || paymentType == QBPayTypeHTPay || paymentType == QBPayTypeWeiYingPay) {
//        price = 200;
//    } else if (paymentType == QBPayTypeMingPay || paymentType == QBPayTypeDXTXPay) {
//        price = 100;
//    } else if (paymentType == QBPayTypeVIAPay) {
//        price = 1000;
//    } else {
//        price = payPointType ==  1;
//    }
//    
//#endif
//    price = 200;

    QBOrderInfo *orderInfo = [[QBOrderInfo alloc] init];
    
    NSString *channelNo = JQK_CHANNEL_NO;
    if (channelNo.length > 14) {
        channelNo = [channelNo substringFromIndex:channelNo.length-14];
    }
    
    channelNo = [channelNo stringByReplacingOccurrencesOfString:@"-" withString:@"_"];
    
    NSString *uuid = [[NSUUID UUID].UUIDString.md5 substringWithRange:NSMakeRange(8, 16)];
    NSString *orderNo = [NSString stringWithFormat:@"%@_%@", channelNo, uuid];
    orderInfo.orderId = orderNo;
    
    orderInfo.orderPrice = price;
    
    orderInfo.orderDescription = [JQKSystemConfigModel sharedModel].contactName ? : @"VIP";
    orderInfo.payType = payType;
    orderInfo.reservedData = JQK_PAYMENT_RESERVE_DATA;
    orderInfo.createTime = [JQKUtil currentTimeString];
    orderInfo.payPointType = payPointType;
    orderInfo.userId = [JQKUtil userId];
    
    QBContentInfo *contenInfo = [[QBContentInfo alloc] init];
    contenInfo.contentId = program.programId;
    contenInfo.contentType = program.type;
    contenInfo.contentLocation = @(self.programLocationToPayFor);
    contenInfo.columnId = self.channelToPayFor.columnId;
    contenInfo.columnType = self.channelToPayFor.type;
    
    [[QBPaymentManager sharedManager] startPaymentWithOrderInfo:orderInfo
                                                    contentInfo:contenInfo
                                                    beginAction:^(QBPaymentInfo * paymentInfo) {
                                                        if (paymentInfo) {
                                                            
                            [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:JQKStatsPayActionGoToPay andTabIndex:[JQKUtil currentTabPageIndex] subTabIndex:[JQKUtil currentSubTabPageIndex]];
                                                        }
                                                        
        
                           } completionHandler:^(QBPayResult payResult, QBPaymentInfo *paymentInfo) {
                               @strongify(self);
                               [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                        }];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(QBPayResult)result withPaymentInfo:(QBPaymentInfo *)paymentInfo {
    
    if (result == QBPayResultSuccess) {
        [self hidePayment];
        [[JQKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:nil];
    } else if (result == QBPayResultCancelled) {
        [[JQKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[JQKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                                forPayAction:JQKStatsPayActionPayBack
                                                 andTabIndex:[JQKUtil currentTabPageIndex]
                                                 subTabIndex:[JQKUtil currentSubTabPageIndex]];
}

@end
