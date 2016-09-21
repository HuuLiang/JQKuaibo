//
//  JQKChannelModel.h
//  kuaibov
//
//  Created by Sean Yue on 15/9/3.
//  Copyright (c) 2015年 kuaibov. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "JQKChannel.h"

@interface JQKChannelResponse : QBURLResponse
@property (nonatomic,retain) NSMutableArray<JQKChannel> *columnList;

@end

typedef void (^JQKFetchChannelsCompletionHandler)(BOOL success, NSArray<JQKChannel *> *channels);

@interface JQKChannelModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) NSArray <JQKChannel*>*fetchedChannels;

- (BOOL)fetchChannelsWithCompletionHandler:(JQKFetchChannelsCompletionHandler)handler;

@end
