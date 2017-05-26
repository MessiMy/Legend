//
//  SearchGoodsViewController.m
//  Legend
//
//  Created by 梅毅 on 2017/3/22.
//  Copyright © 2017年 my. All rights reserved.
//

#import "SearchGoodsViewController.h"
#import "MyLayout.h"
#import "HotSearchCollectionViewCell.h"
#import "CollectionTitleHeaderView.h"

@interface SearchGoodsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate>

@property (nonatomic,weak) UITableView      *tableView;
@property (nonatomic,weak) NSMutableArray   *dataArray;
@property (nonatomic,weak) UISearchBar      *searchBar;
@property (nonatomic,weak) UICollectionView *headerView;
@property (nonatomic,weak) UICollectionView *collectionView;

@end

@implementation SearchGoodsViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.searchBar becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNav];
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    self.dataArray = arr;
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    self.tableView.hidden = YES;
    self.tableView.rowHeight = 40;
    self.tableView.sectionHeaderHeight = 40;
    self.tableView.tableHeaderView = [self tableHeaderView];;
    self.tableView.tableFooterView = [self tableFooterView];
    [self.view addSubview:self.tableView];
    [self initCollectionView];
    [self loadData];
    
}
#pragma mark - initHeaderView
-(UIView *)tableHeaderView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 10.0;
    layout.headerReferenceSize = CGSizeMake(30 + 12.5, 40);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *headerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 40) collectionViewLayout:layout];
    self.headerView = headerView;
    [self.headerView registerNib:[UINib nibWithNibName:@"CollectionTitleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView"];
    [self.headerView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotSearchCollectionViewCell"];
    self.headerView.delegate = self;
    self.headerView.dataSource = self;
    self.headerView.backgroundColor = [UIColor clearColor];
    self.headerView.contentInset = UIEdgeInsetsMake(7.5, 15, 7.5, 15);
    return self.headerView;
}
#pragma mark - 初始化tableView的底部视图
-(UIView *)tableFooterView
{
    UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clearBtn.frame = CGRectMake(50, 20, DeviceMaxWidth-100, 40);
    clearBtn.tintColor = [UIColor lightGrayColor];
    [clearBtn setTitle:@"清空历史搜索" forState:UIControlStateNormal];
    [clearBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [clearBtn setImage:[UIImage imageNamed:@"trash"] forState:UIControlStateNormal];
    [clearBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 7.5)];
    [clearBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 7.5, 0, 0)];
    clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    clearBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    clearBtn.layer.borderWidth = 0.5;
    clearBtn.layer.cornerRadius = 5;
    clearBtn.layer.masksToBounds = YES;
    [clearBtn addTarget:self action:@selector(clearButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 80)];
    [footerView addSubview:clearBtn];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 0.5)];
    line.backgroundColor = [UIColor blackColor];
    [footerView addSubview:line];
    
    return footerView;
}
-(void)initCollectionView
{
    MyLayout *myLayout = [[MyLayout alloc] init];
    myLayout.minimumLineSpacing = 10;
    myLayout.minimumInteritemSpacing = 10;
    myLayout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:myLayout];
    self.collectionView = collectionView;
    self.collectionView.hidden = YES;
    self.collectionView.backgroundColor = [UIColor greenColor];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 15, 0, 0);
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionTitleHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HotSearchCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HotSearchCollectionViewCell"];
    [self.view addSubview:self.collectionView];
}
#pragma mark - 加载数据
-(void)loadData
{
    [self updataUI];
}
-(void)updataUI
{
    if (self.dataArray.count!=0) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = YES;
    }
    else
    {
        self.tableView.hidden = YES;
        self.collectionView.hidden = NO;
    }
    [self.tableView reloadData];
    [self.headerView reloadData];
    [self.collectionView reloadData];
}
- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
    self.collectionView.frame = self.view.bounds;
}
#pragma mark - 清空按钮按下
-(void)clearButtonClicked:(UIButton *)button
{
    
}
#pragma mark - initNavigationBar
-(void)initNav
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, DeviceMaxWidth, 30)];
    self.searchBar = searchBar;
    self.searchBar.delegate = self;
    self.searchBar.backgroundImage = [UIImage new];
    self.searchBar.tintColor = [UIColor whiteColor];
    self.searchBar.placeholder = @"请输入商品名称";
    self.navigationItem.titleView = self.searchBar;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(searchBtnClicked:)];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}
-(void)searchBtnClicked:(UIBarButtonItem *)button
{
    
}

#pragma mark - UISearchBarDelegate

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length > 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    else
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}
#pragma mark - UITableViewDelegate && UITableViewDatasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.dataArray.count;
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SearchCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"历史搜索";
}
#pragma mark - UICollectionDelegae&&UICollectionDataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 5;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    CollectionTitleHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionTitleHeaderView" forIndexPath:indexPath];
    return header;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HotSearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HotSearchCollectionViewCell" forIndexPath:indexPath];
    cell.hotWord.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    
    return cell;
}
@end
