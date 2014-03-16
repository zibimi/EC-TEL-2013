//
//  StringHelper.m
//  CN3
//
//  Created by Gang on 12/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StringHelper.h" 

@implementation NSString (StringHelper)

- (CGFloat)textHeightForSystemFontOfSize:(CGFloat)size {
    //Calculate the expected size based on the font and linebreak mode of the label
    CGFloat maxWidth = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat maxHeight = 9999;
    CGSize maximumLabelSize = CGSizeMake(maxWidth,maxHeight);
    
    CGSize expectedLabelSize = [self sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:maximumLabelSize /*lineBreakMode:UILineBreakModeWordWrap*/];
    
    return expectedLabelSize.height;
}

- (UILabel *)sizeCellLabelWithSystemFontOfSize:(CGFloat)size isBold:(BOOL)isbold {
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 50;
    CGFloat height = [self textHeightForSystemFontOfSize:size] + 10.0;
    CGRect frame = CGRectMake(10.0f, 10.0f, width, height);
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:frame];
    cellLabel.textColor = [UIColor blackColor];
    cellLabel.backgroundColor = [UIColor clearColor];
    //cellLabel.textAlignment = UITextAlignmentLeft;
    if (isbold) {
        cellLabel.font = [UIFont boldSystemFontOfSize:size];
    }else{
        cellLabel.font = [UIFont systemFontOfSize:size];
    }
        
    cellLabel.text = self; 
    cellLabel.numberOfLines = 0; 
    [cellLabel sizeToFit];
    return cellLabel;
}

@end
