//
//  FriendesListViewController.h
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"


@interface FriendesListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

// 表视图
@property (nonatomic,strong) UITableView *tableView;

@end
