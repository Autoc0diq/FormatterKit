//
//  FormatterKit.h
//  
//
//  Created by Eric Horacek on 6/18/14.
//
//

#define TTTBUNDLE_NAME @"FormatterKit"
#define TTTBUNDLE ([[NSBundle mainBundle] URLForResource:TTTBUNDLE_NAME withExtension:@"bundle"] ? [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:TTTBUNDLE_NAME withExtension:@"bundle"]] : [NSBundle mainBundle])
