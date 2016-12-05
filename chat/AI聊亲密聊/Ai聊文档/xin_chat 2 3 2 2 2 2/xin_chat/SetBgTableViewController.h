//
//  SetBgTableViewController.h
//  xin_chat
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  SetBgTableViewControllerDelegate<NSObject>

- (void)setBG:(UIImage *)img;

@end

@interface SetBgTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *txtName;

@property (nonatomic,strong) UILabel *friendName;

@property (nonatomic,assign) id<SetBgTableViewControllerDelegate> delegate;

- (IBAction)btnSetBg:(UIButton *)sender;

@end
