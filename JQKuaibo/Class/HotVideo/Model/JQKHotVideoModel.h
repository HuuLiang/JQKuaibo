//
//  JQKHotVideoModel.h
//  PhotoLibrary
//
//  Created by Sean Yue on 15/12/6.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"


typedef void (^JQKFetchVideosCompletionHandler)(BOOL success, JQKChannels *videos);

@interface JQKHotVideoModel : QBEncryptedURLRequest

@property (nonatomic,retain) JQKChannels *fetchedVideos;

- (BOOL)fetchVideosWithPageNo:(NSUInteger)pageNo
            completionHandler:(JQKFetchVideosCompletionHandler)handler;

@end
