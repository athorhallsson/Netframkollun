//
//  CreateOrderResponseParser.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 31/07/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "CreateOrderResponseParser.h"
@interface CreateOrderResponseParser()
@property (strong, nonatomic) NSString *parseString;
@end

@implementation CreateOrderResponseParser


- (id)initWithXMLData:(NSData*)data {
    self = [super init];
    
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:data];
    xmlParser.delegate = self;
    [xmlParser parse];
    
    return self;
}

// XML parser

-(void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:
(NSString *)qName attributes:(NSDictionary *)attributeDict {
    _parseString = @"";
}
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    _parseString = [_parseString stringByAppendingString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"b:Description"]) {
        _orderId = [NSString stringWithString:_parseString];
    }
}


@end
