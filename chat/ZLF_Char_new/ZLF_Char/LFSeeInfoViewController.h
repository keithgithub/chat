//
//  LFSeeInfoViewController.h
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LFSeeInfoViewController, XMPPvCardTemp, XMPPUserCoreDataStorageObject;

typedef void(^TalkButtonClickBlock)(LFSeeInfoViewController *);
@interface LFSeeInfoViewController : UIViewController
@property (nonatomic, strong) TalkButtonClickBlock talkBlock;
@property (nonatomic, strong) XMPPvCardTemp *temp;
@property (nonatomic, strong) XMPPUserCoreDataStorageObject *obj; // 用户基本信息

- (void)setTalkButton;
@end
