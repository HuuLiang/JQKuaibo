//
//  JQKPaymentManager.h
//  kuaibov
//
//  Created by Sean Yue on 16/3/11.
//  Copyright © 2016年 kuaibov. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JQKProgram,JQKChannels;

typedef void (^JQKPaymentCompletionHandler)(PAYRESULT payResult, JQKPaymentInfo *paymentInfo);

@interface JQKPaymentManager : NSObject

+ (instancetype)sharedManager;

- (void)setup;
//- (BOOL)startPaymentWithType:(JQKPaymentType)type
//                     subType:(JQKPaymentType)subType
//                       price:(NSUInteger)price
//                  forProgram:(JQKProgram *)program
//           completionHandler:(JQKPaymentCompletionHandler)handler;

- (JQKPaymentInfo *)startPaymentWithType:(JQKPaymentType)type
                                 subType:(JQKPaymentType)subType
                                   price:(NSUInteger)price
                              forProgram:(JQKProgram *)program
                         programLocation:(NSUInteger)programLocation
                               inChannel:(JQKChannels *)channel
                       completionHandler:(JQKPaymentCompletionHandler)handler;

- (void)handleOpenURL:(NSURL *)url;
- (void)checkPayment;

@end
