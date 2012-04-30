//
//  AppDelegate.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "AppDelegate.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>

//#import "FirstViewController.h"

//#import "SecondViewController.h"

@implementation AppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize SecondThread,SelectProductID,buyScreen,DomainName,SubscriptionStatusData,TempSubscibedProducts,SubscibedProducts,PassageFlag,UserEmail,EmailFlag,AccessAll;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Remove useless tabbarItems ..
    NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:tabBarController.viewControllers];
    [viewControllers removeObjectAtIndex:1];
    [viewControllers removeObjectAtIndex:2];
    [viewControllers removeObjectAtIndex:2];
    [viewControllers removeObjectAtIndex:2];
    [tabBarController setViewControllers:viewControllers];
    
    SecondThread = nil;
    DomainName = @"http://stage.learnerscloud.com";
    
    
    [window addSubview: tabBarController.view];
	[window makeKeyAndVisible];
    
    
	//NSString *DeviceID = (NSString *)[[NSUserDefaults standardUserDefaults] objectForKey:@"LCUIID"];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *DeviceID = [prefs stringForKey:@"LCUIID"];
    
    if (DeviceID == nil) {
		
		NSString *mydeviceid = [self GetUUID];
        
       /* NSDictionary *appDefaults  = [NSDictionary dictionaryWithObjectsAndKeys:mydeviceid, @"LCUIID", nil];
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize]; */
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:mydeviceid forKey:@"LCUIID"];
        [prefs synchronize];
		
	}
    else {
        //Check SubscriptionStatus
        
        
        [self SubscriptionStatus: DeviceID];

    }

    // Notification Service Registration
    
    NSLog(@"Registering for push notifications...");    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
	// Reset Badge Count 
    application.applicationIconBadgeNumber = 0; 
    
    return YES;
}

