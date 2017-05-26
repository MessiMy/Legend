//
//  GoodsDetailCollectionViewCell.m
//  Legend
//
//  Created by 梅毅 on 2017/3/28.
//  Copyright © 2017年 my. All rights reserved.
//

#import "GoodsDetailCollectionViewCell.h"

@implementation GoodsDetailCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //产品图片
        _productImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 180*widthRate)];
        [_productImg setImage:[UIImage imageNamed:@"a5.jpg"]];
        [self addSubview:_productImg];
        //产品名称
        _name = [UILabel new];
        _name.font = [UIFont systemFontOfSize:15];
        _name.textColor = [UIColor blackColor];
        _name.text = @"国粹纯粮酒6瓶480（买6赠1）好酒好酒好酒好酒好酒好酒好酒好酒";
        _name.numberOfLines = 2;
        [self addSubview:_name];
        //name自动布局
        _name.sd_layout
        .leftSpaceToView(self,10*widthRate)
        .topSpaceToView(_productImg,8*widthRate)
        .rightSpaceToView(self,10*widthRate)
        .heightIs(42*widthRate);
        //产品价格
        _price = [UILabel new];
        _price.text = @"¥593.00";
        _price.textColor = [UIColor blackColor];
        _price.font = [UIFont systemFontOfSize:16];
        _price.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_price];
        //price自动布局
        _price.sd_layout
        .leftEqualToView(_name)
        .bottomSpaceToView(self,10*widthRate)
        .widthIs(100)
        .heightIs(17*widthRate);
        //推荐代言
        _markLable = [UILabel new];
        _markLable.text = @"推荐代言";
        _markLable.textColor = [UIColor blackColor];
        _markLable.textAlignment = NSTextAlignmentCenter;
        _markLable.font = [UIFont systemFontOfSize:10];
        _markLable.layer.cornerRadius = 3;
        _markLable.layer.masksToBounds = YES;
        _markLable.layer.borderColor = [UIColor whiteColor].CGColor;
        _markLable.layer.borderWidth = 0.7;
        _markLable.hidden = YES;
        [self addSubview:_markLable];
        //markLab自动布局
        _markLable.sd_layout
        .rightSpaceToView(self,20*widthRate)
        .topSpaceToView(self,8*widthRate)
        .widthIs(50)
        .heightIs(15);
        //Mark View
        _markView = [UIView new];
        _markView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        [_productImg addSubview:_markView];
        //markView自动布局
        _markView.sd_layout
        .leftEqualToView(_productImg)
        .rightEqualToView(_productImg)
        .bottomSpaceToView(_productImg,0)
        .heightIs(30*widthRate);
        
        //
        UILabel *tagL = [UILabel new];
        tagL.text = @"可代言商品";
        tagL.textColor = [UIColor whiteColor];
        tagL.font = [UIFont systemFontOfSize:14];
        tagL.textAlignment = NSTextAlignmentCenter;
        [_markView addSubview:tagL];
        
        tagL.sd_layout
        .centerXEqualToView(_markView)
        .centerYEqualToView(_markView)
        .widthIs(150)
        .heightIs(30*widthRate);
        
    }
    return self;
}

@end
