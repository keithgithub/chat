//
//  LFSeeInfoTableViewCell.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/27.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFSeeInfoTableViewCell.h"
#import "MyAlertClass.h"
#import "UIImage+Extension.h"
#import "XMPPvCardTemp.h"
#import "XMPPUserCoreDataStorageObject.h"
#import "LFUserInfo.h"
#import "EnlargeImage.h"
#import "LFConstant.h"

@interface LFSeeInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *transparentImageView;
@property (weak, nonatomic) IBOutlet UILabel *intimacyLabel;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (nonatomic, strong) UILabel *phoneLabel; // 电话号码
@property (nonatomic, strong) UIImageView *heartImageView; // 爱心图片
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@end

@implementation LFSeeInfoTableViewCell
- (IBAction)callButtonClick:(UIButton *)sender {
    self.callBlock(self, self.phoneLabel.text);
}

- (void)transparentImageViewOver {
    // 完全透明
    self.transparentImageView.alpha = 0;
}

- (void)setCell:(XMPPvCardTemp *)temp {
    self.temp = temp;
    
    if (temp.nickname) {
        // 设置名称
        self.nameLabel.text = temp.nickname;
    }
    
    if (temp.photo) {
        // 设置头像
        self.iconView.image = [UIImage imageWithData:temp.photo];
    }
    
    if (temp.familyName) {
        // 设置城市
        self.cityLabel.text = temp.familyName;
    }
    
    // 亲密度
    NSString *intimacy = nil;
    // 如果有姓名
    if (self.obj.jidStr) {
        // 获取亲密度
        intimacy = [LFUserInfo getFriendIntimacy:self.obj.jidStr];
    }
    self.intimacyLabel.text = [NSString stringWithFormat:@"亲密度%@%%", intimacy];
    // 设置透明层的透明度
    self.transparentImageView.alpha = 0.9 - [intimacy intValue] / 100.0;
    
    // 如果性别为女
    if ([temp.role isEqualToString:@"女"]) {
        self.bgImageView.image = [UIImage imageNamed:@"halo1"];
        self.sexImageView.image = [UIImage imageNamed:@"girl"];
        self.nameLabel.textColor = kGirlColor;
    }
    
    if ([self.temp.role isEqualToString:@"女"]) { // 如果性别为女
        self.heartImageView.image = [UIImage imageNamed:@"yuyin_nv"];
    } else {
        self.heartImageView.image = [UIImage imageNamed:@"yuyin_nan"];
    }
    
    // 设置电话
    if (temp.note) {
        // 显示爱心
        self.heartImageView.hidden = NO;
        // 亲密度换算距离
        int intimacyChange = [intimacy intValue] / 10.0;
        // 更改爱心位置
        CGRect tempFrame = self.heartImageView.frame;
        tempFrame.origin.x = 5 + intimacyChange * 7.4;
        self.heartImageView.frame = tempFrame;
        
        // 根据亲密度截取文本
        int count = 1 + intimacyChange;
        if (count >= temp.note.length) {
            count = temp.note.length;
            // 显示拨打按钮
            self.callButton.hidden = NO;
        } else {
            // 隐藏拨打按钮
            self.callButton.hidden = YES;
        }
        // 设置文本
        NSString *tempText = [temp.note substringWithRange:NSMakeRange(0, count)];
        self.phoneLabel.text = tempText;
    } else {
        // 隐藏爱心
        self.heartImageView.hidden = YES;
    }
}

- (void)awakeFromNib {
    // 设置头像圆角
    self.iconView.layer.cornerRadius = self.iconView.frame.size.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconView.layer.borderWidth = 2;
    
    // 设置头像背景圆角
    self.bgImageView.layer.cornerRadius = self.bgImageView.frame.size.width * 0.5;
    self.bgImageView.layer.masksToBounds = YES;
    
    // 创建轻拍手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(iconViewClick)];
    // 开启用户交互
    self.iconView.userInteractionEnabled = YES;
    [self.iconView addGestureRecognizer:tap];
    
    // 设置透明层圆角
    self.transparentImageView.layer.cornerRadius = self.transparentImageView.frame.size.width * 0.5;
    self.transparentImageView.layer.masksToBounds = YES;
    
    // 设置拨打按钮圆角和边框
    self.callButton.layer.cornerRadius = 5;
    self.callButton.layer.masksToBounds = YES;
    self.callButton.layer.borderColor = [UIColor whiteColor].CGColor;
    self.callButton.layer.borderWidth = 2;
    
    // 创建电话视图
    [self createPhoneView];
}

/**
 *  创建电话视图
 */
- (void)createPhoneView {
    // 创建对象
    self.phoneLabel = [[UILabel alloc] initWithFrame:self.phoneView.bounds];
    // 设置文本
    self.phoneLabel.text = @"该用户没有设置电话";
    // 设置字体
    self.phoneLabel.font = [UIFont systemFontOfSize:13.0f];
    self.phoneLabel.textColor = [UIColor whiteColor];
    // 加入视图
    [self.phoneView addSubview:self.phoneLabel];
    
    // 创建对象
    self.heartImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, self.phoneView.bounds.size.height, self.phoneView.bounds.size.height)];
    
    // 加入视图
    [self.phoneView addSubview:self.heartImageView];
}



/**
 *  头像点击事件
 */
- (void)iconViewClick {
    // 亲密度
    NSString *intimacy = nil;
    // 如果有姓名
    if (self.obj.jidStr) {
        // 获取亲密度
        intimacy = [LFUserInfo getFriendIntimacy:self.obj.jidStr];
    }
    // 如果亲密度为100是否已付钱
    if ([intimacy isEqualToString:@"100"] || self.isPay) {
        // 放大图片
        [EnlargeImage showImage:self.iconView];
    } else {
        self.tapBlock(self);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
