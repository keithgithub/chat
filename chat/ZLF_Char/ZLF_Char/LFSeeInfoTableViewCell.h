//
//  LFSeeInfoTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFSeeInfoTableViewCell, XMPPvCardTemp, XMPPUserCoreDataStorageObject;

typedef void (^SeeInfoIconTapBlock)(LFSeeInfoTableViewCell *cell);
typedef void (^SeeInfoIconClickButtonBlock)(LFSeeInfoTableViewCell *cell, NSString *number);
@interface LFSeeInfoTableViewCell : UITableViewCell
@property (nonatomic, strong) SeeInfoIconTapBlock tapBlock;
@property (nonatomic, strong) SeeInfoIconClickButtonBlock callBlock;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *obj;
@property (nonatomic, strong) XMPPvCardTemp *temp;
@property (nonatomic, assign) BOOL isPay; // 是否付费
/**
 *  取消透明层
 */
- (void)transparentImageViewOver;

/**
 *  设置单元格
 */
- (void)setCell:(XMPPvCardTemp *)temp;

@end
