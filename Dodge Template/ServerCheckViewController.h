//
//  ServerCheckViewController.h
//  Dodge Template
//
//  Created by Luke Sadler on 02/06/2015.
//  Copyright (c) 2015 Chempo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "ViewController.h"

@interface ServerCheckViewController : UIViewController
{
    int successStories;
    int databaseObjects;
    MBProgressHUD * hud;
    
    IBOutlet UIImageView * header;
    
    BOOL connected;
}
@end
