//
//  JQKSystemConfigModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/10.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "JQKSystemConfig.h"

@interface JQKSystemConfigResponse : QBURLResponse
@property (nonatomic,retain) NSArray<JQKSystemConfig> *confis;
@end

typedef void (^JQKFetchSystemConfigCompletionHandler)(BOOL success);

@interface JQKSystemConfigModel : QBEncryptedURLRequest

@property (nonatomic) NSInteger payAmount;
@property (nonatomic) NSString *channelTopImage;
@property (nonatomic) NSString *spreadTopImage;
@property (nonatomic) NSString *spreadURL;

@property (nonatomic) NSString *startupInstall;
@property (nonatomic) NSString *startupPrompt;

@property (nonatomic) NSString *spreadLeftImage;
@property (nonatomic) NSString *spreadLeftUrl;
@property (nonatomic) NSString *spreadRightImage;
@property (nonatomic) NSString *spreadRightUrl;

@property (nonatomic,readonly) BOOL loaded;
@property (nonatomic) NSUInteger statsTimeInterval;

@property (nonatomic) NSString *contact;
@property (nonatomic) NSInteger notificationLaunchSeq;

@property (nonatomic) NSString *ktVipImage;
@property (nonatomic) NSString *vipImage;

@property (nonatomic) NSString  *contactScheme;
@property (nonatomic) NSString  *contactName;
@property (nonatomic) NSString *imageToken;
@property (nonatomic) NSInteger timeOutInterval;

@property (nonatomic) NSString *videoSignKey;
@property (nonatomic) NSTimeInterval expireTime;

+ (instancetype)sharedModel;

- (BOOL)fetchSystemConfigWithCompletionHandler:(JQKFetchSystemConfigCompletionHandler)handler;

@end
