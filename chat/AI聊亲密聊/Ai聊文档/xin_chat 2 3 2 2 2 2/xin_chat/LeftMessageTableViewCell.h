//
//  LeftMessageTableViewCell.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import "CommonTableViewCell.h"

@protocol LeftMessageTableViewCellDelegae <NSObject>

- (void)sendLeftText:(NSString*)text;

@end



@interface LeftMessageTableViewCell : CommonTableViewCell

@property (nonatomic,assign) id<LeftMessageTableViewCellDelegae> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnTime;

//-(void)setCell:(NSDictionary *)dic;


@end
