//
//  GameViewController.m
//  Greedy Zookeeper
//
//  Created by Luke Sadler on 29/06/2014.
//  Copyright (c) 2014 mylogon. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController ()


@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(isiPad)
    {
        creditsView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 2, 2);
    }
    creditsView.center = CGPointMake(self.view.frame.size.width/2, screenSize.height/2);

    groundImage.frame = CGRectMake(0, 0, self.view.frame.size.width, 60);
    bgView.frame = self.view.frame;

}

-(IBAction)back:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //      [self performSegueWithIdentifier:@"Menu" sender:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
