//
//  MineOrderFooterView.h
//  Legend
//
//  Created by 梅毅 on 2017/5/10.
//  Copyright © 2017年 my. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MineOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic, weak) id delegate;

@end

@protocol MineOrderFooterCollectionCellDelegate <NSObject>

- (void) orderFooterSelectItemAtIndex:(NSInteger)index;

@end

@interface MineOrderFooterCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel     *titleLab;

@end
