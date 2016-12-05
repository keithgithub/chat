//
//  LFMyImageTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/30.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMPPMessageArchiving_Message_CoreDataObject, XMPPvCardTemp;

@interface LFMyImageTableViewCell : UITableViewCell
@property (nonatomic, strong) XMPPvCardTemp *temp;
/**
 *  设置单元格
 *
 *  @param message 消息内容
 */
- (void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)message;
@end
