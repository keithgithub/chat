//
//  LFMySpeakTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVAudioPlayer, XMPPvCardTemp;
@interface LFMySpeakTableViewCell : UITableViewCell
@property (nonatomic, strong) XMPPvCardTemp *temp;
/**
 *  设置单元格
 */
- (void)setCell:(AVAudioPlayer *)player andTime:(NSString *)time;
@end
