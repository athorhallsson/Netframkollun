//
//  CreateOrderResponseParser.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 31/07/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreateOrderResponseParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *orderId;

- (id)initWithXMLData:(NSData*)data;

@end

