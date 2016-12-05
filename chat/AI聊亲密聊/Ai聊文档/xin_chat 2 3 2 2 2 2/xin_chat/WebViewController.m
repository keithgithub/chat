//
//  WebViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/2.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    NSString *str = [NSString new];
    if (self.lbl.tag == 1)
    {
        self.title = @"天气查询";
        // 天气
       str = @"http://baidu.weather.com.cn/mweather/101230201.shtml";
    }
    if (self.lbl.tag == 3)
    {
        self.title = @"股市行情";
     str = @"http://wap.eastmoney.com/Market.aspx?vt=1";
    }
    if (self.lbl.tag == 5)
    {
        self.title = @"新浪新闻";
       str = @"http://news.sina.cn/index1.d.html?refer=nc";
    }
    
    
    
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    
    [self.webVC loadRequest:request];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
