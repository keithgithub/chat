//
//  LFInputAddView.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/30.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFInputAddView.h"
#import "LFInputAddCollectionViewCell.h"

#define kBgColor [UIColor colorWithRed:0.149 green:0.161 blue:0.184 alpha:1.000]

@interface LFInputAddView() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end

@implementation LFInputAddView

/**
 *  重写初始化方法
 */
-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = kBgColor;
        
        // 创建代理
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 创建九宫格
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        // 设置代理
        collectionView.delegate = self;
        collectionView.dataSource = self;
        
        // 设置九宫格背景颜色
        collectionView.backgroundColor = kBgColor;
        
        // 加入视图
        [self addSubview:collectionView];
        
        // 创建nib
        UINib *nib = [UINib nibWithNibName:@"LFInputAddCollectionViewCell" bundle:nil];
        // 注册nib
        [collectionView registerNib:nib forCellWithReuseIdentifier:@"LFInputAddCollectionViewCell"];
    }
    
    return self;
}

#pragma mark - 九宫格视图
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    // 从队列获取对象
    LFInputAddCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LFInputAddCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.item == 0) {
        [cell setCell:@"相机" andImageName:@"chat_shooting02"];
    } else if (indexPath.item == 1) {
        [cell setCell:@"相册" andImageName:@"chat_picture01"];
    }
//    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.frame.size.width - 60) / 2;
    
    return CGSizeMake(width, self.frame.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.collectionClickBlock(collectionView, indexPath.item);
}

@end






