//
//  ViewController.m
//  Dodge Template
//
//  Copyright (c) 2014 Chempo.com. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

#define kRemoveAdsProductIdentifier @"BrofistNoAds"

#define kLeaderboardIdentifier @"bfld"

#define kIDRateApp @"https://itunes.apple.com/us/app/brofist-game-how-many-brofists/id894589832?ls=1&mt=8"


#define kGameStateMenu 1
#define kGameStateStart 2
#define kGameStateRunning 3
#define kGameStatePaused 4
#define kGameStateOver 5

#define increment 0.05

#define adID @"ca-app-pub-4527607880928611/9436906689";


@interface ViewController ()


@end

@implementation ViewController


NSInteger gameState;
int score;
NSTimer *gameTimer;
int difficulty;
SystemSoundID mySound;
int lol;

-(BOOL)prefersStatusBarHidden{
    return YES;
}
-(void)viewDidLayoutSubviews{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    screenSize = [[UIScreen mainScreen] bounds].size;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Assets"];
    
    [query fromLocalDatastore];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *fetchObject,NSError*err){
        
        [fetchObject fetchFromLocalDatastoreInBackgroundWithBlock:^(PFObject *object, NSError *error){
            
            if (!error) {
                NSLog(@"%@",object);
                
                PFFile * normalFist = object[@"standardFist"];
                [normalFist getDataInBackgroundWithBlock:^(NSData *result, NSError *error){
                    normalFistImage = [UIImage imageWithData:result];
                    
                    [_object5 setImage:normalFistImage];
                    [_object2 setImage:normalFistImage];
                    [_object3 setImage:normalFistImage];
                    [_object4 setImage:normalFistImage];
                }];
                
                PFFile *background = object[@"background"];
                [background getDataInBackgroundWithBlock:^(NSData *result, NSError *error){
                    [bgHills setImage:[UIImage imageWithData:result]];
                }];
                
                PFFile *titleImage = object[@"header"];
                [titleImage getDataInBackgroundWithBlock:^(NSData *result, NSError *error){
                    [_brofistTitle setImage:[UIImage imageWithData:result]];
                }];
                
                PFFile * steelFist = object[@"steelFist"];
                [steelFist getDataInBackgroundWithBlock:^(NSData *result, NSError *error){
                    [_object1 setImage:[UIImage imageWithData:result]];
                }];
                
                PFFile * musicFile = object[@"music"];
                [musicFile getDataInBackgroundWithBlock:^(NSData *result, NSError *error){
                    [[MylogonAudio sharedInstance]playDataBackgroundMusic:result];
                }];
            }
        }];
    }];
    
     

    
    
//    [[MylogonAudio sharedInstance]playBackgroundMusic:<#(NSString *)#>]
    
    //snowView = (SKView *)self.view;
    //    snowView.showsFPS = YES;
    //    snowView.showsNodeCount = YES;
    
