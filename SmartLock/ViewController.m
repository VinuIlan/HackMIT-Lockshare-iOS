//
//  ViewController.m
//  SmartLock
//
//  Created by Vinu Ilangovan on 10/4/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//


#import "ViewController.h"
#import "InfoPage.h"
#import "PermissionsPanelPage.h"

@interface ViewController () <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate>

@end

@implementation ViewController

@synthesize mapview;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Lockshare";
    [self runDefaultSettings];
    [self setUpButtons];
    
    locmanager = [[CLLocationManager alloc] init];
    [locmanager requestWhenInUseAuthorization];
    locmanager.delegate = self;
    locmanager.desiredAccuracy = kCLLocationAccuracyBest;
    gotlocation = TRUE;
    
    mapview.showsUserLocation = YES;
    mapview.userTrackingMode = YES;
}

-(void)runDefaultSettings {
    [self lockDoor];
    NSString *strURL= [NSString stringWithFormat:@"http://locksh.herokuapp.com/revoke"];
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,        NSError *error)
     {
         NSLog(@"Response is:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
     }];
    
}

-(void)viewDidAppear:(BOOL)animated {
    NSInteger lock1ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"Lock1ID"];
    NSInteger lock2ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"Lock2ID"];
    NSInteger mainLock = [[NSUserDefaults standardUserDefaults] integerForKey:@"MainLock"];
    NSString *lockIDString;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock2Ownership"] != NULL && mainLock == 2) {
        lockIDString = [NSString stringWithFormat:@"LockID: %ld", (long)lock2ID];
    }
    else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock1Ownership"] != NULL && mainLock == 1) {
        lockIDString = [NSString stringWithFormat:@"LockID: %ld", (long)lock1ID];
    }
    else {
        lockIDString = @"LockID: N/A";
    }
    _lockIDLabel.text = lockIDString;
}

-(void)lockDoor {
    NSLog(@"LOCK");
    NSString *strURL= [NSString stringWithFormat:@"http://locksh.herokuapp.com/lock"];
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,        NSError *error)
     {
         NSLog(@"Response is:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
     }];
    [_normalLockButton setTitle: @"Unlock door" forState: UIControlStateNormal];
}

-(void)unlockDoor {
    NSLog(@"UNLOCK");
    NSString *strURL= [NSString stringWithFormat:@"http://locksh.herokuapp.com/unlock"];
    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
    [NSURLConnection sendAsynchronousRequest:requestURL
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data,        NSError *error)
     {
         NSLog(@"Response is:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
     }];
    [_normalLockButton setTitle: @"Lock door" forState: UIControlStateNormal];
}

-(void)authUnlockDoor {
    NSLog(@"authenticate function");
    LAContext *localAuthenticationContext = [[LAContext alloc] init];
    NSError *authenticationError;
    NSString *localizedReasonString = NSLocalizedString(@"Authenticate to unlock your door", @"Authenication is required to unlock your door");
    
    if ([localAuthenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authenticationError]) {
        
        [localAuthenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                                   localizedReason:localizedReasonString
                                             reply:^(BOOL succes, NSError *error) {
                                                 
                                                 if (succes) {
                                                     NSLog(@"User is authenticated successfully");
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         [self unlockDoor];
                                                     });
                                                     
                                                 } else {
                                                     bool usePassCode = NO;
                                                     switch (error.code) {
                                                         case LAErrorAuthenticationFailed:
                                                             NSLog(@"Authentication Failed");
                                                             usePassCode = YES;
                                                             break;
                                                             
                                                         case LAErrorUserCancel:
                                                             NSLog(@"User pressed Cancel button");
                                                             usePassCode = NO;
                                                             break;
                                                             
                                                         case LAErrorUserFallback:
                                                             NSLog(@"User pressed \"Enter Password\"");
                                                             usePassCode = YES;
                                                             break;
                                                             
                                                         default:
                                                             NSLog(@"Touch ID is not configured");
                                                             usePassCode = YES;
                                                             break;
                                                     }
                                                     
                                                     NSLog(@"Authentication Fails");
                                                     //[self didNotAuthenticate];
                                                     dispatch_async(dispatch_get_main_queue(), ^{
                                                         if (usePassCode) {
                                                             [self authPassCode];
                                                         }
                                                     });
                                                 }
                                             }];
    } else {
        NSLog(@"Can not evaluate Touch ID");
        [self authPassCode];
    }
}

