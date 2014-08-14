//
//  ViewController.h
//  Dodge Template
//
//  Copyright (c) 2014 Company name. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADBannerView.h"
#import "GADBannerViewDelegate.h"
#import <StoreKit/StoreKit.h>
#import "GameCenterManager.h"
#import "MylogonAudio.h"
#import <Twitter/Twitter.h>
#import <FacebookSDK/FacebookSDK.h>

BOOL go;

@interface ViewController : UIViewController <GADBannerViewDelegate, SKProductsRequestDelegate,SKPaymentTransactionObserver, GameCenterManagerDelegate>{
    float speed;

    GADBannerView *bannerView_;

    NSArray * objectsArray;
    IBOutlet UIButton *credits;
    UIButton * button;
    IBOutlet UIButton *highscoreButton;
    
    int socialAlert;
    
    int startScore;
    

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

- (IBAction)rate:(id)sender;
- (IBAction)retry:(id)sender;
- (IBAction)play:(id)sender;
- (IBAction)highscores:(id)sender;
- (IBAction)noAds:(id)sender;
- (IBAction)restore:(id)sender;
- (IBAction)freePoints:(id)sender;
- (void)gameOver;


@end
