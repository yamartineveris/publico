//
//  RSSUtils.h
//  RSSReader
//
//  Created by Yago de Martin Lopez on 4/7/17.
//  Copyright © 2017 Yago de Martin Lopez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSUtils : NSObject



+ (NSString *)firstImgUrlString:(NSString *)string;

+(NSString *)stringByStrippingHTML:(NSString*)str;

@end
