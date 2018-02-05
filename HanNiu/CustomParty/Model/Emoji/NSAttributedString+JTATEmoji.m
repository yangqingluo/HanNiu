#import "NSAttributedString+JTATEmoji.h"

@implementation NSAttributedString (JTATEmoji)

+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font {
    @autoreleasepool {
        if (!font) {
            font = [UIFont systemFontOfSize:15];
        }
        
        NSMutableAttributedString *parsedOutput = [[NSMutableAttributedString alloc]initWithString:string attributes:@{NSFontAttributeName : font}];
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\[[A-Za-z0-9\\u4e00-\\u9fa5:{}()@#$*+<>:;'|^-]*\\]" options:0 error:nil];
        NSArray* matches = [regex matchesInString:[parsedOutput string]
                                          options:NSMatchingWithoutAnchoringBounds
                                            range:NSMakeRange(0, parsedOutput.length)];
        
        NSDictionary *emojiPlistDic = [[NSDictionary alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Emoji" ofType:@"plist"]];
        
        // Make emoji the same size as text
        CGSize emojiSize = CGSizeMake(font.pointSize, font.pointSize);
        
        for (NSTextCheckingResult* result in [matches reverseObjectEnumerator]) {
            NSRange matchRange = [result range];
            NSRange captureRange = [result rangeAtIndex:0];
            
            // Find emoji images by placeholder
            NSString *placeholder = [parsedOutput.string substringWithRange:captureRange];
            
            UIImage *emojiImage = [UIImage imageNamed:emojiPlistDic[placeholder]];
            if (emojiImage) {
//                // Resize Emoji Image
//                UIGraphicsBeginImageContextWithOptions(emojiSize, NO, 0.0);
//                [emojiImage drawInRect:CGRectMake(0, 0.5 * (font.lineHeight - font.pointSize), emojiSize.width, emojiSize.height)];
//                UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
//                UIGraphicsEndImageContext();
                
                NSTextAttachment* textAttachment = [NSTextAttachment new];
                textAttachment.image = emojiImage;
                textAttachment.bounds = CGRectMake(0, 0.5 * (font.pointSize - font.lineHeight), emojiSize.width, emojiSize.height);
                
                // Replace placeholder with image
                NSAttributedString *rep = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [parsedOutput replaceCharactersInRange:matchRange withAttributedString:rep];
            }
        }
        return [parsedOutput copy];
    }
}

@end
