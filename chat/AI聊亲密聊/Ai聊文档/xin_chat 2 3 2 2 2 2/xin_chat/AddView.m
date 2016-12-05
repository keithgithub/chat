
//
//  AddView.m
//  WeiXinChar
//
//  Created by guan song on 15/11/21.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "AddView.h"
#import "AddCollectionViewCell.h"
@implementation AddView

-(instancetype)initWithFrame:(CGRect)frame andSendImage:(SendImgBlock)sendImage
{
    if (self=[super  initWithFrame:frame])
    {
        
        self.saveSendImgBlock=sendImage;//保存代码块，选中表格要调用
        //九宫格相关设置
        UICollectionViewFlowLayout  *layout=[[UICollectionViewFlowLayout  alloc]init];
        self.collectionView=[[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        //获取数据源
        [self  getDatas];
        //注册nib
        UINib  *nib=[UINib  nibWithNibName:@"AddCollectionViewCell" bundle:nil];
        [self.collectionView  registerNib:nib forCellWithReuseIdentifier:@"addCell"];
        
        self.collectionView.backgroundColor=[UIColor colorWithWhite:0.960 alpha:1.000];
        
        self.collectionView.delegate=self;
        self.collectionView.dataSource=self;
        
        [self addSubview:self.collectionView];
        
        
        
    }
    return self;
}
/**
 *  获取cell的图片数组
 */
-(void)getDatas
{
    self.arrDatas=[NSMutableArray  new];
    UIImage *imgCamera=[UIImage  imageNamed:@"tabbar_compose_camera.png"];//相机
    UIImage *imgPhoto=[UIImage  imageNamed:@"tabbar_compose_photo.png"];//相册
    //若有新功能按钮往这里添加
    [self.arrDatas  addObject:imgCamera];
    [self.arrDatas  addObject:imgPhoto];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrDatas.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddCollectionViewCell *cell=[collectionView  dequeueReusableCellWithReuseIdentifier:@"addCell" forIndexPath:indexPath];
    [cell  setCell:self.arrDatas[indexPath.item]];
    return cell;
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 60);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //屏幕宽
    CGFloat  screen_w=[UIScreen mainScreen].bounds.size.width;
    //九宫格视图的高
    CGFloat  collectionView_h=self.collectionView.frame.size.height;
    //九宫格的视图高度为120。cell大小：60*60
    //判断功能按钮是1行还是两行
    if (self.arrDatas.count>4)//>4&&<=8两排，>8要考虑翻页，这里没实现
    {
        //3：代表两行有3个间隙，60：是cell的高，5：4列5个间隙，4：4列，2：两行
        return UIEdgeInsetsMake((collectionView_h-60*2)/3, (screen_w-60*4)/5, (collectionView_h-60*2)/3, (screen_w-60*4)/5);
    }
    else//<=4：一排
    {
       
       return UIEdgeInsetsMake((collectionView_h-60)/2, (screen_w-60*self.arrDatas.count)/(self.arrDatas.count+0.5), (collectionView_h-60)/2, (screen_w-60*self.arrDatas.count)/(self.arrDatas.count+0.5));
    }
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.saveSendImgBlock(indexPath.item);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
