//
//  LFChatTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPvCardTemp, XMPPUserCoreDataStorageObject;
@interface LFChatTableViewCell : UITableViewCell
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *myUser; // 存储基本信息

- (void)setCell:(XMPPvCardTemp *)user andName:(NSString *)name;
@end
