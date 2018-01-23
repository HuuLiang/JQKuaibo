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
RequestTimeOutInterval

+ (Class)responseClass {
    return [JQKAppSpreadResponse class];
}

- (BOOL)fetchAppSpreadWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL ret = [self requestURLPath:JQK_APP_SPREAD_LIST_URL
                     standbyURLPath:[JQKUtil getStandByUrlPathWithOriginalUrl:JQK_APP_SPREAD_LIST_URL params:nil]//JQK_STANDBY_APP_SPREAD_LIST_URL
                         withParams:nil
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                {
                    @strongify(self);
                    NSArray *fetchedSpreads;
                    if (respStatus == QBURLResponseSuccess) {
                        JQKAppSpreadResponse *resp = self.response;
                        _appSpreadResponse = resp;
                        fetchedSpreads = _appSpreadResponse.programList;
//                        fetchedSpreads = _fetchedSpreads;
                    }
                    
                    if (handler) {
                        handler(respStatus==QBURLResponseSuccess, fetchedSpreads);
                    }
                }];
    return ret;
}



@end
