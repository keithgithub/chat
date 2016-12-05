//
//  LFLoginOnlyPasswordTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFLoginOnlyPasswordTableViewCell.h"
#import "LFConstant.h"

@interface LFLoginOnlyPasswordTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@end

@implementation LFLoginOnlyPasswordTableViewCell

- (void)setCell:(NSString *)iconName {
    // 设置圆角
    self.iconView.layer.cornerRadius = kCornerRadius;
    self.iconView.layer.masksToBounds = YES;
    
    self.loginButton.layer.cornerRadius = kCornerRadius;
    self.loginButton.layer.masksToBounds = YES;
}

/**
 *  登陆按钮点击
 */
- (IBAction)loginButton:(UIButton *)sender {
    NSLog(@"登陆!!!!");
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
