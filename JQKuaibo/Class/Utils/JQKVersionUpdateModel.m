//
//  JQKVersionUpdateModel.m
//  JQKuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKVersionUpdateModel.h"

@implementation JQKVersionUpdateInfo

@end

@implementation JQKVersionUpdateModel

+ (instancetype)sharedModel {
    static JQKVersionUpdateModel *_sharedModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedModel = [[self alloc] init];
    });
    return _sharedModel;
}

- (BOOL)shouldPostErrorNotification {
    return NO;
}

+ (Class)responseClass {
    return [JQKVersionUpdateInfo class];
}


- (BOOL)fetchLatestVersionWithCompletionHandler:(JQKCompletionHandler)completionHandler {
    @weakify(self);
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
    NSString *bundleId = [NSBundle mainBundle].bundleIdentifier;
    BOOL rect = [self requestURLPath:JQK_VERSION_UPDATE_URL withParams:@{@"versionNo":currentVersion, @"packageId":bundleId} responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage) {
        @strongify(self);
        if (!self) {
            return ;
        }
        
        JQKVersionUpdateInfo *versionInfo;
        if (respStatus == QBURLResponseSuccess) {
            versionInfo = self.response;
            self->_fetchedVersionInfo = versionInfo;
        }
        
        SafelyCallBlock(completionHandler, respStatus==QBURLResponseSuccess, versionInfo);
    }];
    return rect;
}

@end
