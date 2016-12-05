//
//  FriendesListTableViewCell.h
//  xin_chat
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPFramework.h"


@interface FriendesListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblState;
@property (weak, nonatomic) IBOutlet UIImageView *imgVHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblCount;

@property (nonatomic,assign) BOOL isOnLine;


-(void)setCell:(XMPPUserCoreDataStorageObject *)obj  andFriendvCad:(XMPPvCardTemp *)vCad andCountDic:(NSMutableDictionary*)dic;

@end
