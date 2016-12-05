//
//  LFProfileTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMPPUserCoreDataStorageObject;
@class LFProfileTableViewCell;
// 代码块声明
typedef void(^IconViewClckBlock)(LFProfileTableViewCell *cell);

@interface LFProfileTableViewCell : UITableViewCell
@property (nonatomic, strong) IconViewClckBlock iconViewClckBlock; // 头像点击回调代码块
@property (weak, nonatomic) IBOutlet UIImageView *iconView; // 头像视图

- (void)setCell;

@end
