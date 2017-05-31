//
//  ProductPropertySelectView.m
//  Legend
//
//  Created by 梅毅 on 2017/5/31.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ProductPropertySelectView.h"
#import "ProducrModel.h"
#import "UIImageView+WebCache.h"

#define SYS_UI_COLOR(r,g,b,a)               [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]
#define SYS_UI_COLOR_TEXT_BLACK          SYS_UI_COLOR(101, 101, 101, 1)

@interface PropertyButton : UIButton

@property (nonatomic, strong)UIColor    *normalBackGroudColor;
@property (nonatomic, strong)UIColor    *normalTextColor;
@property (nonatomic, strong)UIColor    *selectBackGroundColor;
@property (nonatomic, strong)UIColor    *selectTextColor;
@property (nonatomic, strong)UIColor    *invailedBackGroundColor;
@property (nonatomic, strong)NSString   *strKey;
@property (nonatomic, strong)id         model;

@end

@implementation PropertyButton

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    if (selected) {
        [self setBackgroundColor:_selectBackGroundColor];
        [self setTitleColor:_selectTextColor forState:UIControlStateNormal];
        
        [self setFlat:self radius:1 color:nil borderWith:0];
    }
    else
    {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
}
- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    if (enabled) {
        [self setBackgroundColor:_normalBackGroudColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
    else{
        [self setBackgroundColor:_invailedBackGroundColor];
        [self setTitleColor:_normalTextColor forState:UIControlStateNormal];
        [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
    }
}
-(void)setNormalBackGroudColor:(UIColor *)normalBackGroudColor{
    _normalBackGroudColor = normalBackGroudColor;
    [self setBackgroundColor:normalBackGroudColor];
    [self setFlat:self radius:1 color:[UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0] borderWith:1];
}

-(void)setNormalTextColor:(UIColor *)normalTextColor{
    
    _normalTextColor = normalTextColor;
    [self setTitleColor:normalTextColor forState:UIControlStateNormal];
}
-(void)setFlat:(UIView*)view radius:(CGFloat)radius color:(UIColor*)color borderWith:(CGFloat)borderWith
{
    CALayer * downButtonLayer = [view layer];
    [downButtonLayer setMasksToBounds:YES];
    [downButtonLayer setCornerRadius:radius];
    [downButtonLayer setBorderWidth:borderWith];
    [downButtonLayer setBorderColor:[color CGColor]];
}
@end

@interface ProductPropertySelectView()

@property (nonatomic, strong)UILabel        *prountNumLab;
@property (nonatomic, strong)ProductAttributionModel *selecModel;


@end
@implementation ProductPropertySelectView

+(ProductPropertySelectView *)getInstanceWithNib
{
    ProductPropertySelectView *view = nil;
    NSArray *objcs = [[NSBundle mainBundle] loadNibNamed:@"ProductPropertySelectView" owner:self options:nil];
    for (id objc in objcs) {
        if ([objc isKindOfClass:[ProductPropertySelectView class]]) {
            view = (ProductPropertySelectView *)objc;
            view.frame = [UIScreen mainScreen].bounds;
            break;
        }
    }
    return view;
}
- (void)setUI
{
    _BuyButton.backgroundColor = mainColor;
    if ([self.currentModel.goods_number intValue] > 0) {
        _currentModel.selectNum = @"1";
    }
    else
    {
        _BuyButton.enabled = NO;
        _BuyButton.backgroundColor = buttonGrayColor;
    }
    float height = 0;
    NSArray *array = _currentModel.attr_list;
    float leading = 12;
    float h = 35;
    PropertyButton *lastButton = nil;
    for (int j = 0; j < array.count; j++) {
        PropertyButton *button = [PropertyButton buttonWithType:UIButtonTypeCustom];
        button.normalBackGroudColor = [UIColor  whiteColor];
        button.normalTextColor = SYS_UI_COLOR_TEXT_BLACK;
        button.selectBackGroundColor = mainColor;
        button.selectTextColor = [UIColor whiteColor];
        button.invailedBackGroundColor = contentTitleColorStr;
        
        ProductAttributionModel *attrModel = [array objectAtIndex:j];
        button.model = attrModel;
        NSString *content = attrModel.attr_name;
        [button setTitle:content forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [_scrollContentView addSubview:button];
        
        NSStringDrawingOptions optional = NSStringDrawingUsesLineFragmentOrigin;
        CGSize sizex = CGSizeMake(CGFLOAT_MAX, h);
        NSDictionary *dic = @{NSFontAttributeName:button.titleLabel.font,NSForegroundColorAttributeName:SYS_UI_COLOR_TEXT_BLACK};
        CGRect labSize = [content boundingRectWithSize:sizex options:optional attributes:dic context:nil];
        CGSize size = labSize.size;
        size.width += leading*2;
        if (size.width > DeviceMaxWidth - leading *2) {
            size.width = DeviceMaxWidth - leading * 2;
        }
        if (lastButton) {
            if (size.width > DeviceMaxWidth - lastButton.frame.origin.x - lastButton.frame.size.width - leading) {
                height = height + h + leading;
                button.frame = CGRectMake(leading, lastButton.frame.origin.y+h+leading, size.width, h);
            }
            else
            {
                button.frame = CGRectMake(lastButton.frame.origin.x+lastButton.frame.size.width+leading, lastButton.frame.origin.y, size.width, h);
            }
        }
        else
        {
            button.frame = CGRectMake(leading, height + leading, size.width, h);
            height = height + h + leading;
        }
        lastButton = button;
        [button addTarget:self action:@selector(selectProperty:) forControlEvents:UIControlEventTouchUpInside];
    }
    height += leading;
    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(12, height, DeviceMaxWidth - 24, 1)];
    separateLine.backgroundColor = viewColor;
    [_scrollContentView addSubview:separateLine];
    
    height += 11;
    UILabel *buyCountLab = [[UILabel alloc] initWithFrame:CGRectMake(12, height, DeviceMaxWidth-24, 50)];
    buyCountLab.textColor = [UIColor colorFromHexRGB:@"444444"];
    buyCountLab.text = @"购买数量";
    buyCountLab.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:buyCountLab];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(DeviceMaxWidth - 44, height, 44, 50);
    [addBtn setImage:[UIImage imageNamed:@"add_count"] forState:UIControlStateNormal];
    [addBtn addTarget:separateLine action:@selector(addPrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:addBtn];
    
    UIView *separLine1 = [[UIView alloc] initWithFrame:CGRectMake(addBtn.frame.origin.x-1, addBtn.frame.origin.y+10, 1, 30)];
    separLine1.backgroundColor = viewColor;
    [_scrollContentView addSubview:separLine1];
    
    self.prountNumLab = [[UILabel alloc] initWithFrame:CGRectMake(separLine1.frame.origin.x - 44, addBtn.frame.origin.y, 44, 50)];
    self.prountNumLab.textAlignment = NSTextAlignmentCenter;
    self.prountNumLab.text = @"1";
    self.prountNumLab.font = [UIFont systemFontOfSize:14];
    [_scrollContentView addSubview:_prountNumLab];
    
    UIView *separLine2 = [[UIView alloc] initWithFrame:CGRectMake(_prountNumLab.frame.origin.x - 1, buyCountLab.frame.origin.y + 10, 1, 30)];
    separLine2.backgroundColor = viewColor;
    [_scrollContentView addSubview:separLine2];
    
    UIButton *decBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    decBtn.frame = CGRectMake(separLine2.frame.origin.x - 44, height, 44, 50);
    [decBtn setImage:[UIImage imageNamed:@"decrease_count"] forState:UIControlStateNormal];
    [decBtn addTarget:self action:@selector(decreasePrountCount:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollContentView addSubview:decBtn];
    
    height += 50;
    _scrollContentHeight.constant = height - 275;
    
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_currentModel.goods_thumb] placeholderImage:placeHolderImg completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
    }];
    
}
- (void)addPrountCount:(UIButton *)button
{
    int maxCount = [_currentModel.goods_number intValue];
    if (_selecModel) {
        maxCount = [_selecModel.goods_number intValue];
    }
    if ([_prountNumLab.text intValue] < maxCount) {
        _prountNumLab.text = [NSString stringWithFormat:@"%d",[_prountNumLab.text intValue] + 1];
        _currentModel.selectNum = _prountNumLab.text;
        _TitleLab.text = [NSString stringWithFormat:@"¥%0.2f",[_selecModel.price floatValue] * [_currentModel.selectNum intValue]];
        if (!_selecModel.price) {
            self.TitleLab.text = [NSString stringWithFormat:@"¥%0.2f",[_currentModel.shop_price floatValue] * [_currentModel.selectNum intValue]];
        }
    }
    if ([_currentModel.selectNum intValue] <= 0) {
        _BuyButton.enabled = NO;
        _BuyButton.backgroundColor = buttonGrayColor;
    }
    else
    {
        _BuyButton.enabled = YES;
        _BuyButton.backgroundColor = mainColor;
    }
}
- (void)decreasePrountCount:(UIButton *)button
{
    if ([self.prountNumLab.text intValue]>1) {
        self.prountNumLab.text = [NSString stringWithFormat:@"%d",[self.prountNumLab.text intValue] - 1];
        _currentModel.selectNum = self.prountNumLab.text;
        
        self.TitleLab.text = [NSString stringWithFormat:@"¥%0.2f",[_selecModel.price floatValue] * [_currentModel.selectNum intValue]];
    }
    
    if (!_selecModel.price)
    {
        self.TitleLab.text = [NSString stringWithFormat:@"¥%0.2f", [_currentModel.shop_price floatValue] * [_currentModel.selectNum intValue]];
    }
    
    if([_currentModel.selectNum intValue] <= 0){
        
        _BuyButton.enabled = NO;
        _BuyButton.backgroundColor = buttonGrayColor;
    }
    else{
        _BuyButton.enabled = YES;
        _BuyButton.backgroundColor = mainColor;
    }
}
- (void)selectProperty:(UIButton *)button
{
    
}
- (void)showWithProudctID:(ProducrModel *)model withCheck:(BOOL)isCarShop selectBuy:(ProductPropertySelectBuyBlock)block
{
    self.buyBlock = block;
    _currentModel = model;
    _TitleLab.text = [NSString stringWithFormat:@"¥%@",model.shop_price];
    _PriceLab.text = [NSString stringWithFormat:@"库存：%@",model.goods_number];
    if (isCarShop) {
        [self.BuyButton setTitle:@"加入购物车" forState:UIControlStateNormal];
    }
    else
    {
        [self.BuyButton setTitle:@"立即购买" forState:UIControlStateNormal];
    }
    [self setUI];
}
@end
