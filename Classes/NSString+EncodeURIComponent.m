//
//  NSString+EncodeURIComponent.m
//  OpenAround
//
//  Created by Watanabe Toshinori on 10/12/01.
//  Copyright 2010 FLCL.jp. All rights reserved.
//

#import "NSString+EncodeURIComponent.h"


@implementation NSString (EncodeURIComponent)

+ (NSString*)stringEncodeURIComponent:(NSString *)string {
    return [((NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
																(CFStringRef)string,
																NULL,
																(CFStringRef)@"!*'();:@&=+$,/?%#[]",
																kCFStringEncodingUTF8)) autorelease];
}

@end
