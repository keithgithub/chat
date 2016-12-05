//
//  FriendMsgTableViewCell.h
//  WeiXinChar
//
//  Created by guan song on 15/11/28.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPHelp+Message.h"
@interface FriendMsgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgHead;

@property (weak, nonatomic) IBOutlet UILabel *lblMsgCount;//消息条数，大于10就用...表示
@property (weak, nonatomic) IBOutlet UILabel *lblFriendName;

@property (weak, nonatomic) IBOutlet UILabel *lblMsg;//最后一条消息
@property (weak, nonatomic) IBOutlet UILabel *lblTime;

@property (nonatomic,assign) int msgCount;

//试用，没有头像
-(void)setCellMsg:(XMPPMessage *)message andCount:(NSString*)count;

//试用，没有头像
-(void)setCellMsg:(NSDictionary *)dic;


@end
