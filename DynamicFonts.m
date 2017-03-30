/**
 * Copyright (c) 2017-present, Wyatt Greenway. All rights reserved.
 *
 * This source code is licensed under the MIT license found in the LICENSE file in the root
 * directory of this source tree.
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "DynamicFonts.h"

@implementation DynamicFonts

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(loadFont:(NSDictionary *)options callback:(RCTResponseSenderBlock)callback)
{
  NSString *name = [options valueForKey:@"name"];
  NSString *data = [options valueForKey:@"data"];
  NSString *type = NULL;
  
  if ([name isEqual:[NSNull null]]) {
    callback(@[@"Name property is empty"]);
    return;
  }

  if ([data isEqual:[NSNull null]]) {
    callback(@[@"Data property is empty"]);
    return;
  }

  if ([[[data substringWithRange:NSMakeRange(0, 5)] lowercaseString] isEqualToString:@"data:"]) {
    NSArray *parts = [data componentsSeparatedByString:@","];
    NSString *mimeType = [parts objectAtIndex:0];

    data = [parts objectAtIndex:1];

    if (![mimeType isEqual:[NSNull null]]) {
      mimeType = [[[mimeType substringFromIndex:5] componentsSeparatedByString:@";"] objectAtIndex:0];

      if ([mimeType isEqualToString:@"application/x-font-ttf"] || 
          [mimeType isEqualToString:@"application/x-font-truetype"] ||
          [mimeType isEqualToString:@"font/ttf"]) {
        type = @"ttf";
      } else if ( [mimeType isEqualToString:@"application/x-font-opentype"] || 
                  [mimeType isEqualToString:@"font/opentype"]) {
        type = @"otf";
      }
    }
  }

  if ([type isEqual:[NSNull null]])
    type = [options valueForKey:@"type"];

  if ([type isEqual:[NSNull null]])
    type = @"ttf";
    
  NSData *decodedData = [[NSData alloc]initWithBase64EncodedString:data options:NSDataBase64DecodingIgnoreUnknownCharacters];
  CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)decodedData);

  [UIFont familyNames];
  
  CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
  NSString *newFontName = (__bridge NSString *)CGFontCopyPostScriptName(newFont);
  
  CFErrorRef error;
  if (! CTFontManagerRegisterGraphicsFont(newFont, &error)) {
    CFStringRef errorDescription = CFErrorCopyDescription(error);
    NSLog(@"Failed to register font: %@", errorDescription);

    callback(@[@"Failed to register font: %@", (__bridge NSString *)errorDescription]);
    
    CFRelease(errorDescription);
    CGFontRelease(newFont);
    CGDataProviderRelease(fontDataProvider);
      
    return;
  }

  CGFontRelease(newFont);
  CGDataProviderRelease(fontDataProvider);

  callback(@[[NSNull null], newFontName]);
}

@end
