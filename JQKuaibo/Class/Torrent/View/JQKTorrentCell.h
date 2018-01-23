//
//  JQKTorrentCell.h
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JQKTorrentCell : UITableViewCell

@property (nonatomic) NSString *titleStr;
@property (nonatomic) NSString *tagStr;
@property (nonatomic) NSArray *urlsArr;
@property (nonatomic) NSString *userNameStr;
@property (nonatomic) UIColor *tagColor;

@property (nonatomic) QBAction action;
@end
