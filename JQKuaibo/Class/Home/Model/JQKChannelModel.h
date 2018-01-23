//
//  JQKChannelsModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"

@interface JQKChannelResponse : QBURLResponse
@property (nonatomic,retain) NSMutableArray<JQKChannels *> *columnList;

@end

typedef void (^JQKFetchChannelsCompletionHandler)(BOOL success, NSArray<JQKChannels *> *channels);

@interface JQKChannelModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray <JQKChannels*>*fetchedChannels;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKFetchChannelsCompletionHandler)handler;

@end
