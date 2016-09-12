//
//  DXTXPayManager.h
//  YYKuaibo
//
//  Created by Sean Yue on 16/9/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DXTXPayManager : NSObject

@property (nonatomic) NSString *appKey;
@property (nonatomic) NSString *notifyUrl;
@property (nonatomic) NSNumber *waresid;
@property (nonatomic) NSString *urlScheme;

+ (instancetype)sharedManager;

- (void)payWithPaymentInfo:(JQKPaymentInfo *)paymentInfo
         completionHandler:(JQKPaymentCompletionHandler)completionHandler;
- (void)handleOpenURL:(NSURL *)url;
@end
