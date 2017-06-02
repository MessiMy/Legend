//
//  ShoppingCarHeaderView.m
//  Legend
//
//  Created by 梅毅 on 2017/6/1.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ShoppingCarHeaderView.h"

@interface ShoppingCarHeaderView()

@property (nonatomic, weak)UIImageView *line;

@end

@implementation ShoppingCarHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *line = [[UIImageView alloc] init];
        self.line = line;
        _line.backgroundColor = [UIColor seperateColor];
        [self.contentView addSubview:_line];
        
        UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _checkBtn = checkBtn;
        [_checkBtn setImage:[UIImage imageNamed:@"uncheck"] forState:UIControlStateNormal];
        [_checkBtn setImage:[UIImage imageNamed:@"check"] forState:UIControlStateSelected];
        [self.contentView addSubview:_checkBtn];
        
        UILabel *sellerNameLab = [[UILabel alloc] init];
        _sellerNameLab = sellerNameLab;
        _sellerNameLab.numberOfLines = 1;
        _sellerNameLab.backgroundColor = [UIColor clearColor];
        _sellerNameLab.font = [UIFont systemFontOfSize:15];
        _sellerNameLab.textColor = [UIColor bodyTextColor];
        _sellerNameLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_sellerNameLab];
        
        UIImageView *indicateImg = [[UIImageView alloc] init];
        _indicatImgView = indicateImg;
        _indicatImgView.contentMode = UIViewContentModeScaleAspectFit;
        _indicatImgView.image = [UIImage imageNamed:@"arrow_right"];
        [self.contentView addSubview:_indicatImgView];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _line.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 0.5);
    _checkBtn.frame = CGRectMake(5, 0, 35, CGRectGetHeight(self.bounds));
    _sellerNameLab.frame = CGRectMake(CGRectGetMaxX(_checkBtn.frame), 0, CGRectGetWidth(self.bounds)-CGRectGetWidth(_checkBtn.frame)+10, CGRectGetHeight(self.bounds));
    _indicatImgView.frame = CGRectMake(CGRectGetWidth(self.bounds)-15-10, (CGRectGetHeight(self.bounds) -15)/2, 10, 15);
}
@end
