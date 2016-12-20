//
//  JQKVersionUpdateModel.h
//  JQKuaibo
//
//  Created by ylz on 2016/12/20.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface JQKVersionUpdateInfo : QBURLResponse

@property (nonatomic) NSString *versionNo;
@property (nonatomic) NSString *linkUrl;
@property (nonatomic) NSNumber *isForceToUpdate;
@property (nonatomic) NSNumber *up;
@end

@interface JQKVersionUpdateModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) JQKVersionUpdateInfo *fetchedVersionInfo;
+ (instancetype)sharedModel;
- (BOOL)fetchLatestVersionWithCompletionHandler:(JQKCompletionHandler)completionHandler;


@end
