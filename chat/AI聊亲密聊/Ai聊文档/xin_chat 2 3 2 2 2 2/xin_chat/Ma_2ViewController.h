//
//  Ma_2ViewController.h
//  xin_chat
//
//  Created by ibokan on 15/12/2.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
@interface Ma_2ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *QRView;
@property (weak, nonatomic) IBOutlet UIImageView *imgVQR;
@property (weak, nonatomic) IBOutlet UIImageView *imgVHead;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UIButton *btnQR;

- (IBAction)btnQRAction:(UIButton *)sender;

@end
