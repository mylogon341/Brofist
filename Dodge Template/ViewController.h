//
//  ViewController.h
//  Dodge Template
//
//  Copyright (c) 2014 Company name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>
#import "GameCenterManager.h"
#import "MylogonAudio.h"
#import <Twitter/Twitter.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <SpriteKit/SpriteKit.h>
#import <Parse/Parse.h>

BOOL go;

bool isiPad;
CGSize screenSize;

@import GoogleMobileAds;

@interface ViewController : UIViewController < SKProductsRequestDelegate,SKPaymentTransactionObserver, GameCenterManagerDelegate>{
    float speed;

    NSArray * objectsArray;
    IBOutlet UIButton *credits;
    UIButton * button;
    IBOutlet UIButton *highscoreButton;
    IBOutlet UIImageView *bgImage;
    IBOutlet UIImageView *bgHills;
    IBOutlet UIImageView *groundImage;
    
    IBOutlet SKView *snowView;
    
    UIImage * normalFistImage;
    UIImage * steelFistImage;
    UIImage * backgroundImage;
    
    int socialAlert;
    
    int startScore;
    
    bool reallyDead;
    

}

@property (weak, nonatomic) IBOutlet UIImageView *hero;

@property (strong, nonatomic) IBOutlet UIImageView *object1;
@property (strong, nonatomic) IBOutlet UIImageView *object2;
@property (strong, nonatomic) IBOutlet UIImageView *object3;
@property (strong, nonatomic) IBOutlet UIImageView *object4;
@property (strong, nonatomic) IBOutlet UIImageView *object5;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIView *gameoverView;
@property (weak, nonatomic) IBOutlet UILabel *finalScore;
@property (weak, nonatomic) IBOutlet UILabel *bestScore;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *instructions;
@property (weak, nonatomic) IBOutlet UIImageView *connecting;
@property (strong, nonatomic) IBOutlet UIImageView *background;

@property (strong, nonatomic) IBOutlet UIImageView * brofistTitle;

@property (weak, nonatomic) IBOutlet GADBannerView *bannerView;


- (IBAction)rate:(id)sender;
- (IBAction)retry:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)highscores:(id)sender;
- (IBAction)noAds:(id)sender;
- (IBAction)restore:(id)sender;
- (IBAction)freePoints:(id)sender;
- (void)gameOver;


@end
