#import "GZColors.h"

@implementation GZColors

+ (UIColor *)color
{
    float r = arc4random() % 255; 
    float g = arc4random() % 255;
    float b = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0];
    return color;
}

@end
