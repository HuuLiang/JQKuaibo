//
//  JQKProgramCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKProgramCell.h"

@interface JQKProgramCell ()
{
    UIImageView *_thumbImageView;
    UIImageView *_tagImageView;
    UILabel *_titleLabel;
    UILabel *_subtitleLabel;
}
@end

@implementation JQKProgramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //        self
        self.backgroundColor = [UIColor colorWithWhite:0.75 alpha:0.5];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        {
            [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(3);
                make.right.mas_equalTo(self.mas_right);
                make.bottom.mas_equalTo(self).mas_offset(-1.5);
                make.top.mas_equalTo(self).mas_offset(1.5);
            }];
        }
        _thumbImageView = [[UIImageView alloc] init];
        [contentView addSubview:_thumbImageView];
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.top.bottom.equalTo(contentView);
                make.width.equalTo(self).multipliedBy(0.45);
            }];
        }
        
        const CGFloat imageScale = 140./64.;
        _tagImageView = [[UIImageView alloc] init];
        [contentView addSubview:_tagImageView];
        {
            [_tagImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_thumbImageView.mas_right).offset(3);
                //                make.top.equalTo(_thumbImageView).offset(15);
                make.centerY.mas_equalTo(_thumbImageView).mas_offset(-20/667.*kScreenHeight);
                make.height.mas_equalTo(14.);
                make.width.width.equalTo(_tagImageView.mas_height).multipliedBy(imageScale);
            }];
        }
        
        _titleLabel = [[UILabel alloc] init];
        if ([JQKUtil isPaid]) {
            
            _titleLabel.numberOfLines = 2;
        }
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.];
        [contentView addSubview:_titleLabel];
        {
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_tagImageView).mas_offset(1);
                make.left.equalTo(_tagImageView.mas_right).mas_offset(2);
                make.right.equalTo(self);
            }];
        }
        
        _subtitleLabel = [[UILabel alloc] init];
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.font = [UIFont systemFontOfSize:10.5];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        [contentView addSubview:_subtitleLabel];
        {
            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel);
                make.right.equalTo(_titleLabel).offset(-3);
                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
            }];
        }
        
        //        UIView *lineView = [[UIView alloc] init];
        //        lineView.backgroundColor = [UIColor lightGrayColor];
        //        [self addSubview:lineView];
        //        {
        //        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.left.right.bottom.mas_equalTo(self);
        //            make.height.mas_equalTo(0.5);
        //            
        //        }];
        //        
        //        }
    }
    return self;
}

- (void)setTagImage:(UIImage *)tagImage {
    _tagImage = tagImage;
    _tagImageView.image = tagImage;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    //    _titleLabel.text = @"もしてくれる妹と近親 ";
}

- (void)setSubtitle:(NSString *)subtitle {
    _subtitle = subtitle;
    _subtitleLabel.text = subtitle;
//        _subtitleLabel.text = @"家政婦のようになんでもしてくれる妹と近親相姦同棲生活";
}

- (void)setThumbImageURL:(NSURL *)thumbImageURL {
    _thumbImageURL = thumbImageURL;
    
    [_thumbImageView sd_setImageWithURL:thumbImageURL];
}
@end