//    // Create and configure the scene.
//    SKScene * scene = [SKScene sceneWithSize:snowView.bounds.size];
//    scene.scaleMode = SKSceneScaleModeAspectFill;
//    //
//    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"spriteSnow"];
//    
//    background.position = CGPointMake(CGRectGetMidX(snowView.frame), CGRectGetMidY(snowView.frame));
//    background.name = @"BACKGROUND";
//    background.size = snowView.frame.size;
//    
//    [scene addChild:background];
//    
//    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"SnowSystem" ofType:@"sks"];
//    SKEmitterNode *bokeh = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
//    bokeh.position = CGPointMake(CGRectGetMidX(snowView.frame), snowView.frame.size.height);
//    bokeh.particlePositionRange = CGVectorMake(screenSize.width, 5);
//    bokeh.name = @"particleBokeh";
//    bokeh.targetNode = scene;
//    [scene addChild:bokeh];
//    
//    if(isiPad){
//        _titleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
//    }
//    
//    
//    
//    //   [self loadEmitterNode:@"SnowSystem"];
//    
//    // Present the scene.
//    [snowView presentScene:scene];
    
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if ([deviceType hasPrefix:@"iPad"]) {
        isiPad = YES;
    }else{
        isiPad = NO;
    }
    
    
    _titleView.center = CGPointMake(screenSize.width/2, screenSize.height + 400);
    _gameoverView.center = CGPointMake(screenSize.width/2, screenSize.height + 400);
    snowView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    if (isiPad) {
        speed = 1.5;
    }else{
        speed = 1;
    }
    
    self.bannerView.adUnitID = adID;
    self.bannerView.rootViewController = self;
    [self.bannerView loadRequest:[GADRequest request]];
    
    [self.bannerView setCenter:CGPointMake(self.view.frame.size.width/2, 25)];
    
    
    // Initiate a generic request to load it with an ad.
    
    gameState = kGameStateMenu;
    _connecting.hidden = YES;
    
    [[GameCenterManager sharedManager] setDelegate:self];
    
    if (isiPad) {
        
        [self fistScale:_object1];
        [self fistScale:_object2];
        [self fistScale:_object3];
        [self fistScale:_object4];
        [self fistScale:_object5];
    }
    
    objectsArray = [NSArray arrayWithObjects:_object1,_object2,_object3,_object4,_object5, nil];
    
    _scoreLabel.font = [UIFont fontWithName:@"debussy" size:35];
    _scoreLabel.textColor = [UIColor whiteColor];
    
    _finalScore.font = [UIFont fontWithName:@"debussy" size:20];
    _finalScore.textColor = [UIColor grayColor];
    
    _bestScore.font = [UIFont fontWithName:@"debussy" size:20];
    _bestScore.textColor = [UIColor blackColor];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentTitle = @"BroFist";
        content.contentURL = [NSURL URLWithString:@"https://itunes.apple.com/us/app/brofist-game-how-many-brofists/id894589832?mt=8"];
        content.contentDescription = @"Get BroFist today for FREE on iOS and compete against friends. Who will get the global High Score?!";
    
    FBSDKShareButton *shareButtonbutton = [[FBSDKShareButton alloc] init];
    shareButtonbutton.shareContent = content;
    [self.titleView addSubview:shareButtonbutton];
    [shareButtonbutton setCenter:CGPointMake(credits.center.x + 50, credits.center.y)];
    
    [self menu];
}

