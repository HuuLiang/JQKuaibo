//
//  JQKChannelProgramModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/6.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
//#import "JQKChannelProgram.h"

@interface JQKChannelProgramResponse : JQKChannels

@end

typedef void (^JQKFetchChannelProgramCompletionHandler)(BOOL success, JQKChannels *programs);

@interface JQKChannelProgramModel : QBEncryptedURLRequest

@property (nonatomic,retain) JQKChannels *fetchedPrograms;

- (BOOL)fetchProgramsWithColumnId:(NSNumber *)columnId
                           pageNo:(NSUInteger)pageNo
                         pageSize:(NSUInteger)pageSize
                completionHandler:(JQKFetchChannelProgramCompletionHandler)handler;

@end
