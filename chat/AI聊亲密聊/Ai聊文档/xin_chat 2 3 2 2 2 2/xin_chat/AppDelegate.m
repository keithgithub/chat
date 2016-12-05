//
//  AppDelegate.m
//  xin_chat
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 ibokan. All rights reserved.
//

#import "AppDelegate.h"
#import "SDWebImageManager.h"
#import "RootViewController.h"
#import "UserInfo.h"
#import "XMPPHelp.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   
//     [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert];
    //注册应用接收通知
    if ([[UIDevice currentDevice].systemVersion doubleValue] > 8.0){
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }

    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UINavigationController *loginVC = [sb instantiateViewControllerWithIdentifier:@"LoginView"];
    

//    self.windowBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"window_bg"]];
//    self.windowBG.frame = self.window.bounds;
//    //[self.window addSubview:self.windowBG];

    
    UserInfo *user = [UserInfo shareUser];
    [user loadUserInfoFromSenbox];
    
    if (user.SaveStatus)
    {
        [self loginToHome];
    }
    else
    {
        self.window.rootViewController = loginVC ;
    }
    
    [NSThread sleepForTimeInterval:3.0];
   [_window makeKeyAndVisible];
    
    return YES;
}

/**
 *  登录
 */
-(void)loginToHome
{
    UIStoryboard *sbMain = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RootViewController *rootView = [sbMain instantiateViewControllerWithIdentifier:@"rootController"];
    
    //获取用户名
    UserInfo *user = [UserInfo shareUser];
    //单例对象
    XMPPHelp *xmppHelp=[XMPPHelp  shareXmpp];
    //不是注册
    xmppHelp.isRegisterOperation=NO;
    //调用登录方法
    [xmppHelp  xmppUserRegisterOrLoginResultBlock:^(XMPPResultType type) {
        
        switch (type)//连接状态
        {
            case XMPPResultTypeLoginSuccess:
            {
                user.SaveStatus = YES;
                user.loginStatus = NO;
                [user  saveUserInfoToSanbox];//保存数据
                
                // 主线程刷新UI
               // dispatch_async(dispatch_get_main_queue(), ^{
                    
                self.window.rootViewController = rootView;
                    
              //  });
            }
                break;
            case XMPPResultTypeLoginFailure:
            {
                

            }
                break;
            case XMPPResultTypeNetWorkError:
            {
             
            }
                break;
            default:
                break;
        }
        
    }];
    
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    // 停止下载图片
    [[SDWebImageManager sharedManager] cancelAll];
    
    // 清除内存缓存图片
    [[SDWebImageManager sharedManager].imageCache clearMemory];
}

- (void)applicationWillResignActive:(UIApplication *)application {
   
    // 后台
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

   // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //当应用程序将终止
       // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "a.xin_chat" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"xin_chat" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"xin_chat.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
