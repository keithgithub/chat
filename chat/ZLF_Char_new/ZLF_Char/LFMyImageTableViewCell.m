//
//  LFMyImageTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/30.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFMyImageTableViewCell.h"
#import "XMPPMessageArchiving_Message_CoreDataObject.h"
#import "NSDate+LFExtension.h"
#import "XMPPvCardTemp.h"
#import "EnlargeImage.h"

@interface LFMyImageTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconBgimage;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sendImageView;

@end

@implementation LFMyImageTableViewCell

- (void)setCell:(XMPPMessageArchiving_Message_CoreDataObject *)message {
    // 设置时间
    self.timeLabel.text = [NSDate getMsgDate:message.timestamp];
    
    // 从消息读取图片二进制
    NSData *imgData = [[NSData alloc] initWithBase64EncodedString:message.body options:NSDataBase64DecodingIgnoreUnknownCharacters];
    // 设置图片
    self.sendImageView.image = [UIImage imageWithData:imgData];
    
    // 创建手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
    // 开启用户交互
    self.sendImageView.userInteractionEnabled = YES;
    // 添加手势
    [self.sendImageView addGestureRecognizer:tap];
    
    // 如果用户有头像
    if (self.temp.photo) {
        self.iconView.image = [UIImage imageWithData:self.temp.photo];
    }
    
    // 如果性别为女
    if ([self.temp.role isEqualToString:@"女"]) {
        // 更换背景光晕
        self.iconBgimage.image = [UIImage imageNamed:@"halo1"];
    } else {
        self.iconBgimage.image = [UIImage imageNamed:@"halo2"];
    }
}

/**
 *  图片点击变大
 */
- (void)imageClick {
    [EnlargeImage showImage:self.sendImageView];
}

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    // 设置白色圆圈
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置头像背景圆角
    self.iconBgimage.layer.cornerRadius = self.iconBgimage.frame.size.width * 0.5;
    self.iconBgimage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
