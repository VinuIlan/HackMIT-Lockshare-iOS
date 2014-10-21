//
//  PermissionsPanelPage.m
//  SmartLock
//
//  Created by Vinu Ilangovan on 10/4/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "PermissionsPanelPage.h"

@interface PermissionsPanelPage ()

@end

@implementation PermissionsPanelPage {
    UITapGestureRecognizer *tap;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(closeWindow:)];
    
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    [_giveButton addTarget:self action:@selector(runGiveButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_revokeButton addTarget:self action:@selector(runRevokeButton:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)runGiveButton:(id)sender {
    NSLog(@"Give permission");
    NSString *nameString = _userfield.text;
    int timeLimit = [_timefield.text intValue]*60*60;
    int lockIDInt = [_lockfield.text intValue];
    
    NSDate *endDate = [NSDate date];
    NSTimeInterval timeinterval = timeLimit;
    NSDate *newEndDate = [[NSDate alloc] initWithTimeInterval:timeinterval sinceDate:endDate];
    NSLog(@"%@, %@, %d",nameString, newEndDate, lockIDInt);
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"]==1) {
        if ([nameString isEqualToString:@"Vinu"] || [nameString isEqualToString:@"vinu"]) {
            if (lockIDInt == 606) {
                if (timeLimit > 0) {
                    NSLog(@"SEND GIVE");
                    
                    NSString *strURL= [NSString stringWithFormat:@"http://locksh.herokuapp.com/give"];
                    NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                    NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
                    [NSURLConnection sendAsynchronousRequest:requestURL
                                                       queue:[NSOperationQueue mainQueue]
                                           completionHandler:^(NSURLResponse *response, NSData *data,        NSError *error)
                     {
                         NSLog(@"Response is:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                     }];
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Given" message:@"Permission has been given to the specified user" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a valid Time Limit" message:@"Please provide a valid time limit." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                    [alert show];
                }
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a valid Lock ID" message:@"Please check to make sure the Lock ID you provided is correct." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a valid user" message:@"Please check spelling of user you wish to give permission to." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

-(void)runRevokeButton:(id)sender {
    NSLog(@"Revoke permission");
    NSString *nameString = _userfield.text;
    int lockIDInt = [_lockfield.text intValue];
    NSLog(@"%@, %d",nameString, lockIDInt);
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"UserID"]==1) {
        if ([nameString isEqualToString:@"Vinu"] || [nameString isEqualToString:@"vinu"]) {
            if (lockIDInt == 606) {
                //revoke
                NSLog(@"SEND REVOKE");
                
                NSString *strURL= [NSString stringWithFormat:@"http://locksh.herokuapp.com/revoke"];
                NSURL *URL = [NSURL URLWithString:[strURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                NSURLRequest *requestURL = [[NSURLRequest alloc] initWithURL:URL];
                [NSURLConnection sendAsynchronousRequest:requestURL
                                                   queue:[NSOperationQueue mainQueue]
                                       completionHandler:^(NSURLResponse *response, NSData *data,        NSError *error)
                 {
                     NSLog(@"Response is:%@",[[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding]);
                 }];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Permission Revoked" message:@"Permission has been revoked from the specified user" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
            }
            else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a valid Lock ID" message:@"Please check to make sure the Lock ID you provided is correct." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
            }
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not a valid user" message:@"Please check spelling of user you wish to revoke permission from." delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
    }
}

/*NSDate *endDate = [NSDate date];
 NSTimeInterval timeinterval = 120;
 NSDate *newEndDate = [[NSDate alloc] initWithTimeInterval:timeinterval sinceDate:endDate];
 NSLog(@"%@", endDate);
 NSLog(@"new %@", newEndDate);*/

/*-(void)textFieldDidBeginEditing:(UITextField *)textField {
    [self moveView:self.view :0 :-70 :0.5];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    [self moveView:self.view :0 :0 :0.5];
}

-(void)moveView:(UIView *)viewToMove :(float)xorigin :(float)yorigin :(float)duration {
    [UIView animateWithDuration:duration
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^
     {
         CGRect frame = viewToMove.frame;
         frame.origin.y = yorigin;
         frame.origin.x = xorigin;
         viewToMove.frame = frame;
     }
                     completion:nil];
}*/

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    tap = [[UITapGestureRecognizer alloc]
           initWithTarget:self
           action:@selector(dismissKeyboard)];
    
    [tap setNumberOfTapsRequired:1];
    [tap setCancelsTouchesInView:NO];
    
    [self.view addGestureRecognizer:tap];
}

-(void)viewDidDisappear:(BOOL)animated {
    [self.view removeGestureRecognizer:tap];
}

-(void)dismissKeyboard {
    [_userfield resignFirstResponder];
    [_timefield resignFirstResponder];
    [_lockfield resignFirstResponder];
}

- (BOOL)disablesAutomaticKeyboardDismissal {
    return NO;
}

-(void)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
