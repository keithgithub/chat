//
//  LFSideTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/26.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFSideTableViewCell.h"

@interface LFSideTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LFSideTableViewCell

- (void)setCellWithTitle:(NSString *)title andClickBlock:(ClickBlock)clickBlock {
    self.clickBlock = clickBlock;
    self.titleLabel.text = title;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
  
    // Configure the view for the selected state
}

@end
