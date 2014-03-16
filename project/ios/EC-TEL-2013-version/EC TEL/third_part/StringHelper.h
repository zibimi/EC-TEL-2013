//
//  StringHelper.h
//  CN3
//
//  Created by Gang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NSString (StringHelper)

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size;

- (UILabel *)sizeCellLabelWithSystemFontOfSize:(CGFloat)size isBold:(BOOL)isbold ;

@end
