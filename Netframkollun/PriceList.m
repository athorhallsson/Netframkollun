//
//  PriceList.m
//  Netframkollun
//
//  Created by Andri Thorhallsson on 26/04/16.
//  Copyright © 2016 Andri Thorhallsson. All rights reserved.
//

#import "PriceList.h"

@interface PriceList ()

@property (strong, nonatomic) NSString *parseString;

@end

@implementation PriceList

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
    if ([elementName isEqualToString:@"b:ID"]) {
        [self setPriceListId:_parseString];
    }
    else if ([elementName isEqualToString:@"b:MinimumCost"]) {
        [self setMinCost:_parseString];
    }
}

@end