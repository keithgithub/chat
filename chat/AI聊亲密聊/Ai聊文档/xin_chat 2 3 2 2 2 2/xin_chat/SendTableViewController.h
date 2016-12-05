//
//  SendTableViewController.h
//  xin_chat
//
//  Created by ibokan on 15/12/3.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendTableViewController : UITableViewController

// 转发的图片
@property (nonatomic,strong) UIImage *img;
// 转发的文本
@property (nonatomic,strong) UILabel *textMsg;
// 转发文件类型  yes 图  no 文本
@property (nonatomic,assign) BOOL imgOrText;

@end
