//
//  MyAlertClass.h
//  AlertControllerProject
//
//  Created by guan song on 15/11/2.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^MyBlock)();

@interface MyAlertClass : NSObject
/**
 *  创建一个按钮的提示框
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param preferredStyle 提示框的风格
 *  @param actionTitle    按钮标题
 *
 *  @return 返回alertController对象
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionCancleTitle:(NSString *)actionTitle;

/**
 *  创建2个按钮的提示框
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param preferredStyle 提示框的风格
 *  @param sumbitTitle    后一个按钮的标题
 *  @param cancleTitle    前一个按钮的标题
 *  @param submit         后一个按钮点击回调的代码块
 *
 *  @return 返回alertController对象
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionSubmitTitle:(NSString *)sumbitTitle  alertAtionCancleTitle:(NSString *)cancleTitle  andHander:(MyBlock)submit;

/**
 *  创建3个按钮的提示框
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param preferredStyle 提示框的风格
 *  @param sumbitTitle    后一个按钮的标题
 *  @param cancleTitle    前一个按钮的标题
 *  @param submit         后一个按钮点击回调的代码块
 *
 *  @return 返回alertController对象
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionSubmitTitle:(NSString *)sumbitTitle alertAtionOtherTitle:(NSString *)otherTitle alertAtionCancleTitle:(NSString *)cancleTitle  andHander:(MyBlock)submit andOther:(MyBlock)other;

/**
 *  创建提示框一秒钟消失
 *
 *  @param title          提示标题
 *  @param message        提示信息
 *  @param preferredStyle 提示框的风格
 *
 *  @return 返回alertController对象
 */
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle;

@end
