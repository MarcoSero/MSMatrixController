//
//  MSAppDelegate.m
//  MSMatrixController
//
//  Created by Marco Sero on 29/03/13.
//  Copyright (c) 2013 Marco Sero. All rights reserved.
//

#import "MSAppDelegate.h"
#import "MSMatrixController.h"

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  UIStoryboard *currentStoryboard = [UIStoryboard storyboardWithName:@"iPhone" bundle:nil];

  UIViewController *initialViewController = self.window.rootViewController;
  MSMatrixMasterViewController *cartesianMasterViewController = [[MSMatrixMasterViewController alloc] initWithFrame:initialViewController.view.frame];

  UIViewController *position00ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position00"];
  position00ViewController.row = 0;
  position00ViewController.col = 0;

  UIViewController *position01ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position01"];
  position01ViewController.row = 0;
  position01ViewController.col = 1;

  UIViewController *position11ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position11"];
  position11ViewController.row = 1;
  position11ViewController.col = 1;

  UIViewController *position12ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position12"];
  position12ViewController.row = 1;
  position12ViewController.col = 2;

  UIViewController *position21ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position21"];
  position21ViewController.row = 2;
  position21ViewController.col = 1;

  UIViewController *position22ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position22"];
  position22ViewController.row = 2;
  position22ViewController.col = 2;

  UIViewController *position23ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position23"];
  position23ViewController.row = 2;
  position23ViewController.col = 3;

  UIViewController *position24ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position24"];
  position24ViewController.row = 2;
  position24ViewController.col = 4;

  UIViewController *position14ViewController = [currentStoryboard instantiateViewControllerWithIdentifier:@"position14"];
  position14ViewController.row = 1;
  position14ViewController.col = 4;

  NSArray *children = @[position00ViewController, position01ViewController, position11ViewController, position12ViewController,
    position21ViewController, position22ViewController, position23ViewController, position24ViewController, position14ViewController];
  [cartesianMasterViewController setControllers:children];

  self.window.rootViewController = cartesianMasterViewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
