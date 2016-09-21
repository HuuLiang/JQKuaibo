//
//  JQKHomeVideoProgramModel.m
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeVideoProgramModel.h"

@implementation JQKHomeProgramResponse

- (Class)columnListElementClass {
    return [JQKChannels class];
}
@end

@implementation JQKHomeVideoProgramModel

+ (Class)responseClass {
    return [JQKHomeProgramResponse class];
}

+ (BOOL)shouldPersistURLResponse {
    return YES;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        JQKHomeProgramResponse *resp = (JQKHomeProgramResponse *)self.response;
        _fetchedPrograms = resp.columnList;
        
        [self filterProgramTypes];
    }
    return self;
}

- (void)filterProgramTypes {
    NSArray<JQKChannels *> *videoProgramList = [self.fetchedPrograms bk_select:^BOOL(id obj)
                                     {
                                         JQKProgramType type = ((JQKChannels *)obj).type.unsignedIntegerValue;
                                         return type == JQKProgramTypeVideo;
                                     }];
    
    NSMutableArray *videoPrograms = [NSMutableArray array];
    [videoProgramList enumerateObjectsUsingBlock:^(JQKChannels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.programList.count > 0) {
            [videoPrograms addObjectsFromArray:obj.programList];
        }
    }];
    _fetchedVideoPrograms = videoPrograms;
    
    NSArray<JQKChannels *> *bannerProgramList = [self.fetchedPrograms bk_select:^BOOL(id obj)
                                                {
                                                    JQKProgramType type = ((JQKChannels *)obj).type.unsignedIntegerValue;
                                                    return type == JQKProgramTypeBanner;
                                                }];
    _bannerChannels = bannerProgramList;
    NSMutableArray *bannerPrograms = [NSMutableArray array];
    [bannerProgramList enumerateObjectsUsingBlock:^(JQKChannels * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.programList.count > 0) {
            [bannerPrograms addObjectsFromArray:obj.programList];
        }
    }];
    _fetchedBannerPrograms = bannerPrograms;
}

- (BOOL)fetchProgramsWithCompletionHandler:(JQKCompletionHandler)handler {
    @weakify(self);
    BOOL success = [self requestURLPath:JQK_HOME_VIDEO_URL
                             withParams:nil
                        responseHandler:^(QBURLResponseStatus respStatus, NSString *errorMessage)
                    {
                        @strongify(self);
                        
                        if (!self) {
                            return ;
                        }
                        
                        NSArray *programs;
                        if (respStatus == QBURLResponseSuccess) {
                            JQKHomeProgramResponse *resp = (JQKHomeProgramResponse *)self.response;
                            programs = resp.columnList;
                            self->_fetchedPrograms = programs;
                            
                            [self filterProgramTypes];
                        }
                        
                        if (handler) {
                            handler(respStatus==QBURLResponseSuccess, programs);
                        }
                    }];
    return success;
}
@end
