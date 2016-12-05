//
//  MyAlertClass.m
//  AlertControllerProject
//
//  Created by guan song on 15/11/2.
//  Copyright (c) 2015年 guan song. All rights reserved.
//

#import "MyAlertClass.h"

@implementation MyAlertClass


+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionCancleTitle:(NSString *)actionTitle
{
    //创建警告框对象
    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //创建一个action按钮
    UIAlertAction *actionCancle=[UIAlertAction  actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //点击改按钮消失（一般是取消）
        [alertC  dismissViewControllerAnimated:YES completion:nil];
        
    }];
    //添加按钮
    [alertC  addAction:actionCancle];
    //返回警告框对象
    return alertC;
    
}

+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle alertActionSubmitTitle:(NSString *)sumbitTitle alertAtionCancleTitle:(NSString *)cancleTitle andHander:(MyBlock)submit
{
    //创建警告框对象
    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //创建一个action按钮
    UIAlertAction *actionCancle=[UIAlertAction  actionWithTitle:cancleTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
         //点击改按钮消失（一般是取消）
        [alertC  dismissViewControllerAnimated:YES completion:nil];
        
    }];
     //创建一个action按钮
    UIAlertAction *actionSubmit=[UIAlertAction  actionWithTitle:sumbitTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        submit();//点击第二个按钮回调的代码块（一般是确认）
        
    }];
    //添加按钮
    [alertC  addAction:actionCancle];
    //添加按钮
    [alertC  addAction:actionSubmit];//添加第二个按钮（先后顺序添加有关）
    
    return alertC;

}
+(UIAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    UIAlertController *alertC=[UIAlertController  alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    //延时一秒后调用dismissDelayOneSecond方法（此时self只能调用类方法）
    [self  performSelector:@selector(dismissDelayOneSecond:) withObject:alertC afterDelay:1];
    
    return alertC;
}
/**
 *  一秒后 alertC 消失
 *
 *  @param alertC alertC对象
 */
+(void)dismissDelayOneSecond:(UIAlertController *)alertC
{
    [alertC dismissViewControllerAnimated:YES completion:nil];
}

+(UIAlertController *)alertControllerWithTitle:(NSString *)title1 andTitle2:(NSString *)title2 andHander1:(MyBlock)submit1 andHander2:(MyBlock)submit2
{
    UIAlertController *alertC = [[UIAlertController alloc] init];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:title1 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        submit1();
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:title2 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        submit2();
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:action1];
    [alertC addAction:action2];
    [alertC addAction:action3];
    return alertC;
}

@end
