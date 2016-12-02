//
//  JQKHotVideoModel.m
//  PhotoLibrary
//
//  Created by Sean Yue on 15/12/6.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHotVideoModel.h"

@implementation JQKHotVideoModel

+ (Class)responseClass {
    return [JQKVideos class];
}

- (BOOL)fetchVideosWithPageNo:(NSUInteger)pageNo
            completionHandler:(JQKFetchVideosCompletionHandler)handler
{
    @weakify(self);
    
    BOOL ret = [self requestURLPath:JQK_HOT_VIDEO_URL
                     standbyURLPath:[JQKUtil getStandByUrlPathWithOriginalUrl:JQK_HOT_VIDEO_URL params:@{@"page":@(pageNo)}] withParams:@{@"page":@(pageNo)}
                    responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        
        JQKVideos *videos;
        if (respStatus == QBURLResponseSuccess) {
            videos = self.response;
            self.fetchedVideos = videos;
        }
        
        if (handler) {
            handler(respStatus == QBURLResponseSuccess, videos);
        }

    }];
    
    return ret;
}

@end
