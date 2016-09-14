//
//  HTPayManager.h
//  JFVideo
//
//  Created by Liang on 16/9/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTPayManager : NSObject

+ (instancetype)sharedManager;

//@property (nonatomic) NSString *
- (void)registerHaitunSDKWithApplication:(UIApplication *)application Options:(NSDictionary *)Options;

- (void)payWithPaymentInfo:(JQKPaymentInfo *)paymentInfo completionHandler:(JQKPaymentCompletionHandler)completionHandler;

@property (nonatomic) BOOL isAutoForeground;

- (void)searchOrderState;

@end
