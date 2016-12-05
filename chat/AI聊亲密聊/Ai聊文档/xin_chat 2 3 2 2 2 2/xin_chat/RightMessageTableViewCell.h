//
//  RightMessageTableViewCell.h
//  PengLaiYoujv
//
//  Created by guan song on 15/8/13.
//  Copyright (c) 2015年 guan song. All rights reserved.
//


#import "CommonTableViewCell.h"

@protocol RightMessageTableViewCellDelegae <NSObject>

- (void)sendRightText:(NSString*)text;

@end

@interface RightMessageTableViewCell : CommonTableViewCell

@property (nonatomic,assign) id<RightMessageTableViewCellDelegae> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (weak, nonatomic) IBOutlet UIButton *btnTime;


//-(void)setCell:(NSDictionary *)dic;
@end
