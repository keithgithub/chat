//
//  LFAddressBookTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFAddressBookTableViewCell.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "LFXMPPHelp.h"
#import "XMPPvCardTemp.h"
#import "LFConstant.h"
#import "UIImage+Extension.h"

@interface LFAddressBookTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *intimacyLabel;
// 透明层
@property (weak, nonatomic) IBOutlet UIImageView *transparentImageView;

@end

@implementation LFAddressBookTableViewCell

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    // 设置白色圆圈
    self.iconView.layer.borderWidth = 2;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    // 设置头像背景圆角
    self.bgImageView.layer.cornerRadius = self.bgImageView.frame.size.width * 0.5;
    self.bgImageView.layer.masksToBounds = YES;
    
    //transparentImageView
    self.transparentImageView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.transparentImageView.layer.masksToBounds = YES;
}

- (void)setCell:(XMPPvCardTemp *)user {
    
//    XMPPvCardTemp *temp = [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule vCardTempForJID:[[LFXMPPHelp shareXMPPHelp] xmppGetJibWithName:str] shouldFetch:YES];
    // 如果是离线的状态
    if (self.user.section == 2) {
        // 隐藏光晕
        self.bgImageView.hidden = YES;
    } else {
        // 隐藏光晕
        self.bgImageView.hidden = NO;
    }
    
    NSString *intimacy = nil;
    if (self.user.jidStr) {
        intimacy = [LFUserInfo getFriendIntimacy:self.user.jidStr];
        
        // 设置亲密度文本
        self.intimacyLabel.text = [NSString stringWithFormat:@"%@%%", intimacy];
    }
    
    if (user.photo) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:user.photo];
//            image = [UIImage imageApplyBlurRadius:10 toImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.iconView.image = image;
            });
        });
//        self.iconView.image = [UIImage imageApplyBlurRadius:[intimacy intValue]/20.0 toImage:image];
        
//        self.iconView.image = [UIImage imageWithData:user.photo];
    }
    if (user.nickname) {
        self.nameLabel.text = user.nickname;
    } else {
        self.nameLabel.text = @"匿名用户";
    }
    
    // 如果性别为女
    if ([user.role isEqualToString:@"女"]) {
        // 设置光晕背景
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
        // 设置名字颜色
        self.nameLabel.textColor = kGirlColor;
    } else {
        self.bgImageView.image = [UIImage imageNamed:@"halo2"];
        // 设置名字颜色
        self.nameLabel.textColor = kBoyColor;
    }
    
    // 设置透明层的透明度
    self.transparentImageView.alpha = 0.9 - [intimacy intValue] / 100.0;
   
    
    /*
     myvCardTemp.formattedName = self.addressTextField.text;
     myvCardTemp.familyName = self.addressTextField.text;
     myvCardTemp.givenName = self.addressTextField.text;
     
     myvCardTemp.labels = @[self.addressTextField.text];
     myvCardTemp.emailAddresses = @[self.addressTextField.text];
     myvCardTemp.telecomsAddresses = @[self.addressTextField.text];
     */
//    NSLog(@"%@", user.formattedName); 可用
//    NSLog(@"%@", user.familyName); 可用
//    NSLog(@"%@", user.givenName);
    
//    NSLog(@"%@", user.orgUnits); // 可用
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
