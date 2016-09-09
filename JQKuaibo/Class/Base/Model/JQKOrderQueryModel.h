//
//  JQKOrderQueryModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/6/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"

@interface JQKOrderQueryModel : JQKEncryptedURLRequest

- (BOOL)queryOrder:(NSString *)orderId withCompletionHandler:(JQKCompletionHandler)completionHandler;

@end
