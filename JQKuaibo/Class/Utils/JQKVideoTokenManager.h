//
//  JQKVideoTokenManager.h
//  JQKuaibo
//
//  Created by Sean Yue on 2016/9/23.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^JQKVideoTokenCompletionHandler)(BOOL success, NSString *token, NSString *userId);

@interface JQKVideoTokenManager : NSObject

+ (instancetype)sharedManager;

- (void)requestTokenWithCompletionHandler:(JQKVideoTokenCompletionHandler)completionHandler;
- (NSString *)videoLinkWithOriginalLink:(NSString *)originalLink;
- (void)setValue:(NSString *)value forVideoHttpHeader:(NSString *)field;

@end
