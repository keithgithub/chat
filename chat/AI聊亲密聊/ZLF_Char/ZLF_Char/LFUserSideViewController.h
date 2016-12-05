//
//  LFUserSideViewController.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LFUserSideViewController, LFQcodeViewController;
@protocol UserSideViewControllerDelegate <NSObject>

- (void)userSideViewControllerDidClickOtherView:(LFUserSideViewController *)sender;

/**
 *  查看用户详细信息
 */
- (void)userSideViewControllerDidClickUserInfo:(LFUserSideViewController *)sender;

/**
 *  查看用户二维码
 */
- (void)userSideViewControllerDidClickQcodeView:(LFUserSideViewController *)sender;
@end

@interface LFUserSideViewController : UIViewController
@property (nonatomic, assign) id <UserSideViewControllerDelegate> delegate;
@end