-(void)fistScale:(UIImageView* )fist{
    
    fist.frame = CGRectMake(0, -150, 90 * (screenSize.width/ 450), 90 * (screenSize.width/ 450));
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - MENU
-(void)menu{
    _scoreLabel.hidden = YES;
    _instructions.hidden = NO;
    //CGRect menu;
    
    bgImage.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    bgHills.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    groundImage.frame = CGRectMake(0, 0, screenSize.width, 60);
    
    
    // [self resetHero];
    
    go = NO;
    
    
//    if (isiPad) {
//        menu = CGRectMake(screenSize.width/2 - 287, screenSize.height/2 - 360, 574, 720);
//        _titleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
//        
//    }else{
//        
//        
//        if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
//            if(screenSize.height >480.0f){
//                menu= CGRectMake(screenSize.width/2 - 287/2,79,287,360);
//            }
//            else{
//                menu= CGRectMake(screenSize.width/2 - 287/2,56,287,360);
//            }
//            
//        }
//    }
    [UIView animateWithDuration: 0.5f
                     animations:^{
                         _titleView.center = self.view.center;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
- (IBAction)play:(id)sender {
    _instructions.hidden = YES;
    _scoreLabel.hidden = NO;
    score = startScore;
    _scoreLabel.text = @"0";
    _hero.center = CGPointMake(-200, 0);
    
    _scoreLabel.center = CGPointMake(screenSize.width/2, 90);
    
    difficulty = 4.0;
    
    if(gameTimer)
    {
        [gameTimer invalidate];
        gameTimer = nil;
    }
    
    _object1.center = CGPointMake(0, -2000);
    [self performSelector:@selector(initObject1) withObject:nil afterDelay:1.5];
    [self initObject2];
    [self initObject3];
    [self initObject4];
    [self initObject5];
    gameState = kGameStateRunning;
    
//    CGRect menu;
//    
//    if (isiPad) {
//        
//        menu = CGRectMake(screenSize.width/2 - 287, screenSize.height + 100, _titleView.frame.size.width, 270);
//        
//    }else{
//
//        menu
//        
////        if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
////            if(screenSize.height >480.0f){
////                menu= CGRectMake(17,700,287,270);
////            }
////            else{
////                menu= CGRectMake(17,600,287,270);
////            }
////            
////        }
//        
//    }
    [UIView animateWithDuration:0.5
                     animations:^{
                         _titleView.center = CGPointMake(self.view.frame.size.width /2, self.view.frame.size.height + _titleView.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         gameTimer = [NSTimer scheduledTimerWithTimeInterval:0.007 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
                         
                     }];
    
    [self performSelector:@selector(move) withObject:nil afterDelay:1];
}


- (IBAction)highscores:(id)sender {
    [self showLeaderboard];
}

- (IBAction)retry:(id)sender {
//    CGRect done;
    go = NO;
    reallyDead = false;
    
//    if (isiPad) {
//        
//        done = CGRectMake(screenSize.width/2 - 287, screenSize.height + 100, _titleView.frame.size.width, 270);
//        
//    }else{
//        
//        if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
//            if(screenSize.height >480.0f){
//                done = CGRectMake(16,700,280,286);
//            }
//            else{
//                done = CGRectMake(16,600,280,286);
//            }
//            
//        }
//    }
//    
    [_object1 setCenter:CGPointMake(arc4random_uniform(320), -220)];
    [self coll];
    
    [button removeFromSuperview];
    
    if (isiPad) {
        speed = 1.5;
    }else{
        speed = 1;
    }
    
    [UIView animateWithDuration: 0.6f
                          delay: 0.3f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _gameoverView.center = CGPointMake(self.view.center.x, self.view.frame.size.height+400);
                     }
                     completion:^(BOOL finished){
                         [self play:self];
                     }];
    
    
    gameState = kGameStateStart;
}

- (IBAction)rate:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:kIDRateApp]]];
}

#pragma mark - GAME
-(void)gameLoop{
    
    if (gameState == kGameStateOver && !reallyDead) {
        speed += 5;
        reallyDead = true;
    }
    
    _object1.center = CGPointMake(_object1.center.x, _object1.center.y + speed);
    _object2.center = CGPointMake(_object2.center.x, _object2.center.y + speed);
    _object3.center = CGPointMake(_object3.center.x, _object3.center.y + speed);
    _object4.center = CGPointMake(_object4.center.x, _object4.center.y + speed);
    _object5.center = CGPointMake(_object5.center.x, _object5.center.y + speed);
    
    
    if(gameState == kGameStateRunning ){
        
        
        if(_object1.center.y > screenSize.height + 100){
            [self initObject1];
        }
        
        if(_object2.center.y > screenSize.height + 100){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object3.center.y > screenSize.height + 100){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object4.center.y > screenSize.height + 100){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object5.center.y > screenSize.height + 100){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        //check collision
        CGRect heroRect = CGRectMake(_hero.frame.origin.x + 7, _hero.frame.origin.y + 7, _hero.frame.size.width - 14 , _hero.frame.size.height - 50);
        
        if(CGRectIntersectsRect(heroRect, CGRectMake(_object1.frame.origin.x + 15, _object1.frame.origin.y +15, _object1.frame.size.width- 30, _object1.frame.size.height - 30))){
            gameState = kGameStateOver;
            [self gameOver];
            
        }
        
        if(CGRectIntersectsRect(heroRect, _object2.frame)){
            [self initObject2];
            score ++;
            speed += increment;
        }
        
        if(CGRectIntersectsRect(heroRect, _object3.frame)){
            [self initObject3];
            score ++;
            speed += increment;
        }
        
        if(CGRectIntersectsRect(heroRect, _object4.frame)){
            [self initObject4];
            score ++;
            speed += increment;
        }
        
        if(CGRectIntersectsRect(heroRect, _object5.frame)){
            [self initObject5];
            score ++;
            speed += increment;
        }
        
        _scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
    if(gameState == kGameStatePaused){
        //pause everything
        
    }
}


-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //moves hero
    
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint location = [touch locationInView:touch.view];
    _hero.center = CGPointMake(location.x, location.y+30);
    
    [self performSelector:@selector(move) withObject:nil afterDelay:0.03];
}

-(void) move{
    _hero.center = CGPointMake(-100, -100);
}


-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    _hero.center = CGPointMake(-100, -100);
}

#pragma mark - GAME OVER
-(void)gameOver{
    _scoreLabel.hidden = YES;
    
    go = YES;
    
    
    _finalScore.text = [NSString stringWithFormat:@"%i", score];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults valueForKey:@"highscore"] == NULL) {
        [defaults setValue:@"0" forKey:@"highscore"];
    }
    if(score > [[defaults objectForKey:@"highscore"]intValue]){
        int x = [_finalScore.text intValue];
        [self submitToLeaderboard:x];
        [defaults setObject:_finalScore.text forKey:@"highscore"];
        [defaults synchronize];
    }
    
    _bestScore.text = [defaults objectForKey:@"highscore"];
    
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         [_gameoverView setCenter:self.view.center];
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    socialTen ++;
    
    if (socialTen == 10) {
        socialTen = 0;
        [self performSelector:@selector(freePointsLoad) withObject:nil afterDelay:0.5];
    }
    
    [_gameoverView addSubview:button];
    [_gameoverView bringSubviewToFront:button];
    
    [_gameoverView setUserInteractionEnabled:YES];
    
    startScore = 0;
    
}

