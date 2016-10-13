//
//  JQKTorrentModel.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTorrentModel.h"

@implementation JQKTorrentModel

+ (Class)responseClass {
    return nil;
}

- (BOOL)fetchTorrentsCompletionHandler:(QBCompletionHandler)handler {
    BOOL sucess = [self requestURLPath:nil
                            withParams:nil
                       responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
                           if (respStatus == QBURLResponseSuccess) {
                               
                           }
                           if (handler) {
                               handler(respStatus == QBURLResponseSuccess,nil);
                           }
    }];
    return sucess;
}

@end
