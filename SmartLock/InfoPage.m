//
//  InfoPage.m
//  SmartLock
//
//  Created by Vinu Ilangovan on 10/4/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import "InfoPage.h"

@interface InfoPage ()

@end

@implementation InfoPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *closeBarButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Done" style:UIBarButtonItemStyleDone
                                       target:self
                                       action:@selector(closeWindow:)];
    
    self.navigationItem.rightBarButtonItems = @[closeBarButton];
    
    [self.user1Button addTarget:self action:@selector(setUser1:) forControlEvents:UIControlEventTouchUpInside];
    [self.user2Button addTarget:self action:@selector(setUser2:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)closeWindow:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*NSDate *endDate = [NSDate date];
 NSTimeInterval timeinterval = 120;
 NSDate *newEndDate = [[NSDate alloc] initWithTimeInterval:timeinterval sinceDate:endDate];
 NSLog(@"%@", endDate);
 NSLog(@"new %@", newEndDate);*/

-(void)setUser1:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Shawn" forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setInteger:1234 forKey:@"PassCode"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MainLock"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:606 forKey:@"Lock1ID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"admin" forKey:@"Lock1Ownership"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Lock2ID"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Lock2Ownership"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUser2:(id)sender {
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"UserID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"Vinu" forKey:@"UserName"];
    [[NSUserDefaults standardUserDefaults] setInteger:1111 forKey:@"PassCode"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"MainLock"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Lock1ID"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Lock1Ownership"];
    
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"Lock2ID"];
    [[NSUserDefaults standardUserDefaults] setObject:NULL forKey:@"Lock2Ownership"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
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
