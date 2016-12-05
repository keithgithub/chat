//
//  NSString+LabelHight.h
//  Ui6-2
//
//  Created by ibokan on 15/6/1.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (LabelHight)
/**
 *  计算文本高度方法
 *
 *  @param text     要计算的文本内容
 *  @param w        要显示的控件的宽度
 *  @param fontsize 控件显示文本的字体大小
 *
 *  @return 返回计算的文本占用位置的大小（含宽，高）
 */
+(CGSize)calStrSize:(NSString *)text andWidth:(CGFloat)w andFontSize:(CGFloat)fontsize;
@end
