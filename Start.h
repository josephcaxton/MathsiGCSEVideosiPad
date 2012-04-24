//
//  Start.h
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Start : UIViewController <UITextFieldDelegate,UIAlertViewDelegate,NSXMLParserDelegate>{
    
    UIView *FirstView;
    UIButton *FreeVideos;
	UIButton *BtnTransfermysubscription;
    UIButton *RentaVideo;
    UIImage *Image;
    UIImageView *ImageView;
    
    UITextField *UsernameText;
    UITextField *PasswordText;
    UITextField* textField;
    NSMutableData *ReponseFromServer;
    BOOL PassageFlag;
}

@property (nonatomic, retain) UIView *FirstView;
@property (nonatomic, retain) UIButton *FreeVideos;
@property (nonatomic, retain) UIButton *BtnTransfermysubscription;
@property (nonatomic, retain)  UIButton *RentaVideo;
@property (nonatomic, retain)  UIImage *Image;
@property (nonatomic, retain)  UIImageView *ImageView;
@property (nonatomic, retain)  UITextField *UsernameText;
@property (nonatomic, retain)  UITextField *PasswordText;
@property (nonatomic, retain)  UITextField* textField;
@property (nonatomic, retain)  NSMutableData *ReponseFromServer;
@property (nonatomic, assign) BOOL PassageFlag;

-(IBAction)ViewFreeVideos:(id)sender;
-(IBAction)TransferSubscription:(id)sender;
- (void)AddProgress;
-(void)SubscriptionTransferServer:(NSString *)DeviceID;
@end
