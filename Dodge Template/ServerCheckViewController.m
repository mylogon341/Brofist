//
//  ServerCheckViewController.m
//  Dodge Template
//
//  Created by Luke Sadler on 02/06/2015.
//  Copyright (c) 2015 Chempo. All rights reserved.
//

#import "ServerCheckViewController.h"

@interface ServerCheckViewController ()

@end

@implementation ServerCheckViewController

-(void)stillChecking{
    
    if (!connected) {
        hud.labelText = @"There seems to be a problem...";
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    successStories = 0;
    databaseObjects = 0;
    
    [header setFrame:CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.width * 0.4)];
    
    // Do any additional setup after loading the view.

//    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
//    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    [hud setAnimationType:MBProgressHUDAnimationFade];
    [hud setDimBackground:YES];
    hud.labelText = @"Checking for updates";
    [self performSelector:@selector(stillChecking) withObject:nil afterDelay:8];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Assets"];
    
    
    [query getObjectInBackgroundWithId:@"i3Pzu5NZ4w" block:^(PFObject * object, NSError *error){
        
        if (!error) {
            connected = YES;
            
            int version = [object[@"versionNumber"] intValue];

            if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"version"] intValue] != version) {
                //New version
                [[NSUserDefaults standardUserDefaults]setValue:[NSNumber numberWithInt:version] forKey:@"version"];
                hud.labelText = @"Retrieving data";

                [query getObjectInBackgroundWithId:@"MIKn84FM22" block:^(PFObject *obj,NSError*err){
                    if (!err) {
                        
                        [hud setMode:MBProgressHUDModeDeterminateHorizontalBar];

                        databaseObjects = (int)[obj.allKeys count]-3;
                        
                        PFFile * musicFile = obj[@"music"];
                        PFFile * fistFile = obj[@"standardFist"];
                        PFFile * steelFile = obj[@"steelFist"];
                        PFFile * background = obj[@"background"];
                        PFFile * brofistTitle = obj[@"title"];
    
                        [brofistTitle getDataInBackgroundWithBlock:^(NSData *result,NSError *err){
                            if (!err) {
                                [obj pinInBackgroundWithName:@"data" block:^(BOOL success,NSError * error){
                                    if (success) {
                                        [self allSucceeded];
                                    }
                                }];
                            }
                        }];
                        
                        [fistFile getDataInBackgroundWithBlock:^(NSData *result,NSError *err){
                            if (!err) {
                                [obj pinInBackgroundWithName:@"data" block:^(BOOL success,NSError * error){
                                    if (success) {
                                        [self allSucceeded];
                                    }
                                }];
                            }
                        }];
                        
                        [steelFile getDataInBackgroundWithBlock:^(NSData *result,NSError *err){
                            if (!err) {
                                [obj pinInBackgroundWithName:@"data" block:^(BOOL success,NSError * error){
                                    if (success) {
                                        [self allSucceeded];
                                    }
                                }];
                            }
                        }];
                        
                        [background getDataInBackgroundWithBlock:^(NSData *result,NSError *err){
                            if (!err) {
                                [obj pinInBackgroundWithName:@"data" block:^(BOOL success,NSError * error){
                                    if (success) {
                                        [self allSucceeded];
                                    }
                                }];
                            }
                        }];
                        
                        [musicFile getDataInBackgroundWithBlock:^(NSData *result,NSError *err){
                            if (!err) {
                                [obj pinInBackgroundWithName:@"data" block:^(BOOL success,NSError * error){
                                    if (success) {
                                        [self allSucceeded];
                                    }
                                }];
                            }
                        }progressBlock:^(int progress){
                            hud.progress = (float)progress/100;
                        }];

                        [obj incrementKey:@"timesDownloaded"];
                        [obj saveInBackground];
                    
                    }
                }];
            }else{
                //Version number the same
                [self performSegueWithIdentifier:@"start" sender:self];
            }
            
        }else{
            
            PFQuery *checkQuery = [PFQuery queryWithClassName:@"Assets"];
            [checkQuery fromLocalDatastore];
            [checkQuery getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
               
                if (object.allKeys.count == 0) {
                    [hud hide:YES];
                    
                    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Failed to load" message:@"Failed to retrieve any data.\nAn internet connection is required on at least the first launch." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else {
                    [self performSegueWithIdentifier:@"start" sender:self];

                }
                
            }];
            
            //Error connecting. No internet?
        }
        
    }];
}

-(void)allSucceeded{
    
    successStories ++;
    NSLog(@"%d %d", successStories,databaseObjects);
    if (successStories == databaseObjects) {
        [self performSegueWithIdentifier:@"start" sender:self];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
