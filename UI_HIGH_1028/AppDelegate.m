//
//  AppDelegate.m
//  UI_HIGH_1028
//
//  Created by lanou on 15/10/28.
//  Copyright (c) 2015年 xxl. All rights reserved.
//

#import "AppDelegate.h"
#import "XLViewController.h"
#import "ZWIntroductionViewController.h"
#import "XLMainViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UMSocialSinaHandler.h"
#import "UMSocial.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AreaDic.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MusicTool.h"
#import "UIImageView+WebCache.h"

@interface AppDelegate ()<CLLocationManagerDelegate>

@property (nonatomic,strong)ZWIntroductionViewController *introductionView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


    XLMainViewController *mainVC = [[XLMainViewController alloc] init];
   
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:mainVC];

    navC.navigationBar.translucent = 0;
    navC.navigationBar.hidden = YES;

    
    
    // 定制引导页的图片内容
    NSArray *coverImageNames = @[@"ziti1", @"ziti2", @"ziti3"];
    NSArray *backgroundImageNames = @[@"beijing6.jpg", @"beijing7.jpg", @"beijing4.jpg"];
    self.introductionView = [[ZWIntroductionViewController alloc] initWithCoverImageNames:coverImageNames backgroundImageNames:backgroundImageNames];
    
    self.window.rootViewController = self.introductionView;
    
    __weak __block AppDelegate *weakSelf = self;
    self.introductionView.didSelectedEnter = ^() {
        [weakSelf.introductionView.view removeFromSuperview];
        weakSelf.introductionView = nil;
        
        // enter main view , write your code ...
        //可以在这个block里面进入自己的主VC
        
        weakSelf.window.rootViewController = navC;
        
    };
    
    
 //定位
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置定位精度，十米，百米，最好
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    // 开始时时定位
    [self.locationManager startUpdatingLocation];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:@"110000" forKey:@"CityID"];
    
    

    
    
    // 设置音乐后台播放的会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    // 开启接收远程事件
    [application beginReceivingRemoteControlEvents];
    
    
    //563ab7dbe0f55a08a40009aa
    
    [UMSocialData setAppKey:@"563ab7dbe0f55a08a40009aa"];
    
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    return YES;
}

#pragma mark--定位代理方法
// 错误信息
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
            break;
            
        default:
            break;
    }
   
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *newLocation = locations[0];
//    CLLocationCoordinate2D oldCoordinate = newLocation.coordinate;
//    NSLog(@"旧的经度：%f,旧的纬度：%f",oldCoordinate.longitude,oldCoordinate.latitude);
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation
                   completionHandler:^(NSArray *placemarks, NSError *error){
                       
                       for (CLPlacemark *place in placemarks) {
                           NSString *string = place.administrativeArea;
                           NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                           [userDefaults setObject:string forKey:@"location"];
                           
                           AreaDic *dic = [[AreaDic alloc]init];
                           for (NSString *key in dic.areadictionary) {
                               if ([string containsString:key]) {
                                   NSString *ID = [dic.areadictionary objectForKey:key];
                                   [userDefaults setObject:ID forKey:@"CityID"];
                                   break;
                               }
                           }

                       }
                       
                   }];
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    
    info[MPMediaItemPropertyTitle] = [MusicTool sharedMusicTool].nowPlayerName;
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[MusicTool sharedMusicTool].coverSmallUrl]];
    UIImage *image = imageView.image;
    if (image != nil) {
        MPMediaItemArtwork *artwork = [[MPMediaItemArtwork alloc]initWithImage:image];
        info[MPMediaItemPropertyArtwork] = artwork;
    }
    info[MPMediaItemPropertyPlaybackDuration] = @([MusicTool sharedMusicTool].player.currentItem.duration.value / [MusicTool sharedMusicTool].player.currentItem.duration.timescale);
    [MPNowPlayingInfoCenter defaultCenter].nowPlayingInfo = info;
    
    [application beginBackgroundTaskWithExpirationHandler:nil];
    
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        
        self.eventTypeBlock(event);
    }
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
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "XXL.UI_HIGH_1028" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"UI_HIGH_1028" withExtension:@"momd"];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UI_HIGH_1028.sqlite"];
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
