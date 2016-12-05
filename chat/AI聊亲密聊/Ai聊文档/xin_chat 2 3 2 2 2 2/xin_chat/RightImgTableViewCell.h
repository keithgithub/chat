//
//  RightImgTableViewCell.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import "CommonTableViewCell.h"

@protocol RightImgTableViewCellDelegate<NSObject>

- (void)sendRightImg:(UIImage*)img;

@end

@interface RightImgTableViewCell : CommonTableViewCell

@property (nonatomic,assign) id<RightImgTableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgMsg;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;




//-(void)setCell:(NSDictionary *)dic;
@end
