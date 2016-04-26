//
//  Payment.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Payment : NSObject 

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *paymentDescription;
@property (nonatomic, strong) NSString *paymentId;
@property (nonatomic, strong) NSString *price;

@end
