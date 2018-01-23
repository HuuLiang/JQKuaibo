//
//  JQKTableViewCell.h
//  JQKVideo
//
//  Created by Liang on 16/6/22.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JQKTableViewCell : UITableViewCell
@property (nonatomic,retain,readonly) UIImageView *iconImageView;
@property (nonatomic,retain,readonly) UILabel *titleLabel;
@property (nonatomic,retain,readonly) UILabel *subtitleLabel;
@property (nonatomic,retain,readonly) UIImageView *backgroundImageView;
@property (nonatomic)NSURL *imageUrl;

- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title;
- (instancetype)initWithImage:(UIImage *)image title:(NSString *)title subtitle:(NSString *)subtitle;

@end
