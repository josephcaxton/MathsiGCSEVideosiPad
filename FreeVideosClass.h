//
//  FreeVideos.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 14/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FreeVideosClass :  UITableViewController  <UITableViewDataSource, UITableViewDelegate>{
    
    NSMutableArray *ArrayofConfigObjects; 
    
}

@property (nonatomic, retain) NSMutableArray *ArrayofConfigObjects;

-(void)CheckifConfigFileExistAndDelete:(NSString*)Path;
-(void)GetConfigFileFromServeWriteToPath:(NSString*)Path;
-(void)Alertfailedconnection;
-(void)MyParser:(NSString *)FileLocation;
@end
