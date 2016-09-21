//
//  JQKMovieModel.h
//  JQKuaibo
//
//  Created by Sean Yue on 16/3/8.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "QBEncryptedURLRequest.h"
#import "JQKVideos.h"

@interface JQKMovieModel : QBEncryptedURLRequest

@property (nonatomic,retain,readonly) JQKVideos *fetchedVideos;

- (BOOL)fetchMoviesInPage:(NSUInteger)page withCompletionHandler:(JQKCompletionHandler)handler;

@end
