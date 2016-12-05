//
//  FriendRequestTableViewCell.m
//  WeiXinChar
//
//  Created by guan song on 15/11/27.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "FriendRequestTableViewCell.h"
#import "TimeModel.h"

@implementation FriendRequestTableViewCell
-(void)setCell:(NSString *)friendName
{
    self.lblTimer.text=[TimeModel  getMonthDate];
    self.lblFriendName.text=[NSString  stringWithFormat:@"%@ 请求互粉",friendName];
}
- (void)awakeFromNib
{
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
