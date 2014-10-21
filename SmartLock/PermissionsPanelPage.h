//
//  PermissionsPanelPage.h
//  SmartLock
//
//  Created by Vinu Ilangovan on 10/4/14.
//  Copyright (c) 2014 Vinu Ilangovan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PermissionsPanelPage : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField * userfield;

@property (strong, nonatomic) IBOutlet UITextField * timefield;

@property (strong, nonatomic) IBOutlet UITextField * lockfield;

@property (strong, nonatomic) IBOutlet UIButton * giveButton;

@property (strong, nonatomic) IBOutlet UIButton * revokeButton;

@end
