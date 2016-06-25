//
//  JQKSpreadModel.m
//  JQKuaibo
//
//  Created by ylz on 16/5/31.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKSpreadModel.h"

@implementation JQKAppProgram


@end


@implementation JQKAppSpreadResponse

- (Class)programListElementClass {
    return [JQKAppProgram class];
}
@end

@implementation JQKSpreadModel
+ (Class)responseClass {
    return [JQKAppSpreadResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_APP_SPREAD_LIST_URL
                     standbyURLPath:JQK_STANDBY_APP_SPREAD_LIST_URL
                         withParams:nil
                    responseHandler:^(JQKURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == JQKURLResponseSuccess) {
                        JQKAppSpreadResponse *resp = self.response;
                        _appSpreadResponse = resp;
                        fetchedSpreads = _appSpreadResponse.programList;
//                        fetchedSpreads = _fetchedSpreads;
                    }
                    
                    if (handler) {
                        handler(respStatus==JQKURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}



@end
