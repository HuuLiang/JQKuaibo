//
//  JQKHotVideoCell.m
//  JQKuaibo
//
//  Created by Sean Yue on 15/12/26.
//  Copyright © 2015年 iqu8. All rights reserved.
//

#import "JQKHotVideoCell.h"

//static const CGFloat kThumbImageScale = 0.75;



@interface JQKHotVideoCell ()
{
    UIImageView *_thumbImageView;
    
    //    UIView *_footerView;
    
    UILabel *_titleLabel;
//    UIButton *_attentionBtn;
    //    UILabel *_subtitleLabel;
    
    //    UIButton *_playButton;
}
//@property (nonatomic,retain)UIButton *attentionBtn;


@end

@implementation JQKHotVideoCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
//        _attentionBtn = [[UIButton alloc] init];
//        [_attentionBtn setImage:[UIImage imageNamed:@"home_guest"] forState:UIControlStateNormal];
//        [_attentionBtn setTitle:@"0" forState:UIControlStateNormal];
//        [_attentionBtn setTitleColor:[UIColor colorWithWhite:0.7 alpha:1] forState:UIControlStateNormal];
//        [_attentionBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
//        
//        _attentionBtn.titleLabel.font = [UIFont systemFontOfSize:12.];
//        _attentionBtn.enabled = NO;
//        [self addSubview:_attentionBtn];
//        {
//            [_attentionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//                //            make.left.mas_equalTo(_titleLabel.mas_right);
//                make.right.mas_equalTo(self).mas_offset(2);
//                make.bottom.mas_equalTo(self).mas_offset(-2);
//                make.height.mas_equalTo(14.);
//                make.width.mas_equalTo(55/375.*kScreenWidth);
//                
//            }];
//            
//        }
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:12.];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        { [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(kWidth(14.));
            make.bottom.mas_equalTo(self).mas_offset(-2);
            make.left.mas_equalTo(self).mas_offset(2);
            make.right.mas_equalTo(self).mas_offset(-2);
        }];
        }
        _thumbImageView = [[UIImageView alloc] init];
        _thumbImageView.backgroundColor = self.backgroundColor;
        [self addSubview:_thumbImageView];
        { [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.mas_equalTo(self);
            make.bottom.mas_equalTo(_titleLabel.mas_top).mas_offset(-kWidth(3.));
        }];
        }
    }
    return self;
}


- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    [_thumbImageView sd_setImageWithURL:imageURL];
}
- (void)setTitle:(NSString *)title {
    
    _title = title;
    _titleLabel.text = title;
}

//- (void)setAttentTitle:(NSString *)attentTitle {
//    _attentTitle = attentTitle;
////    NSInteger att = attentTitle.integerValue;
////    att = att + arc4random_uniform(100);
//    [_attentionBtn setTitle:attentTitle forState:UIControlStateNormal];
//}




//- (instancetype)initWithStyle:(UITableViewCellStyle)style
//              reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        self.selectionStyle = UITableViewCellSelectionStyleNone;
//        
//        _thumbImageView = [[UIImageView alloc] init];
//        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _thumbImageView.clipsToBounds = YES;
//        self.backgroundView = _thumbImageView;
//        [self addSubview:_thumbImageView];
//        {
//        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self).mas_offset(2);
//            make.bottom.mas_equalTo(self).mas_offset(-2);
//            make.left.right.mas_equalTo(self);
//        }];
//        
//        }


//        _footerView = [[UIView alloc] init];
//        _footerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//        [self addSubview:_footerView];
//        {
//            [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.bottom.equalTo(self);
//                make.height.equalTo(self).multipliedBy(0.15);
//            }];
//        }

//        _playButton = [[UIButton alloc] init];
//        _playButton.layer.cornerRadius = 4;
//        _playButton.layer.masksToBounds = YES;
//        [_playButton setTitle:@"播放" forState:UIControlStateNormal];
//        [_playButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_playButton setBackgroundImage:[UIImage imageWithColor:[UIColor blackColor]] forState:UIControlStateNormal];
//        [self addSubview:_playButton];
//        {
//            [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.right.equalTo(self).offset(-15);
//                make.centerY.equalTo(self);
//                make.size.mas_equalTo(CGSizeMake(75, 30));
//            }];
//        }
//        
//        @weakify(self);
//        [_playButton bk_addEventHandler:^(id sender) {
//            @strongify(self);
//            if (self.playAction) {
//                self.playAction();
//            }
//        } forControlEvents:UIControlEventTouchUpInside];

//        _titleLabel = [[UILabel alloc] init];
//        _titleLabel.font = [UIFont systemFontOfSize:16.];
//        _titleLabel.textColor = [UIColor whiteColor];
//        [_footerView addSubview:_titleLabel];
//        {
//            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.equalTo(_footerView).offset(5);
//                make.right.equalTo(_footerView).offset(-5);
//                make.centerY.equalTo(_footerView);
//            }];
//        }

//        _subtitleLabel = [[UILabel alloc] init];
//        _subtitleLabel.font = [UIFont systemFontOfSize:14.];
//        _subtitleLabel.textColor = [UIColor colorWithWhite:0.1 alpha:1];
//        [self addSubview:_subtitleLabel];
//        {
//            [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.left.right.equalTo(_titleLabel);
//                make.top.equalTo(_titleLabel.mas_bottom).offset(5);
//            }];
//        }
//    }
//    return self;
//}



//- (void)setTitle:(NSString *)title {
//    _title = title;
//    _titleLabel.text = title;
//}

//- (void)setSubtitle:(NSString *)subtitle {
//    _subtitle = subtitle;
//    
//    NSString *prefixString = @"评分：";
//    NSString *subtitleString = [NSString stringWithFormat:@"%@%@", prefixString, subtitle?:@"未知"];
//    
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:subtitleString];
//    [attrString addAttributes:@{NSForegroundColorAttributeName:[UIColor redColor]} range:NSMakeRange(prefixString.length, attrString.length - prefixString.length)];
//    _subtitleLabel.attributedText = attrString;
//}
@end
