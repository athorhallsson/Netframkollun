//
//  PaymentParser.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 25/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Payment.h"

@interface PaymentParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableDictionary *payments;

- (id)initWithXMLData:(NSData*)data;

@end
