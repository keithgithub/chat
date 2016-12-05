//
//  LFSideTableViewCell.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFSideTableViewCell;

typedef void(^ClickBlock)(LFSideTableViewCell *cell);

@interface LFSideTableViewCell : UITableViewCell

@property (nonatomic, strong) ClickBlock clickBlock;

/**
 *  设置单元格标题和点击回调代码块
 *
 *  @param title      标题
 *  @param clickBlock 回调代码块
 */
- (void)setCellWithTitle:(NSString *)title andClickBlock:(ClickBlock)clickBlock;

@end
