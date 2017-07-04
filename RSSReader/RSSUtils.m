//
//  RSSUtils.m
//  RSSReader
//
//  Created by Yago de Martin Lopez on 4/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import "RSSUtils.h"

@implementation RSSUtils


+(NSString *)firstImgUrlString:(NSString *)string
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(<img\\s[\\s\\S]*?src\\s*?=\\s*?['\"](.*?)['\"][\\s\\S]*?>)+?"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    
    NSTextCheckingResult *result = [regex firstMatchInString:string
                                                     options:0
                                                       range:NSMakeRange(0, [string length])];
    
    if (result)
        return [string substringWithRange:[result rangeAtIndex:2]];
    
    return nil;
}

+(NSString *)stringByStrippingHTML:(NSString*)str
{
    NSRange r;
    while ((r = [str rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location     != NSNotFound)
    {
        str = [str stringByReplacingCharactersInRange:r withString:@""];
    }
    
    str = [str stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    
    return str;
}

@end
