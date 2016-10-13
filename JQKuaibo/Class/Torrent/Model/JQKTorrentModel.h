//
//  JQKTorrentModel.h
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <QBEncryptedURLRequest.h>



@interface JQKTorrentModel : QBEncryptedURLRequest

- (BOOL)fetchTorrentsCompletionHandler:(QBCompletionHandler)handler;

@end
