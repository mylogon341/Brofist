//
//  ViewController.m
//  Dodge Template
//
//  Copyright (c) 2014 Chempo.com. All rights reserved.
//

#import "ViewController.h"
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    speed = 1;
    
    startScore = 0;
    
    _connecting.hidden = YES;
    [[GameCenterManager sharedManager] setDelegate:self];
    
    self.banner.adUnitID = adID;
    
    objectsArray = [NSArray arrayWithObjects:_object1,_object2,_object3,_object4,_object5, nil];
    
    self.banner.delegate = self;
    self.banner.rootViewController = self;
    [self.banner loadRequest: [GADRequest request]];
    
    gameState = kGameStateMenu;
    
    
    _scoreLabel.font = [UIFont fontWithName:@"debussy" size:35];
    _scoreLabel.textColor = [UIColor whiteColor];
    
    _finalScore.font = [UIFont fontWithName:@"debussy" size:20];
    _finalScore.textColor = [UIColor grayColor];
    
    _bestScore.font = [UIFont fontWithName:@"debussy" size:20];
    _bestScore.textColor = [UIColor blackColor];
    
    
    [self menu];
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
    [self resetHero];
    CGRect menu;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    go = NO;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            menu= CGRectMake(17,79,287,360);
        }
        else{
            menu= CGRectMake(17,56,287,360);
        }
        
    }
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _titleView.frame = menu;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    
}
- (IBAction)play:(id)sender {
    _instructions.hidden = YES;
    _scoreLabel.hidden = NO;
    score = startScore;
    _scoreLabel.text = @"0";
    
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
    [self resetHero];
    gameState = kGameStateRunning;
    
    CGRect menu;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            menu= CGRectMake(17,700,287,270);
        }
        else{
            menu= CGRectMake(17,600,287,270);
        }
        
    }
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _titleView.frame = menu;
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
    CGRect done;
    go = NO;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            done = CGRectMake(16,700,280,286);
        }
        else{
            done = CGRectMake(16,600,280,286);
        }
        
    }
    
    [_object1 setCenter:CGPointMake(arc4random_uniform(320), -220)];
    [self coll];
    
    [button removeFromSuperview];
    speed = 1;
    
    [UIView animateWithDuration: 0.6f
                          delay: 0.3f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _gameoverView.frame = done;
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
    
    if (gameState == kGameStateOver) {
        speed = 5;
    }
    
    
    _object1.center = CGPointMake(_object1.center.x, _object1.center.y + speed);
    _object2.center = CGPointMake(_object2.center.x, _object2.center.y + speed);
    _object3.center = CGPointMake(_object3.center.x, _object3.center.y + speed);
    _object4.center = CGPointMake(_object4.center.x, _object4.center.y + speed);
    _object5.center = CGPointMake(_object5.center.x, _object5.center.y + speed);
    
    
    if(gameState == kGameStateRunning ){
        
        
        if(_object1.center.y > 660){
            [self initObject1];
        }
        
        if(_object2.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object3.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object4.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        if(_object5.center.y > 660){
            gameState = kGameStateOver;
            [self gameOver];
        }
        
        //check collision
        CGRect heroRect = CGRectMake(_hero.frame.origin.x, _hero.frame.origin.y, _hero.frame.size.width - 15 , _hero.frame.size.height - 50);
        
        if(CGRectIntersectsRect(heroRect, _object1.frame)){
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
    
    
    CGRect heroRect;
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            heroRect = CGRectMake(_hero.frame.origin.x,700,39,48);
        }
        else{
            heroRect = CGRectMake(_hero.frame.origin.x,600,39,48);
        }
        
    }
    
    
    CGRect heroUp = CGRectMake(_hero.frame.origin.x, _hero.frame.origin.y - 30, _hero.frame.size.width, _hero.frame.size.height);
    
    [UIView animateWithDuration: 0.2f
                          delay: 0.0f
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         _hero.frame = heroUp;
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration: 0.5f
                                               delay: 0.1f
                                             options: UIViewAnimationOptionCurveEaseIn
                                          animations:^{
                                              _hero.frame = heroRect;
                                          }
                                          completion:^(BOOL finished){
                                              // [self gameOver];
                                          }];
                     }];
    
    
    
    
    
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
    
    CGRect gameOver;
    
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            gameOver= CGRectMake(20,88,280,400);
            
        }
        else{
            gameOver= CGRectMake(20,57,280,400);
        }
        
    }
    
    
    [UIView animateWithDuration: 1.0f
                     animations:^{
                         _gameoverView.frame = gameOver;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    socialAlert = [[defaults objectForKey:@"alert"]intValue];
    
    //   socialAlert = 1;
    
    int random = arc4random()%2;
    NSLog(@"%d",random);
    if (random == 1) {
        [self performSelector:@selector(freePointsLoad) withObject:nil];
        //   [self performSelector:@selector(freePointsLoad) withObject:nil afterDelay:0.5];
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
    
    //   socialAlert = 1;
    
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
            
            
            // Check if the Facebook app is installed and we can present the share dialog
            FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
            params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
            
            // If the Facebook app is installed and we can present the share dialog
            if ([FBDialogs canPresentShareDialogWithParams:params]) {
                
                // Present share dialog
                [FBDialogs presentShareDialogWithLink:params.link
                                              handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                  if(error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      // Success
                                                      NSLog(@"result %@", results);
                                                  }
                                              }];
                
                // If the Facebook app is NOT installed and we can't present the share dialog
            } else {
                // FALLBACK: publish just a link using the Feed dialog
                
                // Put together the dialog parameters
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                               @"BroFist", @"name",
                                               @"How Many BroFists Can You Give?", @"caption",
                                               @"Get BroFist today for free on iOS and compete against friends. Who will get the global High Score?!", @"description",
                                               @"https://itunes.apple.com/us/app/brofist-game-how-many-brofists/id894589832?mt=8", @"link",
                                               @"http://a5.mzstatic.com/us/r30/Purple4/v4/c4/77/28/c477287c-ba75-44e0-faca-4a65147b186a/mzl.zdzbmeob.175x175-75.jpg", @"picture",
                                               nil];
                
                
                [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                       parameters:params
                                                          handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                              if (error) {
                                                                  // An error occurred, we need to handle the error
                                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                                  NSLog(@"Error publishing story: %@", error.description);
                                                              } else {
                                                                  if (result == FBWebDialogResultDialogNotCompleted) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                  } else {
                                                                      // Handle the publish feed callback
                                                                      NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                      
                                                                      if (![urlParams valueForKey:@"post_id"]) {
                                                                          // User canceled.
                                                                          NSLog(@"User cancelled.");
                                                                          
                                                                      } else {
                                                                          // User clicked the Share button
                                                                          startScore = 50;
                                                                          NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                          NSLog(@"result %@", result);
                                                                      }
                                                                  }
                                                              }
                                                          }];
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
                [tweetSheet setInitialText:@"Check out BroFist on iOS for FREE!"];
                
                //  Adds an image to the Tweet.  For demo purposes, assume we have an
                //  image named 'larry.png' that we wish to attach
                if (![tweetSheet addImage:[UIImage imageNamed:@"steelFIST"]]) {
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
-(void)resetHero{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if(UI_USER_INTERFACE_IDIOM() == UI_USER_INTERFACE_IDIOM()){
        if(screenSize.height >480.0f){
            _hero.frame = CGRectMake(141,399,39,48);
        }
        else{
            _hero.frame = CGRectMake(141,331,39,48);
        }
    }
}

-(void)initObject1{
    int steelX = arc4random_uniform(320) ;
    int h = -(arc4random() %110);
    _object1.center = CGPointMake(steelX, h);
    
    [self coll];
}

-(void)coll{
    
    if (_object1.center.y < 20) {
        
        if (CGRectIntersectsRect(_object1.frame, _object2.frame) || (CGRectIntersectsRect(_object1.frame, _object2.frame) || (CGRectIntersectsRect(_object1.frame, _object3.frame) || (CGRectIntersectsRect(_object1.frame, _object4.frame) || (CGRectIntersectsRect(_object1.frame, _object5.frame)))))){
            
            _object1.center = CGPointMake(arc4random_uniform(320), -160);
        }
    }
}


-(void)initObject2{
    int r = arc4random_uniform(320) ;
    int h = -(arc4random() %120);
    _object2.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject3{
    int r = arc4random_uniform(320) ;
    int h = -(arc4random() %120);
    _object3.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject4{
    int r = arc4random_uniform(320);
    int h = -(arc4random() %120);
    _object4.center = CGPointMake(r, h);
    [self coll];
}

-(void)initObject5{
    int r = arc4random_uniform(320);
    int h = -(arc4random() %120);
    _object5.center = CGPointMake(r, h);
    [self coll];
}


#pragma mark - AdMob Banner

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey: @"noads"] != nil &&
        [[defaults objectForKey: @"noads"] isEqualToString: @"YES"]) {
        self.banner.hidden = YES;
        
    }
    else {
        self.banner.hidden = NO;
    }
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError: (GADRequestError *)error {
    self.banner.hidden = YES;
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
    self.banner.hidden = YES;
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
