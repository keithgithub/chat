//
//  LFOtherSpeakTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAudioPlayer, XMPPvCardTemp, XMPPMessageArchiving_Message_CoreDataObject;
@interface LFOtherSpeakTableViewCell : UITableViewCell
@property (nonatomic, strong) XMPPvCardTemp *temp;
@property (nonatomic, strong) XMPPMessageArchiving_Message_CoreDataObject *obj;
/**
 *  设置单元格
 *
 *  @param player 音频对象
 *  @param time   发布时间
 */
- (void)setCell:(AVAudioPlayer *)player andTime:(NSString *)time;
@end
