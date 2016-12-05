//
//  MoreTableViewController.m
//  xin_chat
//
//  Created by ibokan on 15/12/2.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "MoreTableViewController.h"
#import "WebViewController.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"生活助手";
    
    self.btn1.layer.cornerRadius = 5;
    self.btn1.layer.masksToBounds = YES;
    
    self.btn2.layer.cornerRadius = 5;
    self.btn2.layer.masksToBounds = YES;
    
    self.btn3.layer.cornerRadius = 5;
    self.btn3.layer.masksToBounds = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   WebViewController *webVC = [self.storyboard instantiateViewControllerWithIdentifier:@"webVC"];
    webVC.lbl = [UILabel new];
    if (indexPath.row == 1)
    {
        webVC.lbl.tag = 1;
    }
    if (indexPath.row == 3)
    {
        webVC.lbl.tag = 3;
    }
    if (indexPath.row == 5)
    {
        webVC.lbl.tag = 5;

    }
    
    [self.navigationController pushViewController:webVC animated:YES];
    
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
