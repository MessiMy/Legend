//
//  ProductDetailPage.m
//  Legend
//
//  Created by 梅毅 on 2017/5/26.
//  Copyright © 2017年 my. All rights reserved.
//

#import "ProductDetailPage.h"
#import "MyCustomButton.h"
#import "MKAnnotationView+WebCache.h"
#import "UIImageView+WebCache.h"
#import "AppDelegate.h"
#import "ProductPropertySelectView.h"

@interface ProductDetailPage ()

@property (nonatomic, weak) UIScrollView    *mainScrollView;
@property (nonatomic, weak) UIButton        *buyBtn;
@property (nonatomic, weak) UILabel         *nameLab;
@property (nonatomic, weak) UILabel         *nowPrice;
@property (nonatomic, weak) UILabel         *oldPrice;
@property (nonatomic, weak) UIView          *priceLine;
@property (nonatomic, weak) UILabel         *addressLab;
@property (nonatomic, weak) UILabel         *rewardLab;
@property (nonatomic, assign)NSInteger      buyNumber;
@property (nonatomic, weak) UILabel         *directLab;
@property (nonatomic, weak) MyCustomButton  *gwcBtn;
@property (nonatomic, weak) UIButton        *collectionBtn;
@property (nonatomic, weak) UIImageView     *goodsImg;
@property (nonatomic, weak) UIView          *endorseView;
@property (nonatomic, weak) UIView          *directView;


@end

