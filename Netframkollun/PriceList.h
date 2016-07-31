//
//  PriceList.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 26/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriceList : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSString *priceListId;
@property (strong, nonatomic) NSString *minCost;

- (id)initWithXMLData:(NSData*)data;

@end