-(IBAction)freePoints:(id)sender{
    socialAlert = 1;
    [self freePointsLoad];
}

-(void)freePointsLoad{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    socialAlert = [[defaults objectForKey:@"alert"]intValue];
    NSLog(@"%i",socialAlert);
    
    socialAlert = 1;
    
    if (socialAlert != 2) {
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Share me!" message:@"Share me through Social Media and start with 50 points on your next turn!" delegate:self cancelButtonTitle:@"Sure!" otherButtonTitles:@"Not this time", @"NEVER!!!", nil];
        
        alert.tag = 101;
        
        
        [alert show];
        
    }
    
}


-(void)socialShit{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Share with a bro" message:@"...and how would you like to share?" delegate:self cancelButtonTitle:@"I've changed my mind.." otherButtonTitles:@"Facebook!",@"Twitter!", nil];
    
    alert.tag = 202;
    
    [alert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"%li",(long)buttonIndex);
    
    if (alertView.tag == 101) {
        
        //Sure = 0
        //Not this time = 1
        //Never = 2
        
        if (buttonIndex == 1) {
            [defaults setValue:@"1" forKey:@"alert"];
            [defaults synchronize];
        }
        
        if (buttonIndex == 2) {
            [defaults setValue:@"2" forKey:@"alert"];
            [defaults synchronize];
        }
        
        if (buttonIndex == 0) {
            
            [self socialShit];
            
        }
    }
    
    if (alertView.tag == 202) {
        
        //facebook
        if (buttonIndex == 1) {
            
           
#warning facebook sharing
//            FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
//            dialog.fromViewController = self;
//            dialog.mode = FBSDKShareDialogModeWeb;
//            
//            [dialog show];
            
                    }
    }
    
    
    
    //twitter
    if (buttonIndex == 2) {
        {
            //  Create an instance of the Tweet Sheet
            SLComposeViewController *tweetSheet = [SLComposeViewController
                                                   composeViewControllerForServiceType:
                                                   SLServiceTypeTwitter];
            
            // Sets the completion handler.  Note that we don't know which thread the
            // block will be called on, so we need to ensure that any required UI
            // updates occur on the main queue
            tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
                switch(result) {
                        //  This means the user cancelled without sending the Tweet
                    case SLComposeViewControllerResultDone:
                    {
                        startScore = 50;
                        
                        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Success" message:@"You will now start with 50 points. Remember, you can do this as many times as you like!" delegate:self cancelButtonTitle:@"Cool!" otherButtonTitles: nil];
                        [alert show];
                        
                        break;}
                        //  This means the user hit 'Send'
                    case SLComposeViewControllerResultCancelled:{
                        
                    }   break;
                }
            };
            
            //  Set the initial body of the Tweet
            [tweetSheet setInitialText:@"I am playing BroFist the Game on iOS for FREE! #Brofist"];
            
            //  Adds an image to the Tweet.  For demo purposes, assume we have an
            //  image named 'larry.png' that we wish to attach
            if (![tweetSheet addImage:[UIImage imageNamed:@"brofist"]]) {
                NSLog(@"Unable to add the image!");
            }
            
            //  Add an URL to the Tweet.  You can add multiple URLs.
            if (![tweetSheet addURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/brofist-game-how-many-brofists/id894589832?mt=8"]]){
                NSLog(@"Unable to add the URL!");
            }
            
            //  Presents the Tweet Sheet to the user
            [self presentViewController:tweetSheet animated:NO completion:^{
                NSLog(@"Tweet sheet has been presented.");
            }];
        }
    }
    
}


- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}


#pragma mark - INIT OBJECTS


-(void)initObject1{
    int steelX = arc4random_uniform(screenSize.width) ;
    int h = -(arc4random() %110) + 20;
    _object1.center = CGPointMake(steelX, h);
    
    [self coll];
}

