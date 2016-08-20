//
//  SessionManager.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "SessionManager.h"

@implementation SessionManager

+ (void)signInUser: (User *)user {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"SignedIn"];
    
    [defaults setObject:user.name forKey:@"Name"];
    // [defaults setObject:user.password forKey:@"Password"];
    [defaults setObject:user.email forKey:@"Email"];
    [defaults setObject:user.ssn forKey:@"Ssn"];
    [defaults setObject:user.phone forKey:@"Phone"];
    [defaults setObject:user.address forKey:@"Address"];
    [defaults setObject:user.pCode forKey:@"PCode"];
    [defaults setObject:user.userId forKey:@"UserId"];
    
    [defaults synchronize];
}

+ (void)signOutUser {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:NO forKey:@"SignedIn"];

    [defaults setObject:@"" forKey:@"Name"];
    [defaults setObject:@"" forKey:@"Email"];
    [defaults setObject:@"" forKey:@"Ssn"];
    [defaults setObject:@"" forKey:@"Phone"];
    [defaults setObject:@"" forKey:@"Address"];
    [defaults setObject:@"" forKey:@"PCode"];
    [defaults setObject:@"" forKey:@"UserId"];
    
    [defaults synchronize];
}

+ (BOOL)isSignedIn {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"SignedIn"];
}

+ (User *)getSignedInUser {
    User *user = [[User alloc] init];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    user.name = [defaults objectForKey:@"Name"];
    user.email = [defaults objectForKey:@"Email"];
    user.ssn = [defaults objectForKey:@"Ssn"];
    user.phone = [defaults objectForKey:@"Phone"];
    user.address = [defaults objectForKey:@"Address"];
    user.pCode = [defaults objectForKey:@"PCode"];
    user.userId = [defaults objectForKey:@"UserId"];

    return user;
}

@end