-(void)SubscriptionStatus:(NSString *)DeviceID{
    
    NSString *Filter =[NSString stringWithString:@"1"];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSString *domain = appDelegate.DomainName;
    
    
    NSString *queryString = [NSString stringWithFormat:@"%@/Services/iOS/VideoSubscription.asmx/ViewSubscriptionStatus",domain];
    NSURL *url = [NSURL URLWithString:queryString];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    
    NSString *FullString = [NSString stringWithFormat:@"DeviceID=%@&filter=%@&",DeviceID,Filter];
    NSData* data=[FullString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *contentType = @"application/x-www-form-urlencoded; charset=utf-8";
    [req addValue:contentType forHTTPHeaderField:@"Content-Length"];
    unsigned long long postLength = data.length;
    NSString *contentLength = [NSString stringWithFormat:@"%llu",postLength];
    [req addValue:contentLength forHTTPHeaderField:@"Content-Length"];
    
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:data];
    
    NSURLConnection *conn;
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (!conn) {
        NSLog(@"error while starting the connection");
    } 
    
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)someData {
    
    /*ViewSubscriptionStatus returns from server:
     
     A Jason object with 
     1, DateTo
     2, EmailAddress
     3,ProductIdentifier */
    
        if(!SubscriptionStatusData){
        SubscriptionStatusData = [[NSMutableData alloc]init ];
    }
    
    
    [SubscriptionStatusData appendData:someData];
    //NSString *returnedString = [[NSString alloc] initWithData:someData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",returnedString);
    
    
    
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    
    NSString *returnedString = [[NSString alloc] initWithData:SubscriptionStatusData encoding:NSASCIIStringEncoding];
    //NSLog(@"%@",returnedString);
    NSString *Clean1 = [returnedString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    NSString *Clean2 =[Clean1 stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    NSString *Clean3 =[Clean2 stringByReplacingOccurrencesOfString:@"&lt;/" withString:@"/>"];
    //NSLog(@"%@",Clean3);
    NSData *xmlData = [Clean3 dataUsingEncoding:NSUTF8StringEncoding];
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:xmlData];
    [parser setDelegate:self];
    [parser parse];
    
    [self WorkOutSubsriptionName:TempSubscibedProducts];
   // NSLog(@"Subscibed products= %i", [SubscibedProducts count]);
    
    // Post notification to refresh table
   
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
     [nc postNotificationName:@"ToFreeVideoClass" object:self];
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict {
    
    if ([elementName isEqualToString:@"ProductIdentifier"]) {
        
        PassageFlag = TRUE;
        
    }
    else if([elementName isEqualToString:@"EMail"]){
        
        EmailFlag = TRUE;
    }
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    NSString *CleanString = [string stringByTrimmingCharactersInSet:
                             [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if([CleanString isEqualToString:@""]){
        
        //Do nothing
        PassageFlag = FALSE;
        EmailFlag = FALSE;
        return;
        
    }
    
    if(PassageFlag == TRUE)
        
    {
        NSString *SubscribedProductID = CleanString;
        //NSString *ProductID = [self WorkOutSubsriptionName:SubscribedProductID];
        
        if(!TempSubscibedProducts){
            TempSubscibedProducts = [[NSMutableArray alloc] init ];
        }
        //NSLog(@"%@",string);
        [TempSubscibedProducts addObject:SubscribedProductID];
        PassageFlag = FALSE;
    }
    
    else if(EmailFlag == TRUE){
        
        NSString *EmailAddress = CleanString;
        UserEmail = [NSString stringWithString:EmailAddress];
        EmailFlag = FALSE;
    }
}




-(void)WorkOutSubsriptionName:(NSMutableArray*)SubscibedProductsInArray{
    // Only 7 days and 30days subscription supported
    
    for (int i = 0; i < SubscibedProductsInArray.count; i++) {
        
        NSString *Product =[[NSString alloc] initWithString:[SubscibedProductsInArray objectAtIndex:i]];
        //NSLog(@"%@",Product);
        NSString *FinalVal;
        if(!SubscibedProducts){
           SubscibedProducts = [[NSMutableArray alloc] init ]; 
        }
        int lenghtofString = [Product length];
       // NSLog(@"%i",lenghtofString);
    
       NSString *Result = [Product substringWithRange:NSMakeRange(lenghtofString - 5, 5)];
        
       //NSLog(@"%@",Result);
        
        if ([[Result lowercaseString] isEqualToString:@"month"] ){
            // string minus 1Month
            FinalVal = [Product substringWithRange:NSMakeRange(0, lenghtofString - 6)];
           
        }
        else
        {
            // string minus 7days
            FinalVal = [Product substringWithRange:NSMakeRange(0, lenghtofString - 5)];
             
        }
        //NSLog(@"%@",Product);
        //NSLog(@"%@",FinalVal);
        
        
        [SubscibedProducts addObject:FinalVal];
        
       

    }
    
    
   
    
        
    
}



- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSString *)GetUUID{
    
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef idstring = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    NSString *Deviceid = [NSString stringWithFormat:@"%@",idstring];
    return Deviceid;
}


-(BOOL)isDeviceConnectedToInternet{
    
    static BOOL checkNetwork = YES;
	BOOL _isDataSourceAvailable;
    if (checkNetwork) { // Since checking the reachability of a host can be expensive, cache the result and perform the reachability check once.
         checkNetwork = NO; //don't cache
		
        Boolean success;    
        const char *host_name = "http://www.google.com"; // my data source host name
		
        SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(NULL, host_name);
        SCNetworkReachabilityFlags flags;
        success = SCNetworkReachabilityGetFlags(reachability, &flags);
        _isDataSourceAvailable = success && (flags & kSCNetworkFlagsReachable) && !(flags & kSCNetworkFlagsConnectionRequired);
        CFRelease(reachability);
    }
    return _isDataSourceAvailable;
}

//Return True is file does not exist in device -- so download from server;
// Return True if the file exist but version is defferent--- So we need to download the file;
// Return false if the file is same version --- so don't download;
- (BOOL)downloadFileIfUpdated:(NSString*)urlString:(NSString*)LocalFileLocation {  
    
    //DLog(@"Downloading HTTP header from: %@", urlString);
    
    NSURL *url = [NSURL URLWithString:urlString];  
    
    NSString *cachedPath = LocalFileLocation;
    NSFileManager *fileManager = [NSFileManager defaultManager];  
    
    //BOOL downloadFromServer = NO; 
    NSString *lastModifiedString = nil;  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];  
    [request setHTTPMethod:@"HEAD"];  
    NSHTTPURLResponse *response;  
   // Get Date from server first 
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error: NULL];  
    if ([response respondsToSelector:@selector(allHeaderFields)]) {  
        lastModifiedString = [[response allHeaderFields] objectForKey:@"Last-Modified"];  
    }
    
    NSDate *lastModifiedServer = nil;  
    @try {  
        NSDateFormatter *df = [[NSDateFormatter alloc] init];  
        df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";  
        df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];  
        df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];  
        lastModifiedServer = [df dateFromString:lastModifiedString];
    
        
    }  
    @catch (NSException * e) {  
        NSLog(@"Error parsing last modified date: %@ - %@", lastModifiedString, [e description]);  
    }  
   // NSLog(@"lastModifiedServer: %@", lastModifiedServer);
    
    // Get Date on Local device
    NSDate *lastModifiedLocal = nil;  
    if ([fileManager fileExistsAtPath:cachedPath]) {  
        NSError *error = nil;  
        NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:cachedPath error:&error];  
        if (error) {  
            NSLog(@"Error reading file attributes for: %@ - %@", cachedPath, [error localizedDescription]);  
        }  
        lastModifiedLocal = [fileAttributes fileModificationDate];  
       // NSLog(@"lastModifiedLocal : %@", lastModifiedLocal);  
    }
    
    // Download file from server if we don't have a local file  
    if (!lastModifiedLocal) {  
        return YES;  
    }
    
    if ([lastModifiedLocal laterDate:lastModifiedServer] == lastModifiedServer) {  
        return YES;  
    }
    
    //NSLog(@"This is to compare the date %@ localDate , %@ serverdate",lastModifiedLocal,lastModifiedServer);
    return NO;
    
} 

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    //NSString *str = [NSString stringWithFormat:@"Device Token=%@",deviceToken];
    //NSLog(@"%@",str);
    
    
    // Add the Device Token to our database.
    
    // NSString *Raw_DeviceToken = [NSString stringWithFormat:@"%@",deviceToken];
    
    NSString *DeviceUDID = [NSString 
                            stringWithFormat:@"%@",[UIDevice currentDevice].uniqueIdentifier];
    
    NSString *DeviceTokenRemoveCh1 = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    
    NSString *DeviceToken = [DeviceTokenRemoveCh1 stringByReplacingOccurrencesOfString: @" " withString: @""];
    
    
    NSURLConnection *conn;
    NSString *queryString = [NSString stringWithFormat:@"http://www.learnerscloud.com/services/ios/deviceToken.asmx/Update?UDID=%@&deviceToken=%@" , DeviceUDID, DeviceToken ];
    NSURL *url = [NSURL URLWithString:queryString];
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    [req addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [req addValue:0 forHTTPHeaderField:@"Content-Length"];
    [req setHTTPMethod:@"GET"];
    
    conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if (conn) {
        
    } 
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err { 
    
    NSString *str = [NSString stringWithFormat: @"Error: %@", err];
    NSLog(@"%@",str);    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    for (id key in userInfo) {
        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
    }    
    
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
