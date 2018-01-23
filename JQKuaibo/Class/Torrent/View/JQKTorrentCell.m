//
//  JQKTorrentCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/13.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKTorrentCell.h"

#define imgVSize (long)(kScreenWidth - kWidth(10)*4)/3

@interface JQKTorrentCell()
{
    UILabel *_tagLabel;
    UILabel *_titleLabel;
    UIButton *_vipBtn;
    
    UIImageView *_imgVA;
    UIImageView *_imgVB;
    UIImageView *_imgVC;
    
    UIImageView *_userImgV;
    UILabel *_nameLabel;
    
    UILabel *_notiLabel;
    UILabel *_bdLabel;
    
    CAShapeLayer * _lineA;
}

@end

@implementation JQKTorrentCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor colorWithHexString:@"#edebeb"];
        [self addSubview:view];
        
        _lineA = [CAShapeLayer layer];
        [self.layer addSublayer:_lineA];
        
        _tagLabel = [[UILabel alloc] init];
        _tagLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _tagLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        _tagLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_tagLabel];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        _titleLabel.font = [UIFont systemFontOfSize:kWidth(14)];
        [self addSubview:_titleLabel];
        
        _vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_vipBtn setTitle:@"购买VIP直接发种子>>" forState:UIControlStateNormal];
        _vipBtn.titleLabel.font = [UIFont systemFontOfSize:kWidth(12)];
        [self addSubview:_vipBtn];
        
        _imgVA = [[UIImageView alloc] init];
        [self addSubview:_imgVA];
        
        _imgVB = [[UIImageView alloc] init];
        [self addSubview:_imgVB];
        
        _imgVC = [[UIImageView alloc] init];
        [self addSubview:_imgVC];
        
        UIImage *userImg = [UIImage imageNamed:@"torrent_user"];
        _userImgV = [[UIImageView alloc] initWithImage:userImg];
        [self addSubview:_userImgV];
        
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:kWidth(10)];
        _nameLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        [self addSubview:_nameLabel];
        
        _notiLabel = [[UILabel alloc] init];
        _notiLabel.text = @"提取码VIP用户可见";
        _notiLabel.textColor = [UIColor colorWithHexString:@"#9b9b9b"];
        _notiLabel.font = [UIFont systemFontOfSize:kWidth(10)];
        [self addSubview:_notiLabel];
        
        _bdLabel = [[UILabel alloc] init];
        _bdLabel.font = [UIFont systemFontOfSize:kWidth(10)];
        _bdLabel.textColor = [UIColor colorWithHexString:@"#f8f8f8"];
        _bdLabel.backgroundColor = [UIColor colorWithHexString:@"#4c75c1"];
        _bdLabel.textAlignment = NSTextAlignmentCenter;
        _bdLabel.text = @"百度云观看";
        _bdLabel.layer.cornerRadius = kWidth(8);
        _bdLabel.layer.masksToBounds = YES;
        [self addSubview:_bdLabel];
        
        @weakify(self);
        [_vipBtn bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.action(nil);
        } forControlEvents:UIControlEventTouchUpInside];
        
        {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.left.right.equalTo(self);
                make.height.mas_equalTo(kWidth(193));
            }];
            
            [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view).offset(kWidth(15));
                make.left.equalTo(view).offset(kWidth(8));
                make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(15)));
            }];
            
            [_vipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_tagLabel);
                make.right.equalTo(view.mas_right).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(kWidth(120), kWidth(10)));
            }];
            
            [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_tagLabel);
                make.left.equalTo(_tagLabel.mas_right).offset(kWidth(20));
                make.height.mas_equalTo(kWidth(14));
                make.right.equalTo(_vipBtn.mas_left).offset(-kWidth(10));
            }];
            
            [_imgVA mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(kWidth(10));
                make.top.equalTo(_tagLabel.mas_bottom).offset(kWidth(15));
                make.size.mas_equalTo(CGSizeMake(imgVSize, imgVSize));
            }];
            
            [_imgVB mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_imgVA);
                make.left.equalTo(_imgVA.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(imgVSize, imgVSize));
            }];
            
            [_imgVC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_imgVB);
                make.left.equalTo(_imgVB.mas_right).offset(kWidth(10));
                make.size.mas_equalTo(CGSizeMake(imgVSize, imgVSize));
            }];
            
            [_userImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(view).offset(kWidth(10));
                make.bottom.equalTo(view.mas_bottom).offset(-kWidth(10));
                make.size.mas_equalTo(CGSizeMake(userImg.size.width, userImg.size.height));
            }];
            
            [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_userImgV.mas_right).offset(kWidth(10));
                make.centerY.equalTo(_userImgV);
                make.height.mas_equalTo(kWidth(24));
            }];
            
            [_bdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(view.mas_right).offset(-kWidth(10));
                make.centerY.equalTo(_nameLabel);
                make.size.mas_equalTo(CGSizeMake(kWidth(75), kWidth(17)));
            }];
            
            [_notiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(_bdLabel);
                make.right.equalTo(_bdLabel.mas_left).offset(-kWidth(10));
                make.height.mas_equalTo(kWidth(20));
            }];
        }
        
    }
    return self;
}

- (void)setTagStr:(NSString *)tagStr {
    _tagLabel.text = tagStr;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setUrlsArr:(NSArray *)urlsArr {
    if (urlsArr.count <= 0) return;
    
    [_imgVA sd_setImageWithURL:[NSURL URLWithString:urlsArr.count>0 ? urlsArr[0] : nil]];
    [_imgVB sd_setImageWithURL:[NSURL URLWithString:urlsArr.count>1 ? urlsArr[1] : nil]];
    [_imgVC sd_setImageWithURL:[NSURL URLWithString:urlsArr.count>2 ? urlsArr[2] : nil]];
}

- (void)setUserNameStr:(NSString *)userNameStr {
    _nameLabel.text = userNameStr;
}

- (void)setTagColor:(UIColor *)tagColor {
    [_lineA setFillColor:tagColor.CGColor];
    [_vipBtn setTitleColor:tagColor forState:UIControlStateNormal];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [_lineA setStrokeColor:[[UIColor clearColor] CGColor]];
    _lineA.lineWidth = 0.0f;
    CGPathMoveToPoint(linePathA, NULL, kWidth(56), kWidth(10));
    CGPathAddLineToPoint(linePathA, NULL, 0, kWidth(10));
    CGPathAddLineToPoint(linePathA, NULL, 0 , kWidth(35));
    CGPathAddLineToPoint(linePathA, NULL, kWidth(56), kWidth(35));
    CGPathAddArcToPoint(linePathA, nil, kWidth(40),kWidth(22.5), kWidth(56), kWidth(10), kWidth(7));
    [_lineA setPath:linePathA];
    CGPathRelease(linePathA);
}

@end
