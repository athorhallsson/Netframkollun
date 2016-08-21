//
//  PostalCodeParser.h
//  Netframkollun
//
//  Created by Andri Thorhallsson on 21/08/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostalCodeParser : NSObject <NSXMLParserDelegate>

@property (strong, nonatomic) NSMutableArray *locations;
@property (strong, nonatomic) NSMutableArray *pCodes;

- (id)initWithXMLData:(NSData*)data;

@end
