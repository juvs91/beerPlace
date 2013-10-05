//
//  AppDelegate.m
//  BeerMeUp
//
//  Created by Lay Gonzalez Romero on 04/10/13.
//  Copyright (c) 2013 Lay Gonzalez Romero. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "SBJson.h"

@interface AppDelegate ()

@property (strong, nonatomic) MainViewController *mainViewController;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [FBProfilePictureView class];
    // Override point for customization after application launch.
    
    self.mainViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    self.navController = [[UINavigationController alloc]
                          initWithRootViewController:self.mainViewController];
    self.window.rootViewController = self.navController;
    [self.window makeKeyAndVisible];
    
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        // To-do, show logged in view
        [self openSession];
        [self.mainViewController populateUserDetails];
        
    } else {
        // No, display the login page.
        [self showLoginView];
    }
    
    
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)sessionStateChanged:(FBSession *)session
                      state:(FBSessionState) state
                      error:(NSError *)error
{
    switch (state) {
        case FBSessionStateOpen: {
            UIViewController *topViewController =
            [self.navController topViewController];
            [[FBRequest requestForMe] startWithCompletionHandler:
             ^(FBRequestConnection *connection,
               NSDictionary<FBGraphUser> *user,
               NSError *error) {
                 if (!error) {
                     //NSString *postString = [NSString stringWithFormat:@"r=user/login&id=1"];
                     NSURL *theURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://10.20.216.157:4040/index.php?r=user/login&id=%@", user.id]];
                     NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL
                                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                                        timeoutInterval:3.0];
                     [request setHTTPMethod:@"POST"];
                     //NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSDictionary dictionaryWithObjectsAndKeys:user.id, @"id", nil], @"User", nil];
                     //NSString *jsonString = [dictionary JSONRepresentation];
                     //NSLog(@"json string: %@", jsonString);
                     //[request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
                     [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
                     //NSLog(@"PostString in JSON: %@",postString);
                     
                     NSError *errorRequest;
                     NSURLResponse *response;
                     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&errorRequest];
                     
                     if (!errorRequest) {
                         NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                         NSLog(@"Response from Server data: %@", dataString);
                         if ([dataString isEqual:[NSNull null]]) {
                             NSLog(@"dataIsNull");
                         } else{
                             
                             NSArray *rows = [dataString JSONValue];
                         }
                         
                     } else{
                         //TODO: Make an alert
                         NSLog(@"Error contacting our Server");
                         NSLog(@"descripcion: %@", [errorRequest description]);
                         NSLog(@"response: %@", [((NSHTTPURLResponse *)response) MIMEType]);
                     }
                     if ([[topViewController presentedViewController]
                          isKindOfClass:[LoginViewController class]]) {
                         [topViewController dismissViewControllerAnimated:YES completion:nil];
                     }
                 }
             }];
        }
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            // Once the user has logged in, we want them to
            // be looking at the root view.
            [self.navController popToRootViewControllerAnimated:NO];
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            [self showLoginView];
            break;
        default:
            break;
    }
    
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Error"
                                  message:error.localizedDescription
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        alertView.delegate = self;
        [alertView show];
    }
}

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    //LoginViewController* loginViewController = (LoginViewController *)self.navController.presentedViewController;
    //[loginViewController loginFailed];
}

- (void)openSession
{
    [FBSession openActiveSessionWithReadPermissions:nil
                                       allowLoginUI:YES
                                  completionHandler:
     ^(FBSession *session,
       FBSessionState state, NSError *error) {
         [self sessionStateChanged:session state:state error:error];
     }];
}

- (void)showLoginView
{
    UIViewController *topViewController = [self.navController topViewController];
    UIViewController *modalViewController = [topViewController presentedViewController];
    
    // If the login screen is not already displayed, display it. If the login screen is
    // displayed, then getting back here means the login in progress did not successfully
    // complete. In that case, notify the login view so it can update its UI appropriately.
    if (![modalViewController isKindOfClass:[LoginViewController class]]) {
        LoginViewController* loginViewController = [[UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [topViewController presentViewController:loginViewController animated:NO completion:nil];
    } else {
        LoginViewController* loginViewController = (LoginViewController*)modalViewController;
        [loginViewController loginFailed];
    }
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
    // We need to properly handle activation of the application with regards to Facebook Login
    // (e.g., returning from iOS 6.0 Login Dialog or from fast app switching).
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