-(void)authPassCode {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Enter Passcode" message:@"Please enter your passcode to unlock your door" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
    alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    alert.tag = 5;
    [[alert textFieldAtIndex:0] setDelegate:self];
    [[alert textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeNumberPad];
    [[alert textFieldAtIndex:0] becomeFirstResponder];
    [alert show];
}

-(void)didNotAuthenticate {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Passcode Incorrect" message:@"Did not unlock door" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

-(void)setUpButtons {
    UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [infoButton addTarget:self
                   action:@selector(showinfoPage:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *infoBarButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
    
    self.navigationItem.rightBarButtonItems = @[infoBarButton];
    
    _locationLockButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _locationLockButton.titleLabel.textAlignment = NSTextAlignmentCenter; // if you want to
    [_locationLockButton setTitle: @"Lock door when leaving\nthis location" forState: UIControlStateNormal];
    [_locationLockButton addTarget:self action:@selector(runLocationLockButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_normalLockButton setTitle: @"Unlock door" forState: UIControlStateNormal];
    [_normalLockButton addTarget:self action:@selector(runNormalLockButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_permissionsPanelButton addTarget:self action:@selector(runPermissionsPanelButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_reloadLockIDButton addTarget:self action:@selector(runReloadLockButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)showinfoPage:(id)sender {
    NSLog(@"Info Button");
    InfoPage * infopage = [[InfoPage alloc] init];
    infopage = [self.storyboard instantiateViewControllerWithIdentifier:@"infoPageController"];
    UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:infopage];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)runLocationLockButton:(id)sender {
    NSLog(@"location");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock1Ownership"] != NULL) {
        if (mapview.showsUserLocation == YES) {
            //NSLog(@"alertme called");
            //locmanager.delegate = self;
            //locmanager.desiredAccuracy = kCLLocationAccuracyBest;
            
            gotlocation = FALSE;
            [_locationLockButton setTitle: @"Door will now lock when\nleaving this location" forState: UIControlStateNormal];
            [locmanager startUpdatingLocation];
            
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Lock Access" message:@"You currently don't have access to a lock" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)runNormalLockButton:(id)sender {
    NSLog(@"normal");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock1Ownership"] != NULL) {
        if ([_normalLockButton.titleLabel.text isEqualToString:@"Unlock door"]){
            [self authUnlockDoor];
        }else if ([_normalLockButton.titleLabel.text isEqualToString:@"Lock door"]) {
            [self lockDoor];
        }
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Lock Access" message:@"You currently don't have access to a lock" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)runPermissionsPanelButton:(id)sender {
    NSLog(@"permissions");
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock1Ownership"] != NULL) {
        PermissionsPanelPage * permissionpage = [[PermissionsPanelPage alloc] init];
        permissionpage = [self.storyboard instantiateViewControllerWithIdentifier:@"PermissionsPageController"];
        UINavigationController * navController = [[UINavigationController alloc] initWithRootViewController:permissionpage];
        [self presentViewController:navController animated:YES completion:nil];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Lock Access" message:@"You currently don't have access to a lock" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

-(void)runReloadLockButton:(id)sender {
    NSLog(@"Reload Lock ID");
    
    NSURL *URL = [[NSURL alloc] initWithString:@"http://locksh.herokuapp.com/lockIDstatus"];
    NSError *error;
    NSString *stringFromFileAtURL = [[NSString alloc]
                                     initWithContentsOfURL:URL
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    
    //NSLog(@"%@", stringFromFileAtURL);
    
    if ([stringFromFileAtURL length] != 0) {
        if ([[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"]==2) {
            if ([stringFromFileAtURL isEqualToString:@"shawn vinu"]) {
                NSLog(@"%@", stringFromFileAtURL);
                [[NSUserDefaults standardUserDefaults] setInteger:606 forKey:@"Lock1ID"];
                [[NSUserDefaults standardUserDefaults] setObject:@"admin" forKey:@"Lock1Ownership"];
            }
            else {
                [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Lock1ID"];
                [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Lock1Ownership"];
            }
        }
        
        
        NSInteger lock1ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"Lock1ID"];
        NSInteger lock2ID = [[NSUserDefaults standardUserDefaults] integerForKey:@"Lock2ID"];
        NSInteger mainLock = [[NSUserDefaults standardUserDefaults] integerForKey:@"MainLock"];
        NSString *lockIDString;
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock2Ownership"] != NULL && mainLock == 2) {
            lockIDString = [NSString stringWithFormat:@"LockID: %ld", (long)lock2ID];
        }
        else if ([[NSUserDefaults standardUserDefaults] objectForKey:@"Lock1Ownership"] != NULL && mainLock == 1) {
            lockIDString = [NSString stringWithFormat:@"LockID: %ld", (long)lock1ID];
        }
        else {
            lockIDString = @"LockID: N/A";
        }
        _lockIDLabel.text = lockIDString;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 5)
    {
        UITextField * password = [alertView textFieldAtIndex:0];
        NSString * passString = password.text;
        int passcode = [passString intValue];
        NSInteger userpasscode = [[NSUserDefaults standardUserDefaults] integerForKey:@"PassCode"];
        if ([password.text length] != 0 && passcode == userpasscode) {
            [self unlockDoor];
        }
        else {
            [self didNotAuthenticate];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSInteger x = locations.count - 1;
    
    if (gotlocation == FALSE) {
        startLoc = locations[x];
        //NSLog(@" %@", locations[x]);
        gotlocation = TRUE;
    }
    
    int distance = [locations[x] distanceFromLocation:startLoc];
    //NSString *string = [NSString stringWithFormat:@"%d", distance];
    //[_locationLockButton setTitle:string forState: UIControlStateNormal];
    
    if (distance > 7) {
        //NSLog(@" %@", locations[x]);
        //NSLog(@"send alert");
        
        [self lockDoor];
        [_locationLockButton setTitle: @"Lock door when leaving\nthis location" forState: UIControlStateNormal];
        [locmanager stopUpdatingLocation];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Door has locked" message:@"You are now leaving the set location" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        
        
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
