//
//  AddCollectionViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/21.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

-(void)setCell:(UIImage *)img;

@end
