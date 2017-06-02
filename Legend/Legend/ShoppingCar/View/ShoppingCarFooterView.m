//
//  ShoppingCarFooterView.m
//  Legend
//
//  Created by 梅毅 on 2017/6/1.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ShoppingCarFooterView.h"

@interface ShoppingCarFooterView ()

@property (nonatomic, weak)UIImageView  *line;

@end

@implementation ShoppingCarFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        UILabel *endorseInfoLab = [[UILabel alloc] init];
        _endorseInfoLab = endorseInfoLab;
        _endorseInfoLab.numberOfLines = 1;
        _endorseInfoLab.font = [UIFont noteTextFont];
        _endorseInfoLab.textAlignment = NSTextAlignmentLeft;
        _endorseInfoLab.textColor = [UIColor bodyTextColor];
        [self.contentView addSubview:_endorseInfoLab];
        
        UIButton *makeUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeUpBtn = makeUpBtn;
        _makeUpBtn.tintColor = [UIColor themeColor];
        _makeUpBtn.titleLabel.font = [UIFont noteTextFont];
        [_makeUpBtn setTitle:@"去凑单" forState:UIControlStateNormal];
        [_makeUpBtn setImage:[UIImage imageNamed:@"arrow_right"] forState:UIControlStateNormal];
        [_makeUpBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 65, -10, 0)];
        [_makeUpBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [self.contentView addSubview:_makeUpBtn];
        
        UIImageView *line = [[UIImageView alloc] init];
        _line = line;
        _line.backgroundColor = [UIColor seperateColor];
        [self.contentView addSubview:_line];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), 40);
    _makeUpBtn.frame = CGRectMake(CGRectGetWidth(self.contentView.bounds)-15-65, 0, 65, CGRectGetHeight(self.contentView.bounds));
    _endorseInfoLab.frame = CGRectMake(40, 0, CGRectGetWidth(self.contentView.bounds) - 40 - CGRectGetWidth(self.makeUpBtn.frame) - 15, CGRectGetHeight(self.contentView.bounds));
    _line.frame = CGRectMake(0, CGRectGetHeight(self.contentView.bounds)-0.5, CGRectGetWidth(self.contentView.bounds), 0.5);
}

@end
