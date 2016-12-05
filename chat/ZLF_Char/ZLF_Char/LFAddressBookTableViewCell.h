//
//  LFAddressBookTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject, XMPPvCardTemp;

@interface LFAddressBookTableViewCell : UITableViewCell
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *user;
/**
 *  设置单元格
 *
 *  @param user 用户信息管理类
 */
- (void)setCell:(XMPPvCardTemp *)user;
@end
