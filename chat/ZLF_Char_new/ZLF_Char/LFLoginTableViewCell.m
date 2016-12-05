//
//  LFLoginTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFLoginTableViewCell.h"
#import "LFConstant.h"

@interface LFLoginTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *txtUsername;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@end

@implementation LFLoginTableViewCell
- (IBAction)loginButtonClick:(UIButton *)sender {
    NSLog(@"登陆!!!!");
}

- (void)awakeFromNib {
    // 设置圆角
    self.loginButton.layer.cornerRadius = kCornerRadius;
    self.loginButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
