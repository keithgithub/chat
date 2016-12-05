//
//  LeftImgTableViewCell.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import "CommonTableViewCell.h"

@protocol   LeftImgTableViewCellDelegate<NSObject>

- (void)sendLeftImg:(UIImage*)img;

@end



@interface LeftImgTableViewCell : CommonTableViewCell

@property (nonatomic,assign) id<LeftImgTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

//-(void)setCell:(NSDictionary *)dic;
@end
