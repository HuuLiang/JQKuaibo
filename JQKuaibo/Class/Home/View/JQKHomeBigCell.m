//
//  JQKHomeBigCell.m
//  JQKuaibo
//
//  Created by ylz on 16/8/4.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKHomeBigCell.h"

@interface JQKHomeBigCell ()
{
    UIImageView *_thumbImageView;
    UIImageView *_enterChannel;
}
//@property (nonatomic,retain) UIImageView *thumbImageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,retain) UIView *footerView;
@property (nonatomic,retain) UILabel *freeVideoLabel;

@end

@implementation JQKHomeBigCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        _thumbImageView.layer.masksToBounds = YES;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        
        UIView *coverView = [[UIView alloc] init];
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        [_thumbImageView addSubview:coverView];
        
        UIImageView *enterChannel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterchannelbig"]];
        [coverView addSubview:enterChannel];
        _enterChannel = enterChannel;
        
        UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow"]];
        [coverView addSubview:leftArrow];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [coverView addSubview:rightArrow];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(17.)];//[UIFont fontWithName:@"PingFangSC-Regular" size:kWidth(18.)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [coverView addSubview:_titleLabel];
        
        {
            [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            [coverView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(_thumbImageView);
            }];
            
            [enterChannel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(coverView);
                make.bottom.mas_equalTo(coverView).mas_offset(-kWidth(10.));
                make.size.mas_equalTo(CGSizeMake(kWidth(88.), kWidth(23.)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(enterChannel.mas_top);
                make.centerX.mas_equalTo(coverView);
                make.size.mas_equalTo(CGSizeMake(kWidth(70.), kWidth(24.)));
            }];
            
            [leftArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(coverView).mas_offset(kWidth(15.5));
                make.right.mas_equalTo(_titleLabel.mas_left).mas_offset(-kWidth(3.));
                make.height.mas_equalTo(kWidth(3.));
                make.centerY.mas_equalTo(_titleLabel);
            }];
            
            [rightArrow mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(_titleLabel.mas_right).mas_offset(kWidth(3.));
                make.right.mas_equalTo(coverView).mas_offset(-kWidth(15.5));
                make.height.mas_equalTo(kWidth(3.));
                make.centerY.mas_equalTo(_titleLabel);
            }];
            
        }
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
    
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}

@end
