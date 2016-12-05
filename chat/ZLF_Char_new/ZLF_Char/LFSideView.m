//
//  LFSideView.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/28.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "LFSideView.h"
#import "LFConstant.h"

@interface LFSideView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *shadeView;
@end

@implementation LFSideView

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (_tableView == nil) {
        // 创建对象
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 150, self.shadeView.frame.size.height - 125) style:UITableViewStylePlain];
        //        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width - 150, 30, 150, self.frame.size.height - 125) style:UITableViewStylePlain];
        // 设置背景颜色
        //        _tableView.backgroundColor = [UIColor colorWithRed:0.424 green:0.173 blue:0.576 alpha:1.000];
        
        _tableView.backgroundColor = [UIColor redColor];
        
        // 设置代理
        _tableView.delegate = self;
        _tableView.dataSource = self;
        // 加入对象
        //        [self.shadeView addSubview:_tableView];
        [self.shadeView addSubview:_tableView];
    }
    
    return _tableView;
}

// 重写初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 设置背景颜色
        //        self.backgroundColor = [UIColor colorWithWhite:0.757 alpha:0.2];
        self.backgroundColor = [UIColor clearColor];
        
        // 创建遮罩层
        [self createShadeView];
        //        [self tableView];
        // 设置分割线
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return self;
}

// 创建遮罩层
- (void)createShadeView {
    CGFloat width = 150;
    // 创建对象
    self.shadeView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW - width, 0, width, kScreenH - 40)];
    // 设置背景颜色
    //    self.shadeView.backgroundColor = [UIColor colorWithRed:0.922 green:0.922 blue:0.945 alpha:1.000];
    self.shadeView.backgroundColor = [UIColor clearColor];
    
    // 加入对象
    [self addSubview:self.shadeView];
}

#pragma mark 设置每组几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return self.dataModel.count;
    return 4;
}

#pragma mark 设置单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 定义重复标识
    static NSString *ID = @"Cell";
    // 从队列获取可重用单元格
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    // 创建对象
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    // 获得对应数据
//    NSDictionary *dict = self.dataModel[indexPath.row];
//    // 设置文本
//    cell.textLabel.text = dict[@"name"];
    cell.textLabel.textColor = [UIColor whiteColor];
    // 设置背景颜色
    //    cell.backgroundColor = [UIColor colorWithRed:0.416 green:0.169 blue:0.569 alpha:1.000];
    cell.backgroundColor = [UIColor clearColor];
    // 设置选中状态
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark 屏幕点击事件
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    // 获取点击对象
//    UITouch *t = [touches anyObject];
//    if ([t.view isKindOfClass:[UIView class]]) { // 如果是屏幕其它view
//        // 隐藏
//        //        self.hidden = YES;
//        [self.delegate sideViewBack:self];
//    }
//}

#pragma mark 设置选中单元格
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"aaa");
    // 隐藏界面
    //    self.hidden = YES;
    // 取出对应的数据
//    NSDictionary *dict = self.dataModel[indexPath.row];
//    [self.delegate sideViewPOST:[dict[@"id"] integerValue]];
}

@end
