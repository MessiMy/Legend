//
//  GoodsListView.m
//  Legend
//
//  Created by 梅毅 on 2017/3/27.
//  Copyright © 2017年 my. All rights reserved.
//

#import "GoodsListView.h"
#import "MainPageCollectionViewCell.h"
#import "GoodsListHeaderReusableView.h"
#import "SDWebImageManager.h"
#import "UIImageView+AFNetworking.h"
#import "CommodityListViewPage.h"

@interface GoodsListView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak)UICollectionView   *myCollectionView;
@property (nonatomic, strong)UIViewController   *tempVC;
@property (nonatomic, strong)NSDictionary       *dataDic;

@end

@implementation GoodsListView

-(instancetype)initWithFrame:(CGRect)frame :(UIViewController *)andViewController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tempVC = andViewController;
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        layout.headerReferenceSize = CGSizeMake(DeviceMaxWidth, 40*widthRate);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) collectionViewLayout:layout];
        [collectionView registerClass:[MainPageCollectionViewCell class] forCellWithReuseIdentifier:@"MainPageCollectionViewCell"];
        [collectionView registerNib:[UINib nibWithNibName:@"GoodsListHeaderReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"GoodsListHeaderReusableView"];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor colorWithRed:242.0/255 green:242.0/255 blue:242.0/255 alpha:1];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        self.myCollectionView = collectionView;
        self.myCollectionView.scrollEnabled = NO;
        [self addSubview:self.myCollectionView];
        
    }
    return self;
}
-(void)setGoodsData:(NSDictionary *)goodsData
{
    self.dataDic = goodsData;
    [self.myCollectionView reloadData];
}
#pragma mark - UICollectionViewDataSource && UICollectionViewDelagete
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataDic.count;
    //return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *arr = nil;
    if (section == 0) {
        arr = [self.dataDic objectForKey:@"first"];
    }
    else if (section == 1)
    {
        arr = [self.dataDic objectForKey:@"second"];
    }
    else if (section == 2)
    {
        arr = [self.dataDic objectForKey:@"third"];
    }
    else
    {
        return 0;
    }
    return arr.count;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return (CGSize){DeviceMaxWidth,40*widthRate};
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    GoodsListHeaderReusableView *headerView;
    if (kind == UICollectionElementKindSectionHeader) {
        headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"GoodsListHeaderReusableView" forIndexPath:indexPath];
        //headerView.backgroundColor = [UIColor lightGrayColor];
    }
    if (indexPath.section == 0) {
        [headerView.headerImg setImage:[UIImage imageNamed:@"home_love_buy"]];
    }
    else if (indexPath.section == 1)
    {
        [headerView.headerImg setImage:[UIImage imageNamed:@"home_xiangpinzhi"]];
    }
    else if (indexPath.section == 2)
    {
        [headerView.headerImg setImage:[UIImage imageNamed:@"home_goutese"]];
    }
    return headerView;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIndentifier = @"MainPageCollectionViewCell";
    MainPageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIndentifier forIndexPath:indexPath];
    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = [self.dataDic objectForKey:@"first"];
    }
    else if (indexPath.section == 1)
    {
        array = [self.dataDic objectForKey:@"second"];
    }
    else if (indexPath.section == 2)
    {
        array = [self.dataDic objectForKey:@"third"];
    }
    NSDictionary *dict = array[indexPath.row];
    NSString  *imageUrl = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            imageUrl = [dict objectForKey:@"category_big_img"];
            
        }
        else
        {
            imageUrl = [dict objectForKey:@"category_img"];
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0 || indexPath.row == 3) {
            imageUrl = [dict objectForKey:@"category_img"];
        }
        else
        {
            imageUrl = [dict objectForKey:@"category_s_img"];
            //设置图片
        }
    }
    else
    {
        imageUrl = [dict objectForKey:@"category_img"];
    }
    //设置图片
    [cell.bcImage setImageWithURL:[NSURL URLWithString:imageUrl]];
    return cell;
}
#pragma mark - UICollectionViewFlowLayoutDelegate
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return CGSizeMake(DeviceMaxWidth, 150*widthRate);
        }
        else
        {
            return CGSizeMake(DeviceMaxWidth/2, 90*widthRate);
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0 || indexPath.row == 3) {
            return CGSizeMake(DeviceMaxWidth/2, 90*widthRate);
        }
        else
        {
            return CGSizeMake(DeviceMaxWidth/4, 90*widthRate);
        }
    }
    else if(indexPath.section == 2)
    {
        return CGSizeMake(DeviceMaxWidth/2, 90*widthRate);
    }
    else
    {
        return CGSizeMake(0, 0);
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = nil;
    if (indexPath.section == 0) {
        array = [self.dataDic objectForKey:@"first"];
    }
    else if (indexPath.section == 1)
    {
        array = [self.dataDic objectForKey:@"second"];
    }
    else
    {
        array = [self.dataDic objectForKey:@"third"];
    }
    NSDictionary *dict = array[indexPath.row];
    CommodityListViewPage *commodityListPage = [[CommodityListViewPage alloc] init];
    commodityListPage.hidesBottomBarWhenPushed = YES;
    commodityListPage.goodsName = [NSString stringWithFormat:@"%@", [dict objectForKey:@"cat_name"]];
    commodityListPage.categoryID = [NSString stringWithFormat:@"%@",[dict objectForKey:@"cat_id"]] ;
    commodityListPage.isFromShoppingMallView = YES;
    [self.tempVC.navigationController pushViewController:commodityListPage animated:YES];
}
@end
