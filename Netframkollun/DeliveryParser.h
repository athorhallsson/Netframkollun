//
//  DeliveryParser.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Delivery.h"

@interface DeliveryParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *deliveries;

- (id)initWithXMLData:(NSData*)data;


@end