@implementation ProductDetailPage

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(DeviceMaxWidth-35, 20, 30, 44);
    [rightBtn setImage:imageWithName(@"home_collection_no") forState:UIControlStateNormal];
    [rightBtn setImage:imageWithName(@"home_collection_yes") forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.collectionBtn = rightBtn;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxHeight - 50)];
    scrollView.backgroundColor = viewColor;
    scrollView.showsVerticalScrollIndicator = NO;
    self.mainScrollView = scrollView;
    [self.view addSubview:self.mainScrollView];
    
    [self initFooterView];
    [self requestData];
}
#pragma mark - ButtonClicked
- (void)rightBtnClicked:(UIButton *)button
{
    if ([MyTools loginIsOrNot:self]) {
        button.selected = !button.selected;
        NSString *httpUrl = @"";
        NSString *tipStr = @"";
        if (button.selected) {
            httpUrl = PATHShop(@"api/GoodsCollect/addCollect");
            tipStr = @"收藏成功";
        }
        else
        {
            httpUrl = PATHShop(@"api/GoodsCollect/cancelCollect");
            tipStr = @"取消成功";
        }
        NSDictionary *parameters = @{@"token":[MyTools getUserToken],
                                     @"device_id":[MyTools getDeviceUUID],
                                     @"goods_id":_currentModel.goods_id?_currentModel.goods_id:@""
                                     };
        [MainRequest RequestHTTPData:httpUrl parameters:parameters success:^(id response) {
            [self showHUDWithResult:YES message:tipStr completion:nil];
        } failed:^(NSDictionary *errorDic) {
            [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:nil];
        }];
    }
}
#pragma mark - 立即购买按钮按下
- (void)buyBtnClicked
{
    if ([MyTools loginIsOrNot:self]) {
        [self attriButionSelect];
    }
}
- (void)attriButionSelect
{
    
}
#pragma mark - 商家按钮按下
- (void)shopBtnClicked
{
    
}
#pragma mark - 购物车按钮按下
- (void)shopCarBtnClicked
{
    if ([MyTools loginIsOrNot:self]) {
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *root = (UITabBarController *)app.window.rootViewController;
        NSInteger gotoIndex = 3;
        UINavigationController *nav = [root.viewControllers objectAtIndex:gotoIndex];
        [nav popToRootViewControllerAnimated:NO];
        root.selectedIndex = gotoIndex;
    }
}
#pragma mark - 加入购物车按钮按下
- (void)joinShopCarBtnClicked
{
    [[ProductPropertySelectView getInstanceWithNib] showWithProudctID:self.currentModel withCheck:YES selectBuy:^(ProducrModel *model) {
        if ([MyTools loginIsOrNot:self]) {
            [self addGWCEvent:model];
        }
    }];
    //ProductAttributionModel *selectAttModel = modf(<#double#>, <#double *#>)
}
- (void)addGWCEvent:(ProducrModel *)model
{
    ProductAttributionModel *selectAttModel = model.selectProperty[0];
    NSDictionary *parameters = @{@"token":[MyTools getUserToken],
                                 @"device_id":[MyTools getDeviceUUID],
                                 @"goods_id":[NSString stringWithFormat:@"%@",_currentModel.goods_id],
                                 @"seller_id":[NSString stringWithFormat:@"%@",_currentModel.seller_id],
                                 @"goods_number":model.selectNum,
                                 @"goods_price":[NSString stringWithFormat:@"%f",[selectAttModel.price floatValue] * [model.selectNum intValue]],
                                 @"attr_id":selectAttModel.attr_id
                                 };
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHShop(@"api/ShoppingCart/addShoppingCart") parameters:parameters success:^(id response) {
        [self showHUDWithResult:YES message:@"添加成功，在购物车中等你哟" completion:nil];
        self.buyNumber++;
        [_gwcBtn showBadgeWithStyle:WBadgeStyleNumber value:self.buyNumber animationType:WBadgeAnimTypeNone];
    } failed:^(NSDictionary *errorDic) {
        [self showHUDWithResult:NO message:@"添加失败，请检查您的网络" completion:nil];
    }];
}
#pragma mark - 直推按钮按下
- (void)ztBtnClicked
{
    
}
- (void)checkAllBtnClicked
{
    if ([MyTools loginIsOrNot:self]) {
        NSDictionary *parameters = @{@"token":[MyTools getUserToken],
                                     @"device_id":[MyTools getDeviceUUID],
                                     @"goods_id":self.goods_id?self.goods_id:@""
                                     };
        [MainRequest RequestHTTPData:PATHShop(@"api/GoodsShare/createShareLink") parameters:parameters success:^(id response) {
            NSString *imageStr = _currentModel.goods_thumb;
            NSString *urlStr = [NSString stringWithFormat:@"%@",[response objectForKey:@"goods_detail_url"]];
            NSString * conStr = @"传说，是互联网+时代给大众带来的创富机遇。带朋友看广告，就能赚大钱！";
            NSString *titleStr = _currentModel.goods_name;
            [MyTools sharedInstance];
            [MyTools fxViewAppear:imageStr conStr:conStr withUrlStr:urlStr withTitilStr:titleStr withVc:self isAdShare:nil];
        } failed:^(NSDictionary *errorDic) {
            
        }];
    }
}
#pragma mark - 请求数据
- (void)requestData
{
    NSDictionary *parameters = @{@"device_id":[MyTools getDeviceUUID],
                                 @"goods_id":[NSString stringWithFormat:@"%@",_goods_id?_goods_id:@""],
                                 @"token":[MyTools getUserToken]
                                 };
    if (self.is_endorse) {
        parameters = [[NSMutableDictionary alloc] initWithDictionary:parameters];
        [parameters setValue:@(self.is_endorse) forKey:@"is_endorse"];
    }
    [self showHUDWithMessage:nil];
    [MainRequest RequestHTTPData:PATHShop(@"api/Goods/getGoodsNewDetail") parameters:parameters success:^(id response) {
        [self hideHUD];
        self.currentModel = [ProducrModel mj_objectWithKeyValues:[response objectForKey:@"goods_detail"]];
        self.currentModel.seller_info = [SellerInfoModel1 mj_objectWithKeyValues:[response objectForKey:@"seller_info"]];
        self.currentModel.attr_list = [ProductAttributionModel mj_objectArrayWithKeyValuesArray:[response objectForKey:@"attr_list"]];
        if ([self.currentModel.is_tocard integerValue] == 1) {
            self.isTok = YES;
        }
        [self initFrameView];
        [self refreshUI];
    } failed:^(NSDictionary *errorDic) {
        __weak typeof(self) weakSelf = self;
        [self showHUDWithResult:NO message:[errorDic objectForKey:@"error_msg"] completion:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
        
    }];
}
#pragma mark - 创建底部视图
- (void)initFooterView
{
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxHeight-50, DeviceMaxWidth, 50)];
    footView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:footView];
    if (self.isTok) {
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(0, 0, DeviceMaxWidth, 50);
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        buyBtn.backgroundColor = mainColor;
        [buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyBtn = buyBtn;
        [footView addSubview:self.buyBtn];
    }
    else
    {
        MyCustomButton *shopBtn = [[MyCustomButton alloc] initWithFrame3:CGRectMake(0, 0, 80, 50)];
        NSString *str = [NSString stringWithFormat:@"detailshop"];
        [shopBtn .imgBtn setImage:imageWithName(str) forState:UIControlStateNormal];
        shopBtn.tLabel.text = @"商家";
        [shopBtn addTarget:self action:@selector(shopBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:shopBtn];
        
        UIView *lineV = [[UIView alloc] initWithFrame:CGRectMake(80-0.5, 0, 0.5, 50)];
        lineV.backgroundColor = tableDefSepLineColor;
        [footView addSubview:lineV];
        
        MyCustomButton *shopCarBtn = [[MyCustomButton alloc] initWithFrame3:CGRectMake(80, 0, 80, 50)];
        [shopCarBtn.imgBtn setImage:imageWithName(@"home_gwc") forState:UIControlStateNormal];
        shopCarBtn.tLabel.text = @"购物车";
        [shopCarBtn addTarget:self action:@selector(shopCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.gwcBtn = shopCarBtn;
        [footView addSubview:self.gwcBtn];
        
        UIButton *joinShopCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        joinShopCarBtn.frame = CGRectMake(160, 0, DeviceMaxWidth/2-80, 50);
        [joinShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        joinShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        joinShopCarBtn.backgroundColor = [UIColor colorFromHexRGB:@"f9a327"];
        [joinShopCarBtn addTarget:self action:@selector(joinShopCarBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [joinShopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [footView addSubview:joinShopCarBtn];
        
        UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        buyBtn.frame = CGRectMake(DeviceMaxWidth-(DeviceMaxWidth-160)/2, 0, DeviceMaxWidth/2-80, 50);
        [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        buyBtn.backgroundColor = mainColor;
        [buyBtn addTarget:self action:@selector(buyBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.buyBtn = buyBtn;
        [footView addSubview:self.buyBtn];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth - (DeviceMaxWidth - 160)/2, 0.5)];
        lineView.backgroundColor = tableDefSepLineColor;
        [footView addSubview:lineView];
    }
}
- (void)initFrameView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, DeviceMaxWidth)];
    imageView.backgroundColor = [UIColor clearColor];
    self.goodsImg = imageView;
    [imageView setImageWithURL:[NSURL URLWithString:[self.currentModel.gallery_img objectAtIndex:0]]];
    [self.mainScrollView addSubview:imageView];
    
    UIView *endorse = [[UIView alloc] initWithFrame:CGRectMake(0, DeviceMaxWidth - 40, DeviceMaxWidth, 40)];
    endorse.hidden = YES;
    endorse.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.endorseView = endorse;
    [self.mainScrollView addSubview:self.endorseView];
    
    UILabel *tipLab = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, DeviceMaxWidth-30, 40)];
    tipLab.text = @"可代言商品";
    tipLab.textColor = [UIColor whiteColor];
    tipLab.font = [UIFont systemFontOfSize:15];
    tipLab.textAlignment = NSTextAlignmentCenter;
    [endorse addSubview:tipLab];
    
    UIView *goodsView = [UIView new];
    goodsView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:goodsView];
    
    if (!self.isTok) {
        goodsView.sd_layout
        .leftEqualToView(self.mainScrollView)
        .rightEqualToView(self.mainScrollView)
        .topSpaceToView(imageView, 0)
        .heightIs(110);
    }
    else
    {
        goodsView.sd_layout
        .leftEqualToView(self.mainScrollView)
        .rightEqualToView(self.mainScrollView)
        .topSpaceToView(imageView, 0)
        .heightIs(70);
    }
    UILabel *nameL = [UILabel new];
    nameL.text = @"kjjsd";
    nameL.textColor = contentTitleColorStr;
    nameL.font = [UIFont systemFontOfSize:15];
    self.nameLab = nameL;
    [goodsView addSubview:nameL];
    
    nameL.sd_layout
    .leftSpaceToView(goodsView, 15*widthRate)
    .rightSpaceToView(goodsView, 15*widthRate)
    .topSpaceToView(goodsView, 12)
    .heightIs(20);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 70-0.5, DeviceMaxWidth, 0.5)];
    lineView.backgroundColor = tableDefSepLineColor;
    [goodsView addSubview:lineView];
    
    UILabel *nowL = [UILabel new];
    nowL.text = @"¥189898.00";
    nowL.textColor = mainColor;
    nowL.font = [UIFont systemFontOfSize:25];
    self.nowPrice = nowL;
    [goodsView addSubview:nowL];
    
    UILabel *oldL = [UILabel new];
    oldL.text = @"¥168.00";
    oldL.textColor = contentTitleColorStr2;
    oldL.font = [UIFont systemFontOfSize:13];
    self.oldPrice = oldL;
    [goodsView addSubview:oldL];
    
    UIView *bline = [UIView new];
    bline.backgroundColor = contentTitleColorStr2;
    self.priceLine = bline;
    [oldL addSubview:bline];
    
    UILabel *addrL = [UILabel new];
    addrL.text = @"四川成都";
    addrL.textColor = contentTitleColorStr2;
    addrL.font = [UIFont systemFontOfSize:14];
    addrL.textAlignment = NSTextAlignmentRight;
    self.addressLab = addrL;
    [goodsView addSubview:addrL];
    
    addrL.sd_layout
    .rightSpaceToView(goodsView, 15*widthRate)
    .bottomEqualToView(nowL)
    .heightIs(20)
    .widthIs(150);
    
    NSString *zlabStr = @"㊣100%正品保障";
    UILabel *zlab = [UILabel new];
    zlab.font = [UIFont systemFontOfSize:15];
    zlab.textColor = contentTitleColorStr1;
    [goodsView addSubview:zlab];
    
    NSMutableAttributedString *as = [[NSMutableAttributedString alloc] initWithString:zlabStr];
    [as addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0, 1)];
    [as addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(zlabStr.length-4, 2)];
    zlab.attributedText = as;
    
    zlab.sd_layout
    .leftSpaceToView(goodsView, 15*widthRate)
    .topSpaceToView(lineView, 0)
    .heightIs(40)
    .widthIs(DeviceMaxWidth/2-15);
    
    NSString *tlabStr = @"⑦天无理由退换货";
    UILabel *tlab= [UILabel new];
    tlab.textColor = contentTitleColorStr1;
    tlab.textAlignment = NSTextAlignmentRight;
    tlab.font = [UIFont systemFontOfSize:15];
    [goodsView addSubview:tlab];
    
    NSMutableAttributedString *tas = [[NSMutableAttributedString alloc] initWithString:tlabStr];
    [tas addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(0, 5)];
    [tas addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 1)];
    tlab.attributedText = tas;
    
    tlab.sd_layout
    .rightSpaceToView(goodsView, 15*widthRate)
    .topEqualToView(zlab)
    .widthRatioToView(zlab, 1)
    .heightRatioToView(zlab, 1);
    
    UIView *lineV = [UIView new];
    lineV.backgroundColor = tableDefSepLineColor;
    [goodsView addSubview:lineV];
    
    lineV.sd_layout
    .leftSpaceToView(goodsView, 0)
    .rightSpaceToView(goodsView, 0)
    .topSpaceToView(lineView, 40-0.5)
    .heightIs(0.5);
    
    UIView *directView = [UIView new];
    directView.backgroundColor = [UIColor whiteColor];
    self.directView = directView;
    [self.mainScrollView addSubview:self.directView];
    
    directView.sd_layout
    .xIs(0)
    .topSpaceToView(goodsView, 0)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UILabel *ztLab = [UILabel new];
    ztLab.text = @"直推奖励：¥12.90";
    ztLab.textColor = contentTitleColorStr;
    self.directLab = ztLab;
    ztLab.font = [UIFont systemFontOfSize:15];
    [directView addSubview:ztLab];
    
    ztLab.sd_layout
    .leftSpaceToView(directView, 15*widthRate)
    .rightSpaceToView(directView, 100)
    .topSpaceToView(directView, 0)
    .heightIs(40);
    
    UIImageView *arrowImg = [UIImageView new];
    [arrowImg setImage:imageWithName(@"rightjiantou")];
    [directView addSubview:arrowImg];
    
    arrowImg.sd_layout
    .rightSpaceToView(directView, 10*widthRate)
    .centerXEqualToView(ztLab)
    .widthIs(12)
    .heightEqualToWidth();
    
    UIButton *ztbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ztbtn addTarget:self action:@selector(ztBtnClicked) forControlEvents:UIControlEventTouchUpOutside];
    [directView addSubview:ztbtn];
    
    ztbtn.sd_layout
    .leftSpaceToView(directView, 0)
    .rightSpaceToView(directView, 0)
    .topSpaceToView(directView, 0)
    .heightIs(40);
    
    UIView *lineVV = [UIView new];
    lineVV.backgroundColor = tableDefSepLineColor;
    [directView addSubview:lineVV];
    
    lineVV.sd_layout
    .leftSpaceToView(directView, 0)
    .rightSpaceToView(directView, 0)
    .topSpaceToView(directView, 40-0.5)
    .heightIs(0.5);
    
    UIView *evaluateView = [UIView new];
    evaluateView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:evaluateView];
    
    evaluateView.sd_layout
    .xIs(0)
    .topSpaceToView(directView, 10)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UILabel *evaluateLab = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 10, 200*widthRate, 20)];
    evaluateLab.textColor = contentTitleColorStr;
    self.rewardLab = evaluateLab;
    evaluateLab.font = [UIFont systemFontOfSize:15];
    [evaluateView addSubview:evaluateLab];
    
    [self.mainScrollView setupAutoContentSizeWithBottomView:evaluateView bottomMargin:10];
}
- (void)refreshUI
{
    self.endorseView.hidden = !self.currentModel.is_endorse;
    self.buyNumber = [_currentModel.cart_num integerValue];
    _gwcBtn.badgeCenterOffset = CGPointMake(-30, 12);
    [_gwcBtn showBadgeWithStyle:WBadgeStyleNumber value:self.buyNumber animationType:WBadgeAnimTypeNone];
    self.collectionBtn.selected = [_currentModel.is_collect boolValue];
    [self.goodsImg setImageWithURL:[NSURL URLWithString:_currentModel.gallery_img[0]]];
    self.nameLab.text = _currentModel.goods_name;
    NSString *priceNowStr = [NSString stringWithFormat:@"¥%@",_currentModel.shop_price];
    NSMutableAttributedString *priceAttr = [[NSMutableAttributedString alloc] initWithString:priceNowStr];
    [priceAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:NSMakeRange(0, 1)];
    self.nowPrice.attributedText = priceAttr;
    self.nowPrice.frame = CGRectMake(15*widthRate, 32, 100, 40*widthRate);
    [self.nowPrice sizeToFit];
    
    self.oldPrice.text = [NSString stringWithFormat:@"¥%@",_currentModel.market_price];
    
    CGFloat width = [self.oldPrice.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]}].width;
    self.oldPrice.frame = CGRectMake(CGRectGetMaxX(self.nowPrice.frame)+10*widthRate, 32, width, 40*widthRate);
    
    self.priceLine.sd_layout
    .leftSpaceToView(self.oldPrice, -2)
    .rightSpaceToView(self.oldPrice, -2)
    .centerYEqualToView(self.oldPrice)
    .heightIs(0.5);
    
    self.addressLab.text = _currentModel.seller_addr_info;
    
    NSString *recommend_reward = nil;
    if (_currentModel.attr_list.count == 1) {
        ProductAttributionModel *recommendModel = _currentModel.attr_list[0];
        if ([recommendModel.recommend_reward floatValue] == 0) {
            self.directView.hidden = YES;
            self.directView.sd_layout
            .heightIs(0);
            [self.directView updateLayout];
        }
        else
        {
            self.directView.hidden = NO;
            self.directView.sd_layout
            .heightIs(40);
            [self.directView updateLayout];
        }
        NSString  *rewardLabStr = [NSString stringWithFormat:@"直推奖励：¥%.2f",[recommendModel.recommend_reward floatValue]];
        NSMutableAttributedString *reAttr = [[NSMutableAttributedString alloc] initWithString:rewardLabStr];
        [reAttr addAttribute:NSForegroundColorAttributeName value:mainColor range:NSMakeRange(5, rewardLabStr.length-5)];
        self.directLab.attributedText = reAttr;
    }
    else if (_currentModel.attr_list.count > 1)
    {
        ProductAttributionModel *recommendModelStart = _currentModel.attr_list[0];
        ProductAttributionModel *recommendModelend = _currentModel.attr_list[_currentModel.attr_list.count-1] ;
        if (recommendModelStart.recommend_reward != recommendModelend.recommend_reward) {
            recommend_reward = [NSString stringWithFormat:@"%@ - %@",recommendModelend.recommend_reward, recommendModelStart.recommend_reward];
            NSString *rewardLabStr = [NSString stringWithFormat:@"直推奖励：%@",recommend_reward];
            self.directLab.attributedText = [MyTools setFontColor:mainColor WithString:rewardLabStr WithRange:NSMakeRange(5, rewardLabStr.length-5)];
        }
        else
        {
            recommend_reward = [NSString stringWithFormat:@"¥%@",recommendModelStart.recommend_reward];
            NSString *rewardLabStr = [NSString stringWithFormat:@"直推奖励：%@",recommend_reward];
            self.directLab.attributedText = [MyTools setFontColor:mainColor WithString:rewardLabStr WithRange:NSMakeRange(5, rewardLabStr.length-5)];
            if ([recommend_reward floatValue] == 0) {
                self.directView.hidden = YES;
                self.directView.sd_layout
                .heightIs(0);
                [self.directView updateLayout];
            }
        }
    }
    self.rewardLab.text = [NSString stringWithFormat:@"商品评价 (%@)",_currentModel.comment_count];
    NSArray *two_comment_list = _currentModel.two_comment_list;
    CGFloat height = 200;
    if (self.directView.isHidden) {
        height -= 40;
    }
    if (self.isTok) {
        height -= 40;
    }
    if (two_comment_list.count > 0) {
        NSDictionary *dataDic = two_comment_list[0];
        UIView *lineView = [UIView new];
        lineView.backgroundColor = tableDefSepLineColor;
        [self.mainScrollView addSubview:lineView];
        lineView.sd_layout
        .topSpaceToView(self.goodsImg, height)
        .leftSpaceToView(self.mainScrollView, 0)
        .rightSpaceToView(self.mainScrollView, 0)
        .heightIs(1);
        
        UIView *evaluationView = [UIView new];
        evaluationView.backgroundColor = [UIColor whiteColor];
        [self.mainScrollView addSubview:evaluationView];
        
        evaluationView.sd_layout
        .leftSpaceToView(self.mainScrollView, 0)
        .rightSpaceToView(self.mainScrollView, 0)
        .topSpaceToView(lineView, 0)
        .heightIs(180);
        
        UIImageView *headImg = [[UIImageView alloc] initWithFrame:CGRectMake(10*widthRate, 15, 30, 30)];
        headImg.layer.cornerRadius = 15;
        headImg.layer.masksToBounds = YES;
        [headImg setImageWithURL:[NSURL URLWithString:[dataDic objectForKey:@"user_avatar"]]];
        [evaluationView addSubview:headImg];
        
        UILabel *name = [UILabel new];
        name.font = [UIFont systemFontOfSize:12];
        name.text = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_name"]];
        name.textColor = contentTitleColorStr1;
        [evaluationView addSubview:name];
        
        name.sd_layout
        .centerYEqualToView(headImg)
        .leftSpaceToView(headImg, 15)
        .rightSpaceToView(evaluationView, 15*widthRate)
        .heightIs(20*widthRate);
        
        NSString *contentStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"content"]];
        CGFloat contentHeight = [MyTools getSpaceLabelHeight:contentStr withFont:[UIFont systemFontOfSize:15] withWidth:DeviceMaxWidth-20*widthRate withLineSpacing:4];
        UILabel *content = [[UILabel alloc] initWithFrame:CGRectMake(10*widthRate, 55, DeviceMaxWidth-20*widthRate, contentHeight)];
        content.font = [UIFont systemFontOfSize:15];
        content.numberOfLines = 0;
        content.textColor = contentTitleColorStr;
        content.attributedText = [MyTools setLineSpaceing:4 WithString:contentStr WithRange:NSMakeRange(0, contentStr.length)];
        [evaluationView addSubview:content];
        
        UILabel *date =[UILabel new];
        date.font = [UIFont systemFontOfSize:12];
        date.text = [MyTools LongTimeToString:[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"create_time"]] withFormat:@"YYYY-MM-dd HH:mm:ss"];
        date.textColor = contentTitleColorStr2;
        [evaluationView addSubview:date];
        
        date.sd_layout
        .leftEqualToView(headImg)
        .topSpaceToView(content, 10)
        .rightSpaceToView(evaluationView, 15)
        .heightIs(20);
        
        UIButton *checkAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [checkAllBtn setTitle:@"查看全部评价" forState:UIControlStateNormal];
        [checkAllBtn setTitleColor:mainColor forState:UIControlStateNormal];
        checkAllBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        checkAllBtn.layer.borderWidth = 1;
        [checkAllBtn addTarget:self action:@selector(checkAllBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        checkAllBtn.layer.borderColor = mainColor.CGColor;
        [evaluationView addSubview:checkAllBtn];
        
        checkAllBtn.sd_layout
        .centerXEqualToView(evaluationView)
        .topSpaceToView(date, 20*widthRate)
        .widthIs(120*widthRate)
        .heightIs(32*widthRate);
        
        UIView *lineV = [UIView new];
        lineV.backgroundColor = tableDefSepLineColor;
        [evaluationView addSubview:lineV];
        
        lineV.sd_layout
        .leftSpaceToView(evaluationView, 0)
        .rightSpaceToView(evaluationView, 0)
        .topSpaceToView(evaluationView, 175)
        .heightIs(1);
        
        height += 180;
    }
    UIView *laView = [UIView new];
    laView.backgroundColor = [UIColor whiteColor];
    [self.mainScrollView addSubview:laView];
    
    laView.sd_layout
    .xIs(0)
    .topSpaceToView(self.goodsImg, height)
    .widthIs(DeviceMaxWidth)
    .heightIs(40);
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(40*widthRate, (40-1)/2, DeviceMaxWidth-80*widthRate, 1)];
    view.backgroundColor = tableDefSepLineColor;
    [laView addSubview:view];
    UIView *aall = [[UIView alloc] initWithFrame:CGRectMake((DeviceMaxWidth-160)/2, 0*widthRate, 160, 40)];
    aall.backgroundColor = [UIColor whiteColor];
    [laView addSubview:aall];
    
    UILabel *ladong = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, 160, 20)];
    ladong.text = @"继续拖动，查看图文详情";
    ladong.textColor = contentTitleColorStr;
    ladong.textAlignment = NSTextAlignmentCenter;
    ladong.font = [UIFont systemFontOfSize:13];
    [aall addSubview:ladong];
    
    NSArray *picArray = _currentModel.goods_desc;
    UIView *imageDeteil = [UIView new];
    if (picArray && picArray.count) {
        __block CGFloat hight = 0;
        [self.mainScrollView addSubview:imageDeteil];
        for (int i=0; i<picArray.count; i++) {
            UIImageView *picture = [UIImageView new];
            [picture sd_setImageWithURL:[NSURL URLWithString:picArray[i]] placeholderImage:[UIImage imageNamed:placeSquareBigImg] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                if (image) {
                    CGFloat height = DeviceMaxWidth/image.size.width * image.size.height;
                    picture.frame = CGRectMake(0, hight, DeviceMaxWidth, height);
                    hight += height;
                    [imageDeteil addSubview:picture];
                    imageDeteil.sd_layout
                    .xIs(0)
                    .topSpaceToView(laView,0)
                    .widthIs(DeviceMaxWidth)
                    .heightIs(hight);
                    FLLog(@"hight = %f",hight);
                    [self.mainScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:hight];
                }
                if (error) {
                    [self.mainScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:hight];
                    return;
                }
            }];
        }
    }else{
        [self.mainScrollView setupAutoContentSizeWithBottomView:laView bottomMargin:0];
    }
    [self.mainScrollView layoutSubviews];
}
- (void)continueDealBuy
{
    
}
@end
