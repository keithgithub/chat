//
//  AppDelegate.m
//  ZLF_Char
//
//  Created by ibokan on 15/11/25.
//  Copyright (c) 2015年 com.zlf. All rights reserved.
//

#import "AppDelegate.h"
#import "LFTabBarController.h"
#import "LFNavigationController.h"
#import "LFConstant.h"
#import "LFXMPPHelp+Message.h"
#import "XMPPvCardTemp.h"
#import "NSDate+LFExtension.h"
#import "LFUserInfo.h"
#import "MZGuidePages.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 创建window
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    // 创建背景图片
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    bgImageView.image = [UIImage imageNamed:@"main_bg7"];
    [self.window addSubview:bgImageView];
    
    // 获取故事板
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    // 获取标签栏视图
//    LFTabBarController *tabBarVc = [sb instantiateViewControllerWithIdentifier:@"LFTabBarController"];
    
    LFNavigationController *naVc = [sb instantiateViewControllerWithIdentifier:@"loginNav"];
    // 设置跟视图
    self.window.rootViewController = naVc;
    
    [self.window makeKeyAndVisible];
    
    [self guidePages];
    
    return YES;
}

-(void)guidePages
{
//    //数据源
//    NSArray *imgeArray=@[@"launch1", @"launch2", @"launch3"];
    //数据源
    NSArray *imgeArray=@[@"new_feature_1", @"new_feature_2", @"new_feature_3", @"new_feature_4"];
    
    MZGuidePages *mzgpc=[[MZGuidePages alloc]init];
    mzgpc.imageDatas=imgeArray;
    __weak typeof(MZGuidePages) *weakMZ = mzgpc;
    mzgpc.buttonAction = ^{
        [UIView animateWithDuration:1.0f
                         animations:^{
                             weakMZ.alpha = 0.0;
                         }
                         completion:^(BOOL finished) {
                             [weakMZ removeFromSuperview];
                         }];
    };
    //要在makeKeyAndVisible之后调用才有效
    [self.window addSubview:mzgpc];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    
//    __block UIBackgroundTaskIdentifier identifier = [[UIApplication sharedApplication]beginBackgroundTaskWithExpirationHandler:^{
//        
//        if (identifier != UIBackgroundTaskInvalid) {
//            
//            [[UIApplication sharedApplication] endBackgroundTask:identifier];
//            
//            identifier = UIBackgroundTaskInvalid;
//            
//        }
//        
//    }];
//    
//    
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        // 设置离开时间
//        [[LFUserInfo shareUserInfo] setExitTime];
//        
//        if (identifier != UIBackgroundTaskInvalid) {
//            
//            [[UIApplication sharedApplication] endBackgroundTask:identifier];
//            
//            identifier = UIBackgroundTaskInvalid;
//        }
//    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
//  
//    XMPPvCardTemp *myvCardTemp = [LFXMPPHelp shareXMPPHelp].xmppvCardTempModule.myvCardTemp;
//    myvCardTemp.formattedName = [NSDate getNowTime];
//    // 通知服务器更新
//    [[LFXMPPHelp shareXMPPHelp].xmppvCardTempModule updateMyvCardTemp:myvCardTemp];
    // 设置离开时间
    [[LFUserInfo shareUserInfo] setExitTime];
    
    // 系统自带
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "zlf.ZLF_Char" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ZLF_Char" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ZLF_Char.sqlite"];
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
