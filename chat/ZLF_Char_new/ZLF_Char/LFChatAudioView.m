//
//  LFChatAudioView.m
//  ZLF_Char
//
//  Created by 郑卢峰 on 15/11/29.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFChatAudioView.h"

@interface LFChatAudioView()
@property (nonatomic, strong) UIImageView *iconView;
@end

@implementation LFChatAudioView

/**
 *  重写初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置背景颜色
        self.backgroundColor = [UIColor colorWithRed:0.059 green:0.063 blue:0.106 alpha:0.390];
        // 创建录音按钮
        [self createAudioButton];
    }
    
    return self;
}

/**
 *  创建录音按钮
 */
- (void)createAudioButton {
    // 创建对象
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    // 设置中心点
    self.iconView.center = self.center;
    // 设置图片
//    imageView.image = [UIImage imageNamed:@"voice_1"];
    
    
    // 定义数组
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    // 循环创建图片对象
    for (int  i = 1; i < 8; i++) {
        NSString *imageName = [NSString stringWithFormat:@"voice_%d", i];
//        NSBundle *bunle = [NSBundle mainBundle];
//        NSString *path = [bunle pathForResource:imageName ofType:nil];
//        UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
        UIImage *image = [UIImage imageNamed:imageName];
        [arr addObject:image];
    }
    // 设置动画图片数组
    self.iconView.animationImages = arr;
    // 设置播放次数
//    self.iconView.animationRepeatCount = 1;
    // 设置播放时间
    self.iconView.animationDuration = 8 * 0.5;
    // 开始动画
    [self.iconView startAnimating];
    
    // 加入视图
    [self addSubview:self.iconView];
}

- (void)stopAnimating {
    // 停止动画
    [self.iconView stopAnimating];
}

@end







