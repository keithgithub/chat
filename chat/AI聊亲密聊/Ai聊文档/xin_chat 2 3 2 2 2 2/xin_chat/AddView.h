//
//  AddView.h
//  WeiXinChar
//
//  Created by guan song on 15/11/21.
//  Copyright (c) 2015年 guan song. All rights reserved.
//相机相册视图

#import <UIKit/UIKit.h>
typedef void(^SendImgBlock)(NSInteger type);
@interface AddView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)UICollectionView *collectionView;//显示相机相册的视图
@property(nonatomic,strong)NSMutableArray *arrDatas;//cell数据数组
@property(nonatomic,strong)SendImgBlock  saveSendImgBlock;
/**
 *  点击加号的出现的视图
 *
 *  @param frame     大小
 *  @param sendImage 选择相机或相册回调的饿代码块
 *
 *  @return 返回视图对象
 */
-(instancetype)initWithFrame:(CGRect)frame  andSendImage:(SendImgBlock)sendImage;


@end
