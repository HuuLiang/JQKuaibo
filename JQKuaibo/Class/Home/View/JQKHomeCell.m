//
//  JQKHomeCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/25.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHomeCell.h"


@interface JQKHomeCell ()
{
    UIImageView *_thumbImageView;
    UIImageView *_enterChannel;
    UIImageView *_freeImageView;
}
//@property (nonatomic,retain) UIImageView *thumbImageView;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *subtitleLabel;
@property (nonatomic,retain) UIView *footerView;
@property (nonatomic,retain) UILabel *freeVideoLabel;
@property (nonatomic,weak) UIView *coverView;

@end

@implementation JQKHomeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.clipsToBounds = YES;
        [self addSubview:_thumbImageView];
        
        UIView *coverView = [[UIView alloc] init];
        _coverView = coverView;
        coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.45];
        [_thumbImageView addSubview:coverView];
        
        UIImageView *enterChannel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"enterchannel"]];
        [coverView addSubview:enterChannel];
        _enterChannel = enterChannel;
        
        UIImageView *leftArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"leftArrow"]];
        [coverView addSubview:leftArrow];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rightArrow"]];
        [coverView addSubview:rightArrow];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(14.)];//[UIFont fontWithName:@"PingFangSC-Regular" size:kWidth(14.)];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [coverView addSubview:_titleLabel];
        
        _freeImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"freevideo"]];
        
        [coverView addSubview:_freeImageView];
        
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
                make.size.mas_equalTo(CGSizeMake(kWidth(69.), kWidth(18.)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(enterChannel.mas_top);
                make.centerX.mas_equalTo(coverView);
                make.size.mas_equalTo(CGSizeMake(kWidth(56.), kWidth(20.)));
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
            
            [_freeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(coverView);
                make.top.mas_equalTo(coverView).mas_offset(kWidth(5.));
                make.size.mas_equalTo(CGSizeMake(kWidth(40.), kWidth(18.)));
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

- (void)setFreeVideo:(BOOL)freeVideo {
    _freeVideo = freeVideo;
    if (freeVideo) {
        for (UIView *view in _coverView.subviews) {
            view.hidden = YES;
        }
        _coverView.subviews.lastObject.hidden = NO;
    }else {
        for (UIView *view in _coverView.subviews) {
            view.hidden = NO;
        }
        _coverView.subviews.lastObject.hidden = YES;
        
    }
}

//
//- (UIImageView *)thumbImageView {
//    if (_thumbImageView) {
//        return _thumbImageView;
//    }
//    
//    _thumbImageView = [[UIImageView alloc] init];
//    [self addSubview:_thumbImageView];
//    {
//        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];
//    }
//    return _thumbImageView;
//}

//- (UIView *)footerView {
//    if (_footerView) {
//        return _footerView;
//    }
//    
//    _footerView = [[UIView alloc] init];
//    _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//    [self addSubview:_footerView];
//    {
//        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self);
//            make.height.mas_equalTo(25);
//        }];
//    }
//    return _footerView;
//}
//
//- (UILabel *)titleLabel {
//    if (_titleLabel) {
//        return _titleLabel;
//    }
//    
//    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.font = [UIFont systemFontOfSize:14.];
//    [self.footerView addSubview:_titleLabel];
//    {
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.footerView);
//            make.left.equalTo(self.footerView).offset(5);
//            make.right.equalTo(self.subtitleLabel.mas_left).offset(-5);
//        }];
//    }
//    return _titleLabel;
//}
//
//- (UILabel *)freeVideoLabel {
//    if (_freeVideoLabel) {
//        return _freeVideoLabel;
//    }
//    _freeVideoLabel = [[UILabel alloc] init];
//    _freeVideoLabel.textColor = [UIColor whiteColor];
//    _freeVideoLabel.backgroundColor = [UIColor colorWithHexString:@"#FD2469"];
//    _freeVideoLabel.font = [UIFont systemFontOfSize:12.];
//    _freeVideoLabel.textAlignment = NSTextAlignmentLeft;
//    _freeVideoLabel.layer.cornerRadius = 2.5;
//    _freeVideoLabel.layer.masksToBounds = YES;
//    _freeVideoLabel.text = @" 试播 ";
//    [_thumbImageView addSubview:_freeVideoLabel];
//    {
//        [_freeVideoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(_thumbImageView).mas_offset(4);
//            make.right.mas_equalTo(self).mas_offset(-4);
//        }];
//        
//    }
//    return _freeVideoLabel;
//    
//}
//
//- (UILabel *)subtitleLabel {
//    if (_subtitleLabel) {
//        return _subtitleLabel;
//    }
//    
//    _subtitleLabel = [[UILabel alloc] init];
//    _subtitleLabel.textColor = [UIColor whiteColor];
//    _subtitleLabel.font = [UIFont systemFontOfSize:12.];
//    _subtitleLabel.textAlignment = NSTextAlignmentRight;
//    [self.footerView addSubview:_subtitleLabel];
//    {
//        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.footerView);
//            make.right.equalTo(self.footerView).offset(-5);
//        }];
//    }
//    return _subtitleLabel;
//}
//
//- (void)setImageURL:(NSURL *)imageURL {
//    _imageURL = imageURL;
//    [_thumbImageView sd_setImageWithURL:imageURL];
//}
//
//- (void)setTitle:(NSString *)title {
//    _title = title;
//    self.titleLabel.text = title;
//    self.footerView.hidden = _title.length == 0;
//    self.freeVideoLabel.hidden = !(title.length == 0);
//}
//
//- (void)setSubtitle:(NSString *)subtitle {
//    _subtitle = subtitle;
//    //    self.subtitleLabel.text = subtitle;
//    //    self.footerView.hidden = _title.length == 0 && _subtitle.length == 0;
//}
@end
