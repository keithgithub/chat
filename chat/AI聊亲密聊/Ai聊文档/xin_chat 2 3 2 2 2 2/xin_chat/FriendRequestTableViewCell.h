//
//  FriendRequestTableViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/27.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendRequestTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTimer;
@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVHead;

-(void)setCell:(NSString *)friendName;


@end
