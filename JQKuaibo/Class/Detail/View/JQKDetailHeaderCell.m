//
//  JQKDetailHeaderCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKDetailHeaderCell.h"

@interface JQKDetailHeaderCell ()
{
    UILabel *_tagLabel;
    UILabel *_titleLabel;
    CAShapeLayer * _lineA;
}
@end

@implementation JQKDetailHeaderCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
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
        
        [_tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(kWidth(12));
            make.size.mas_equalTo(CGSizeMake(kWidth(30), kWidth(15)));
        }];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_tagLabel);
            make.left.equalTo(_tagLabel.mas_right).offset(kWidth(20));
            make.height.mas_equalTo(kWidth(14));
        }];

    }
    return self;
}

- (void)setTagStr:(NSString *)tagStr {
    _tagLabel.text = tagStr;
}

- (void)setTitleStr:(NSString *)titleStr {
    _titleLabel.text = titleStr;
}

- (void)setTagColor:(UIColor *)tagColor {
    [_lineA setFillColor:tagColor.CGColor];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [_lineA setStrokeColor:[[UIColor clearColor] CGColor]];
    _lineA.lineWidth = 0.0f;
    CGPathMoveToPoint(linePathA, NULL, kWidth(58), kWidth(12));
    CGPathAddLineToPoint(linePathA, NULL, 0, kWidth(12));
    CGPathAddLineToPoint(linePathA, NULL, 0 , kWidth(35));
    CGPathAddLineToPoint(linePathA, NULL, kWidth(56), kWidth(35));
    CGPathAddArcToPoint(linePathA, nil, kWidth(40),kWidth(23.5), kWidth(56), kWidth(12), kWidth(7));
    [_lineA setPath:linePathA];
    CGPathRelease(linePathA);
}

@end
