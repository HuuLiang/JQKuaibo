//
//  JQKHomeVideoProgramModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/9.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKEncryptedURLRequest.h"
#import "JQKProgram.h"

@interface JQKHomeProgramResponse : JQKURLResponse
@property (nonatomic,retain) NSArray<JQKChannels*> *columnList;
@end

@interface JQKHomeVideoProgramModel : JQKEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray<JQKChannels *> *fetchedPrograms;
@property (nonatomic,retain,readonly) NSArray<JQKProgram *> *fetchedBannerPrograms;
@property (nonatomic,retain,readonly) NSArray<JQKProgram *> *fetchedVideoPrograms;

@property (nonatomic,retain,readonly) NSArray <JQKChannels*> *bannerChannels;

- (BOOL)fetchProgramsWithCompletionHandler:(JQKCompletionHandler)handler;

@end