-(void)coll{
    
    if (_object1.center.y < 20) {
        
        if (CGRectIntersectsRect(_object1.frame, _object2.frame) || (CGRectIntersectsRect(_object1.frame, _object2.frame) || (CGRectIntersectsRect(_object1.frame, _object3.frame) || (CGRectIntersectsRect(_object1.frame, _object4.frame) || (CGRectIntersectsRect(_object1.frame, _object5.frame)))))){
            
            _object1.center = CGPointMake(arc4random_uniform(screenSize.width), -160);
        }
    }
}


-(void)initObject2{
    int r = arc4random_uniform(screenSize.width) ;
    int h = -(arc4random() %120 + 20);
    _object2.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject3{
    int r = arc4random_uniform(screenSize.width) ;
    int h = -(arc4random() %120 + 20);
    _object3.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject4{
    int r = arc4random_uniform(screenSize.width);
    int h = -(arc4random() %120 + 20);
    _object4.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject5{
    int r = arc4random_uniform(screenSize.width);
    int h = -(arc4random() %120 + 20);
    _object5.center = CGPointMake(r, h);
    [self coll];
}


#pragma mark - AdMob Banner

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey: @"noads"] != nil &&
        [[defaults objectForKey: @"noads"] isEqualToString: @"YES"]) {
        self.bannerView.hidden = YES;
        
    }
    else {
        self.bannerView.hidden = NO;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError: (GADRequestError *)error {
    self.bannerView.hidden = YES;
}


#pragma mark - inApp PURCHASE
- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    if (transaction.error.code != SKErrorPaymentCancelled){
        // Display an error here.
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Purchase Unsuccessful"
                                                        message:@"Your purchase failed. Please try again."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
    _connecting.hidden = YES;
    // Finally, remove the transaction from the payment queue.
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}
-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    _connecting.hidden = YES;
    
}
- (IBAction)noAds:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"noads"] != nil){
        if([[defaults objectForKey:@"noads"]isEqualToString:@"YES"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bought"
                                                            message:@"You've already bought this."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }else{
        if([SKPaymentQueue canMakePayments]){
            NSLog(@"User can make payments");
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
            productsRequest.delegate = self;
            [productsRequest start];
            _connecting.hidden = NO;
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops."
                                                            message:@"I don't think you are allowed to make in-app purchases."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            //this is called the user cannot make payments, most likely due to parental controls
        }
        
    }
}
- (IBAction)restore:(id)sender {
    //this is called when the user restores purchases, you should hook this up to a button
    _connecting.hidden = NO;
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        _connecting.hidden = YES;
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %i",(int) queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self doRemoveAds];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    _connecting.hidden = YES;
    
}
-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"%@",error);
    _connecting.hidden = YES;
}
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
                case SKPaymentTransactionStateDeferred:
                break;
            case SKPaymentTransactionStatePurchasing:{
                NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
            } break;
            case SKPaymentTransactionStatePurchased:{
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self doRemoveAds]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                _connecting.hidden = YES;
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
            }break;
            case SKPaymentTransactionStateRestored:{
                NSLog(@"Transaction state -> Restored");
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _connecting.hidden = YES;
            }break;
            case SKPaymentTransactionStateFailed:{
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                _connecting.hidden = YES;
            }break;
        }
    }
    
}
-(void)doRemoveAds{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES"forKey:@"noads"];
    [defaults synchronize];
    self.bannerView.hidden = YES;
}

#pragma mark - GAME CENTER
- (void)gameCenterManager:(GameCenterManager *)manager authenticateUser:(UIViewController *)gameCenterLoginController{
    [self presentViewController:gameCenterLoginController animated:YES completion:^{
        //You can comment this line, it's simply so we know that we are currently authenticating the user and presenting the controller
        // NSLog(@"Finished Presenting Authentication Controller");
        
    }];
}
- (void) showLeaderboard{
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        [[GameCenterManager sharedManager] presentLeaderboardsOnViewController:self];
        
    }else{
        //Showing an alert message that Game Center is unavailable
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Highscore" message: @"Game Center is currently unavailable. Make sure you are logged in." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil]; [alert show];
    }
}
//Submitting to leaderboard - the GameCenterManager framework takes care of submitting the score
-(void)submitToLeaderboard: (int)score{
    //Is Game Center available?
    BOOL isAvailable = [[GameCenterManager sharedManager] checkGameCenterAvailability];
    
    if(isAvailable){
        [[GameCenterManager sharedManager] saveAndReportScore:score leaderboard:kLeaderboardIdentifier sortOrder:GameCenterSortOrderHighToLow];
    }
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
