//
//  SessionManager.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 20/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface SessionManager : NSObject

+ (void)signInUser: (User *)user;

+ (void)signOutUser;

+ (BOOL)isSignedIn;

+ (User *)getSignedInUser;

@end
