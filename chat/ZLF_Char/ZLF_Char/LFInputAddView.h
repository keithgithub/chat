//
//  LFInputAddView.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/30.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UICollectionView;
typedef void(^CollectionClickBlock)(UICollectionView *collectionView, int item);

@interface LFInputAddView : UIView
/**
 *  回调用代码块
 */
@property (nonatomic, strong) CollectionClickBlock collectionClickBlock;
@end
