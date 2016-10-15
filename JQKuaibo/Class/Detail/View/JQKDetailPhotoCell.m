//
//  JQKDetailPhotoCell.m
//  JQKuaibo
//
//  Created by Liang on 2016/10/14.
//  Copyright © 2016年 iqu8. All rights reserved.
//

#import "JQKDetailPhotoCell.h"

@implementation JQKDetailPhotoCell

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"视频截图赏析";
        label.font = [UIFont systemFontOfSize:kWidth(14)];
        label.textColor = [UIColor colorWithHexString:@"#000000"];
        [self addSubview:label];
        
        {
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).offset(kWidth(15));
                make.left.equalTo(self).offset(kWidth(15));
                make.height.mas_equalTo(kWidth(15));
            }];
        }
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CAShapeLayer *_lineA = [CAShapeLayer layer];
    
    CGMutablePathRef linePathA = CGPathCreateMutable();
    [_lineA setStrokeColor:[[UIColor colorWithHexString:@"#979797"] CGColor]];
    _lineA.lineWidth = 1.0f;
    CGPathMoveToPoint(linePathA, NULL, kWidth(10), kWidth(40));
    CGPathAddLineToPoint(linePathA, NULL, kScreenWidth - kWidth(10), kWidth(40));
    [_lineA setPath:linePathA];
    CGPathRelease(linePathA);
    [self.layer addSublayer:_lineA];
}


@end
