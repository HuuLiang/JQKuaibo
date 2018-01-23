//
//  JQKTorrentModel.h
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>

@interface JQKTorrentProgram : NSObject
@property (nonatomic) NSString *coverImg;
@property (nonatomic) NSString *detailsCoverImg;
@property (nonatomic) NSArray *imgurls;
@property (nonatomic) NSInteger payPointType;
@property (nonatomic) NSInteger programId;
@property (nonatomic) NSString *spare;
@property (nonatomic) NSString *spareUrl;
@property (nonatomic) NSString *spec;
@property (nonatomic) NSString *specialDesc;
@property (nonatomic) NSString *tag;
@property (nonatomic) NSString *title;
@property (nonatomic) NSInteger type;
@property (nonatomic) NSString *videoUrl;
@end

@interface JQKTorrentResponse : QBURLResponse
@property (nonatomic) NSInteger type;
@property (nonatomic) NSInteger realColumnId;
@property (nonatomic) NSArray <JQKTorrentProgram *> *programList;
@end

@interface JQKTorrentModel : QBEncryptedURLRequest

- (BOOL)fetchTorrentsCompletionHandler:(QBCompletionHandler)handler;

@end
