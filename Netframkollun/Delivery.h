//
//  Delivery.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Delivery : NSObject <NSXMLParserDelegate>

@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *deliveryDescription;
@property (nonatomic, strong) NSString *deliveryId;
@property (nonatomic, strong) NSString *price;

@end
