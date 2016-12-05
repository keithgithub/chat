//
//  HelpTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/13.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "HelpTableViewController.h"
#import "HelpDetailTableViewController.h"


@interface HelpTableViewController ()

@end

@implementation HelpTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"帮助文档";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str1 = @"Ai聊是一款免费的手机聊天软件，可发送语音、图片和文字，并且无任何广告信息，帮助您与同学，朋友，家人及时沟通，希望Ai聊能给您的生活带来愉快";
    NSString *str2 = @"消息记录是存储在本地的，如果您更换了手机，消息记录就无法显示了，希望能帮到您。";
    NSString *str3 = @"设置好友备注，点击右侧保存就设置完成了。好友备注是存储在本地的，如果您更换了手机，好友备注就无法显示了，希望能帮到您。";
    NSString *str4 = @"点击背景后就直接为你设置了背景图片，背景图片存储在您的手机，如果您跟换了手机，背景图就变为默认背景。希望能帮到您。";
    NSString *str5 = @"如果您出现左侧菜单不显示头像问题，是因为网络加载问题，只要您切换到另外界面，在切换到左侧菜单就可以显示正常了，希望能帮到您。";
    
    HelpDetailTableViewController *helpDetailVC = [HelpDetailTableViewController new];
    
    helpDetailVC.img = [UIImage new];
    helpDetailVC.title = @"帮助";
    
    switch (indexPath.row)
    {
        case 0: helpDetailVC.txt = str1;break;
        case 1: helpDetailVC.txt = str2; break;
        case 2: helpDetailVC.txt = str3; break;
        case 3: helpDetailVC.txt = str4; break;
        case 4: helpDetailVC.txt = str5; break;
        default:
            break;
    }
    
    [self.navigationController pushViewController:helpDetailVC animated:YES];
 
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}





/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
