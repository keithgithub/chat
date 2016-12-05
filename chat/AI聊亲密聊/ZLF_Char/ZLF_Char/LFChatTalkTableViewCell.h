//
//  LFChatTalkTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPMessageArchiving_Message_CoreDataObject, XMPPvCardTemp;
@interface LFChatTalkTableViewCell : UITableViewCell

@property (nonatomic, strong) XMPPvCardTemp *temp;

/**
 *  设置单元格
 *
 *  @param message 包含信息的消息coreData对象
 */
- (void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)message;
@end
