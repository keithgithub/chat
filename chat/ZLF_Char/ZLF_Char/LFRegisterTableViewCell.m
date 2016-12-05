//
//  LFRegisterTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFRegisterTableViewCell.h"
#import "LFConstant.h"

@interface LFRegisterTableViewCell()
@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@end

@implementation LFRegisterTableViewCell

- (void)awakeFromNib {
    // 设置圆角
    self.registerButton.layer.cornerRadius = kCornerRadius;
    self.registerButton.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
