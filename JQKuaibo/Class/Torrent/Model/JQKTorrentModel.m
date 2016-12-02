//
//  JQKTorrentModel.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTorrentModel.h"

@implementation JQKTorrentProgram

- (Class)imgurlsElementClass {
    return [JQKTorrentProgram class];
}

@end


@implementation JQKTorrentResponse

- (Class)programListElementClass {
    return [JQKTorrentProgram class];
}

@end


@implementation JQKTorrentModel

+ (Class)responseClass {
    return [JQKTorrentResponse class];
}

- (BOOL)fetchTorrentsCompletionHandler:(QBCompletionHandler)handler {
    
    BOOL success = [self requestURLPath:JQK_TORRENT_URL
                         standbyURLPath:[JQKUtil getStandByUrlPathWithOriginalUrl:JQK_TORRENT_URL params:nil]
                        withParams:nil
                responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                    
        JQKTorrentResponse *resp = nil;
        if (respStatus == QBURLResponseSuccess) {
            resp = self.response;
        }
        if (handler) {
            handler(respStatus == QBURLResponseSuccess,resp);
        }
    }];
    
    return success;
}

@end
