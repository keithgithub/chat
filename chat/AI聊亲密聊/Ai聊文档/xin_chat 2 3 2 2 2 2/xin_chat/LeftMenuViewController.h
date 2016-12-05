//
//  LeftMenuViewController.h
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface LeftMenuViewController : UIViewController
@property (nonatomic,strong) UIImage *imgHead;
@property (nonatomic,strong) UILabel *lblName;
@property (nonatomic,strong) UILabel *lblSay;

@property (nonatomic,assign) BOOL img_isyes;
@property (nonatomic,assign) BOOL name_isyes;
@property (nonatomic,assign) BOOL say_isyes;

@property (nonatomic,strong) UITableView *tableView;
@end
