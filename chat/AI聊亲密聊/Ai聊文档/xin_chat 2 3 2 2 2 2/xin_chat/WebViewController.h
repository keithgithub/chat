//
//  WebViewController.h
//  xin_chat
//
//  Created by ibokan on 15/12/2.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *webVC;

// 标记网址的使用
@property (nonatomic,strong) UILabel *lbl;


@end
