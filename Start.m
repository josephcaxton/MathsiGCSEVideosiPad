//
//  Start.m
//  VideoStreamer
//
//  Created by Joseph caxton-Idowu on 13/03/2012.
//  Copyright (c) 2012 caxtonidowu. All rights reserved.
//

#import "Start.h"
#import "FreeVideosClass.h"
#import "AppDelegate.h"

@implementation Start

@synthesize FirstView,FreeVideos,MyVideos,RentaVideo,Image,ImageView;

#define SCREEN_WIDTH  768    
#define SCREEN_HEIGHT 950



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    self.navigationItem.title = @"www.LearnersCloud.com";
    CGRect FirstViewframe = CGRectMake(0 ,0, SCREEN_WIDTH, SCREEN_HEIGHT);
	self.FirstView = [[UIView alloc] initWithFrame:FirstViewframe];
    
    
    Image = [UIImage imageNamed:@"MathsBackground.png"];
    ImageView = [[UIImageView alloc] initWithImage:Image];
   // ImageView.frame = CGRectMake(0 ,0, 540, 950);
    ImageView.frame = CGRectMake(60 ,200, 640, 480);

    
   // UIColor *patternColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Cinema_port.png"]];

    [FirstView addSubview:ImageView];

    [self.view addSubview:FirstView];
    
   
    FreeVideos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [FreeVideos setTitle:@"View free videos!" forState:UIControlStateNormal];
    FreeVideos.frame = CGRectMake(115 ,100, 200, 44);
   // UIImage *FreeVideosbuttonImage = [UIImage imageNamed:@"YellowBackground.png"];
   // [FreeVideos setBackgroundImage:FreeVideosbuttonImage forState:UIControlStateNormal];
    

    [FreeVideos addTarget:self action:@selector(ViewFreeVideos:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:FreeVideos];
    
    
    
    MyVideos = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [MyVideos setTitle:@"My videos!" forState:UIControlStateNormal];
    [MyVideos setTitleColor:[UIColor redColor] forState: UIControlStateNormal];
    MyVideos.frame = CGRectMake(455 ,100, 200, 44);
   // UIImage *MyVideosbuttonImage = [UIImage imageNamed:@"blueBackground.png"];
    //[MyVideos setBackgroundImage:MyVideosbuttonImage forState:UIControlStateNormal];
    
    [MyVideos addTarget:self action:@selector(ViewFreeVideos:) forControlEvents:UIControlEventTouchUpInside];
    
    [FirstView addSubview:MyVideos];

   
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

-(IBAction)ViewFreeVideos:(id)sender{
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.SecondThread = [[NSThread alloc]initWithTarget:self selector:@selector(AddProgress) object:nil];
    [appDelegate.SecondThread start];

   
    FreeVideosClass *Free_View = [[FreeVideosClass alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:Free_View animated:YES];
    
    
}

- (void)AddProgress{
	
	
	UIActivityIndicatorView * activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	[activityIndicator stopAnimating];
    [activityIndicator hidesWhenStopped];
	UIBarButtonItem * barButton = [[UIBarButtonItem alloc] initWithCustomView:activityIndicator];
	[self navigationItem].rightBarButtonItem = barButton;
	
	[(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView startAnimating];
	
	
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return YES;
	
	
}



- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration{
    
    
    if (interfaceOrientation == UIInterfaceOrientationPortrait  || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        
        FreeVideos.frame = CGRectMake(115 ,100, 200, 44);
        MyVideos.frame = CGRectMake(455 ,100, 200, 44);
        ImageView.frame = CGRectMake(60 ,200, 640, 480);
        FirstView.frame = CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT);
       
        
    }
    else
    {
        FreeVideos.frame = CGRectMake(200 ,15, 200, 44);
        MyVideos.frame = CGRectMake(640 ,15, 200, 44);
        ImageView.frame = CGRectMake(200 ,90, 640, 480);
        FirstView.frame = CGRectMake(0, 0, SCREEN_HEIGHT + 80 , SCREEN_WIDTH);
        
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated{
    
    [(UIActivityIndicatorView *)[self navigationItem].rightBarButtonItem.customView stopAnimating];
    [self willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:1];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
