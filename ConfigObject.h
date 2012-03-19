//
//  ConfigObject.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 14/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigObject : NSObject
{
    
}

@property (nonatomic, retain) NSString *VideoTitle;
@property (nonatomic, retain) NSString *VideoDescription;
@property (nonatomic, assign) BOOL Free;
@property (nonatomic, retain) NSString *Subject;
@property (nonatomic, retain) NSString *M3u8;
@property (nonatomic, retain) NSString *Thumbnail;
@property (nonatomic, retain) NSString *ProductID;

@end
