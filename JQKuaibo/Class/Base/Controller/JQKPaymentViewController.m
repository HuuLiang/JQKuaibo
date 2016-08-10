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
#import "JQKPaymentModel.h"
#import <objc/runtime.h>
#import "JQKProgram.h"
#import "WeChatPayManager.h"
#import "JQKPaymentInfo.h"
#import "JQKPaymentConfig.h"

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
    void (^Pay)(JQKPaymentType type, JQKSubPayType subType) = ^(JQKPaymentType type, JQKSubPayType subType)
    {
        @strongify(self);
        if (!self.payAmount) {
            [[JQKHudManager manager] showHudWithText:@"无法获取价格信息,请检查网络配置！"];
            return ;
        }
        
        [self payForProgram:self.programToPayFor
                      price:self.payAmount.doubleValue
                paymentType:type
             paymentSubType:subType];
        [self hidePayment];
    };
    
    _popView = [[JQKPaymentPopView alloc] init];
    
    _popView.headerImage = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"payment_background" ofType:@"jpg"]];
    _popView.footerImage = [UIImage imageNamed:@"payment_footer"];
    
    
    
//    JQKPaymentType cardType = [[JQKPaymentManager sharedManager] cardPayPaymentType];
    
    
    JQKPaymentType wechatPaymentType = [[JQKPaymentManager sharedManager] wechatPaymentType];
    if (wechatPaymentType != JQKPaymentTypeNone) {
        //微信支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon-1"] title:@"微信支付" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#05c30b"] action:^(id sender) {
            Pay(wechatPaymentType, JQKSubPayTypeWeChat);
        }];
    }
    JQKPaymentType aliPaymentType = [[JQKPaymentManager sharedManager] alipayPaymentType];
    if (aliPaymentType != JQKPaymentTypeNone) {
        //支付宝支付
        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon-1"] title:@"支付宝" subtitle:nil backgroundColor:[UIColor colorWithHexString:@"#02a0e9"] action:^(id sender) {
            Pay(aliPaymentType, JQKSubPayTypeAlipay);
        }];
        
    }
    JQKPaymentType qqPaymentType = [[JQKPaymentManager sharedManager] qqPaymentType];
    if (qqPaymentType != JQKPaymentTypeNone) {
        [_popView addPaymentWithImage:[UIImage imageNamed:@"qq_icon"] title:@"QQ钱包" subtitle:nil backgroundColor:[UIColor redColor] action:^(id sender) {
            Pay(qqPaymentType, JQKSubPayTypeQQ);
        }];
    }
    
//    if (cardType != JQKPaymentTypeNone) {
//        
//        [_popView addPaymentWithImage:[UIImage imageNamed:@"card_pay_icon"] title:@"购卡支付" subtitle:@"支持微信和支付宝" backgroundColor:[UIColor darkPink] action:^(id obj) {
//            Pay(cardType,JQKSubPayTypeUnknown);
//        }];
//        
//    }
    
    
    //    if (([JQKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & JQKIAppPayTypeWeChat)
    //        || [JQKPaymentConfig sharedConfig].weixinInfo) {
    //        BOOL useBuildInWeChatPay = [JQKPaymentConfig sharedConfig].weixinInfo != nil;
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"wechat_icon"] title:@"微信客户端支付" available:YES action:^(id sender) {
    //            Pay(useBuildInWeChatPay?JQKPaymentTypeWeChatPay:JQKPaymentTypeIAppPay, useBuildInWeChatPay?JQKPaymentTypeNone:JQKPaymentTypeWeChatPay);
    //        }];
    //    }
    //    
    //    if (([JQKPaymentConfig sharedConfig].iappPayInfo.supportPayTypes.unsignedIntegerValue & JQKIAppPayTypeAlipay)
    //        || [JQKPaymentConfig sharedConfig].alipayInfo) {
    //        BOOL useBuildInAlipay = [JQKPaymentConfig sharedConfig].alipayInfo != nil;
    //        [_popView addPaymentWithImage:[UIImage imageNamed:@"alipay_icon"] title:@"支付宝支付" available:YES action:^(id sender) {
    //            Pay(useBuildInAlipay?JQKPaymentTypeAlipay:JQKPaymentTypeIAppPay, useBuildInAlipay?JQKPaymentTypeNone:JQKPaymentTypeAlipay);
    //        }];
    //    }
    
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

- (void)payForProgram:(JQKProgram *)program
                price:(double)price
          paymentType:(JQKPaymentType)paymentType
       paymentSubType:(JQKSubPayType)paymentSubType
{
    @weakify(self);
    JQKPaymentInfo *paymentInfo = [[JQKPaymentManager sharedManager] startPaymentWithType:paymentType
                                                                                  subType:paymentSubType
                                                                                    price:price*100
                                                                               forProgram:program
                                                                          programLocation:_programLocationToPayFor
                                                                                inChannel:_channelToPayFor
                                   
                                                                        completionHandler:^(PAYRESULT payResult, JQKPaymentInfo *paymentInfo) {
                                                                            @strongify(self);
                                                                            [self notifyPaymentResult:payResult withPaymentInfo:paymentInfo];
                                                                        }];
    if (paymentInfo) {
        [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo forPayAction:JQKStatsPayActionGoToPay andTabIndex:[JQKUtil currentTabPageIndex] subTabIndex:[JQKUtil currentSubTabPageIndex]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)notifyPaymentResult:(PAYRESULT)result withPaymentInfo:(JQKPaymentInfo *)paymentInfo {
    if (result == PAYRESULT_SUCCESS && [JQKUtil successfulPaymentInfo]) {
        return ;
    }
    
    NSDateFormatter *dateFormmater = [[NSDateFormatter alloc] init];
    [dateFormmater setDateFormat:kDefaultDateFormat];
    
    paymentInfo.paymentResult = @(result);
    paymentInfo.paymentStatus = @(JQKPaymentStatusNotProcessed);
    paymentInfo.paymentTime = [dateFormmater stringFromDate:[NSDate date]];
    [paymentInfo save];
    
    if (result == PAYRESULT_SUCCESS) {
        [self hidePayment];
        [[JQKHudManager manager] showHudWithText:@"支付成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPaidNotificationName object:nil];
    } else if (result == PAYRESULT_ABANDON) {
        [[JQKHudManager manager] showHudWithText:@"支付取消"];
    } else {
        [[JQKHudManager manager] showHudWithText:@"支付失败"];
    }
    
    [[JQKPaymentModel sharedModel] commitPaymentInfo:paymentInfo];
    
    [[JQKStatsManager sharedManager] statsPayWithPaymentInfo:paymentInfo
                                                forPayAction:JQKStatsPayActionPayBack
                                                 andTabIndex:[JQKUtil currentTabPageIndex]
                                                 subTabIndex:[JQKUtil currentSubTabPageIndex]];
}

@end
