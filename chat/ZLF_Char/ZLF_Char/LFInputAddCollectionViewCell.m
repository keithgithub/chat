//
//  LFInputAddCollectionViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/30.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFInputAddCollectionViewCell.h"

@interface LFInputAddCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation LFInputAddCollectionViewCell

- (void)setCell:(NSString *)name andImageName:(NSString *)imageName {
    // 设置图片
    self.iconView.image = [UIImage imageNamed:imageName];
    // 设置文本
    self.nameLabel.text = name;
}

- (void)awakeFromNib {
    // Initialization code
}

@end
