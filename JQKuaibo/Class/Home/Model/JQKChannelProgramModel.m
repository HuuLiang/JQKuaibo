//
//  JQKChannelProgramModel.m
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "JQKChannelProgramModel.h"

@implementation JQKChannelProgramResponse

@end

@implementation JQKChannelProgramModel
RequestTimeOutInterval

+ (Class)responseClass {
    return [JQKChannelProgramResponse class];
}

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(JQKFetchChannelProgramCompletionHandler)handler {
    @weakify(self);
    NSDictionary *params = @{@"columnId":columnId,
                             @"page":@(pageNo),
                             @"pageSize":@(pageSize),
                             @"scale":[JQKUtil isPaid]?@2:@2};
    
    BOOL success = [self requestURLPath:JQK_HOME_CHANNEL_PROGRAM_URL
                         standbyURLPath:[JQKUtil getStandByUrlPathWithOriginalUrl:JQK_HOME_CHANNEL_PROGRAM_URL params:@[columnId,[JQKUtil isPaid]?@2:@2,@(pageNo),@(pageSize)]]
                             withParams:params
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        
        JQKChannels *programs;
        if (respStatus == QBURLResponseSuccess) {
            programs = (JQKChannelProgramResponse *)self.response;
            self.fetchedPrograms = programs;
        }
        
        if (handler) {
            handler(respStatus==QBURLResponseSuccess, programs);
        }
    }];
    
     return success;
}

@end
