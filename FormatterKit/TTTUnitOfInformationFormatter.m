// TTTUnitOfInformationFormatter.m
//
// Copyright (c) 2012 Mattt Thompson (http://mattt.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "TTTUnitOfInformationFormatter.h"
#import "FormatterKit.h"

static inline NSUInteger TTTNumberOfBitsInUnit(TTTUnitOfInformation unit) {
    switch (unit) {
        case TTTBit:
            return 1;
        case TTTNibble:
            return 4;
        case TTTByte:
            return 8;
        case TTTWord:
            return 16;
        case TTTDoubleWord:
            return 32;
    }
}

static inline double TTTScaleFactorForIECPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return pow(2.0, 10.0);
        case TTTMega:
            return pow(2.0, 20.0);
        case TTTGiga:
            return pow(2.0, 30.0);
        case TTTTera:
            return pow(2.0, 40.0);
        case TTTPeta:
            return pow(2.0, 50.0);
        case TTTExa:
            return pow(2.0, 60.0);
    }
}

static inline NSString * TTTBitUnitStringForIECPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return NSLocalizedStringFromTableInBundle(@"Kibit", @"FormatterKit", TTTBUNDLE, @"Kibibit Unit");
        case TTTMega:
            return NSLocalizedStringFromTableInBundle(@"Mibit", @"FormatterKit", TTTBUNDLE, @"Mebibit Unit");
        case TTTGiga:
            return NSLocalizedStringFromTableInBundle(@"Gibit", @"FormatterKit", TTTBUNDLE, @"Gibibit Unit");
        case TTTTera:
            return NSLocalizedStringFromTableInBundle(@"Tibit", @"FormatterKit", TTTBUNDLE, @"Tebibit Unit");
        case TTTPeta:
            return NSLocalizedStringFromTableInBundle(@"Pibit", @"FormatterKit", TTTBUNDLE, @"Pebibit Unit");
        case TTTExa:
            return nil;
    }
}

static inline NSString * TTTByteUnitStringForIECPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return NSLocalizedStringFromTableInBundle(@"KiB", @"FormatterKit", TTTBUNDLE, @"Kibibyte Unit");
        case TTTMega:
            return NSLocalizedStringFromTableInBundle(@"MiB", @"FormatterKit", TTTBUNDLE, @"Mebibyte Unit");
        case TTTGiga:
            return NSLocalizedStringFromTableInBundle(@"GiB", @"FormatterKit", TTTBUNDLE, @"Gibibyte Unit");
        case TTTTera:
            return NSLocalizedStringFromTableInBundle(@"TiB", @"FormatterKit", TTTBUNDLE, @"Tebibyte Unit");
        case TTTPeta:
            return NSLocalizedStringFromTableInBundle(@"PiB", @"FormatterKit", TTTBUNDLE, @"Pebibyte Unit");
        case TTTExa:
            return NSLocalizedStringFromTableInBundle(@"EiB", @"FormatterKit", TTTBUNDLE, @"Exbibyte Unit");
    }
}

static inline double TTTScaleFactorForSIPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return pow(10.0, 3.0);
        case TTTMega:
            return pow(10.0, 6.0);
        case TTTGiga:
            return pow(10.0, 9.0);
        case TTTTera:
            return pow(10.0, 12.0);
        case TTTPeta:
            return pow(10.0, 15.0);
        case TTTExa:
            return pow(10.0, 18.0);
    }
}

static inline NSString * TTTBitUnitStringForSIPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return NSLocalizedStringFromTableInBundle(@"kbit", @"FormatterKit", TTTBUNDLE, @"Kilobit Unit");
        case TTTMega:
            return NSLocalizedStringFromTableInBundle(@"Mbit", @"FormatterKit", TTTBUNDLE, @"Megabit Unit");
        case TTTGiga:
            return NSLocalizedStringFromTableInBundle(@"Gbit", @"FormatterKit", TTTBUNDLE, @"Gigabit Unit");
        case TTTTera:
            return NSLocalizedStringFromTableInBundle(@"Tbit", @"FormatterKit", TTTBUNDLE, @"Terabit Unit");
        case TTTPeta:
            return NSLocalizedStringFromTableInBundle(@"Pbit", @"FormatterKit", TTTBUNDLE, @"Petabit Unit");
        case TTTExa:
            return nil;
    }
}

static inline NSString * TTTByteUnitStringForSIPrefix(TTTUnitPrefix prefix) {
    switch (prefix) {
        case TTTKilo:
            return NSLocalizedStringFromTableInBundle(@"KB", @"FormatterKit", TTTBUNDLE, @"Kilobyte Unit");
        case TTTMega:
            return NSLocalizedStringFromTableInBundle(@"MB", @"FormatterKit", TTTBUNDLE, @"Megabyte Unit");
        case TTTGiga:
            return NSLocalizedStringFromTableInBundle(@"GB", @"FormatterKit", TTTBUNDLE, @"Gigabyte Unit");
        case TTTTera:
            return NSLocalizedStringFromTableInBundle(@"TB", @"FormatterKit", TTTBUNDLE, @"Terabyte Unit");
        case TTTPeta:
            return NSLocalizedStringFromTableInBundle(@"PB", @"FormatterKit", TTTBUNDLE, @"Petabyte Unit");
        case TTTExa:
            return NSLocalizedStringFromTableInBundle(@"EB", @"FormatterKit", TTTBUNDLE, @"Exabyte Unit");
    }
}

@interface TTTUnitOfInformationFormatter ()
@property (readwrite, nonatomic, strong) NSNumberFormatter *numberFormatter;
@end

@implementation TTTUnitOfInformationFormatter
@synthesize displaysInTermsOfBytes = _displaysInTermsOfBytes;
@synthesize usesIECBinaryPrefixesForCalculation = _usesIECBinaryPrefixesForCalculation;
@synthesize usesIECBinaryPrefixesForDisplay = _usesIECBinaryPrefixesForDisplay;
@synthesize numberFormatter = _numberFormatter;

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }

    _numberFormatter = [[NSNumberFormatter alloc] init];
    [_numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [_numberFormatter setRoundingIncrement:@(0.01f)];

    self.displaysInTermsOfBytes = YES;
    self.usesIECBinaryPrefixesForCalculation = YES;
    self.usesIECBinaryPrefixesForDisplay = NO;

    return self;
}

#pragma mark -

- (double)scaleFactorForPrefix:(TTTUnitPrefix)prefix {
    return self.usesIECBinaryPrefixesForCalculation ? TTTScaleFactorForIECPrefix(prefix) : TTTScaleFactorForSIPrefix(prefix);
}

- (TTTUnitPrefix)prefixForInteger:(NSUInteger)value {
    if ([self scaleFactorForPrefix:TTTExa] < value) {
        return TTTExa;
    } else if ([self scaleFactorForPrefix:TTTPeta] < value) {
        return TTTPeta;
    } else if ([self scaleFactorForPrefix:TTTTera] < value) {
        return TTTTera;
    } else if ([self scaleFactorForPrefix:TTTGiga] < value) {
        return TTTGiga;
    } else if ([self scaleFactorForPrefix:TTTMega] < value) {
        return TTTMega;
    } else {
        return TTTKilo;
    }
}

#pragma mark -

- (NSString *)stringFromNumberOfBits:(NSNumber *)number {
    NSString *unitString = nil;
    double doubleValue = [number doubleValue];

    if (self.displaysInTermsOfBytes) {
        doubleValue /= TTTNumberOfBitsInUnit(TTTByte);
    }

    if (doubleValue < [self scaleFactorForPrefix:TTTKilo]) {
        unitString = self.displaysInTermsOfBytes ? NSLocalizedStringFromTableInBundle(@"bytes", @"FormatterKit", TTTBUNDLE, @"Byte Unit") : NSLocalizedStringFromTableInBundle(@"bits", @"FormatterKit", TTTBUNDLE, @"Bit Unit");
    } else {
        TTTUnitPrefix prefix = [self prefixForInteger:(NSUInteger)round(doubleValue)];
        if (self.displaysInTermsOfBytes) {
            unitString = self.usesIECBinaryPrefixesForDisplay ? TTTByteUnitStringForIECPrefix(prefix) : TTTByteUnitStringForSIPrefix(prefix);
        } else {
            unitString = self.usesIECBinaryPrefixesForDisplay ? TTTBitUnitStringForIECPrefix(prefix) : TTTBitUnitStringForSIPrefix(prefix);
        }

        doubleValue /= [self scaleFactorForPrefix:prefix];
    }

    return [NSString stringWithFormat:NSLocalizedStringWithDefaultValue(@"Unit of Information Format String", @"FormatterKit", TTTBUNDLE, @"%@ %@", @"#{Value} #{Unit}"), [_numberFormatter stringFromNumber:@(doubleValue)], unitString];
}

- (NSString *)stringFromNumber:(NSNumber *)number
                        ofUnit:(TTTUnitOfInformation)unit
{
    return [self stringFromNumberOfBits:@([number unsignedLongLongValue] * TTTNumberOfBitsInUnit(unit))];
}

- (NSString *)stringFromNumber:(NSNumber *)number
                        ofUnit:(TTTUnitOfInformation)unit
                    withPrefix:(TTTUnitPrefix)prefix
{
    return [self stringFromNumber:@([self scaleFactorForPrefix:prefix] * [number unsignedIntegerValue]) ofUnit:unit];
}

#pragma mark - NSFormatter

- (NSString *)stringForObjectValue:(id)obj {
    if ([obj isKindOfClass:[NSNumber class]]) {
        return [self stringFromNumberOfBits:(NSNumber *)obj];
    } else {
        return nil;
    }
}

- (BOOL)getObjectValue:(out __unused __autoreleasing id *)obj
             forString:(__unused NSString *)string
      errorDescription:(out NSString *__autoreleasing *)error
{
    *error = NSLocalizedStringFromTableInBundle(@"Method Not Implemented", @"FormatterKit", TTTBUNDLE, nil);

    return NO;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    TTTUnitOfInformationFormatter *formatter = [[[self class] allocWithZone:zone] init];

    formatter.numberFormatter = [self.numberFormatter copyWithZone:zone];
    formatter.displaysInTermsOfBytes = self.displaysInTermsOfBytes;
    formatter.usesIECBinaryPrefixesForCalculation = self.usesIECBinaryPrefixesForCalculation;
    formatter.usesIECBinaryPrefixesForDisplay = self.usesIECBinaryPrefixesForDisplay;

    return formatter;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];

    self.numberFormatter = [aDecoder decodeObjectForKey:NSStringFromSelector(@selector(numberFormatter))];
    self.displaysInTermsOfBytes = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(displaysInTermsOfBytes))];
    self.usesIECBinaryPrefixesForCalculation = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(usesIECBinaryPrefixesForCalculation))];
    self.usesIECBinaryPrefixesForDisplay = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(usesIECBinaryPrefixesForDisplay))];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];

    [aCoder encodeObject:self.numberFormatter forKey:NSStringFromSelector(@selector(numberFormatter))];
    [aCoder encodeBool:self.displaysInTermsOfBytes forKey:NSStringFromSelector(@selector(displaysInTermsOfBytes))];
    [aCoder encodeBool:self.usesIECBinaryPrefixesForCalculation forKey:NSStringFromSelector(@selector(usesIECBinaryPrefixesForCalculation))];
    [aCoder encodeBool:self.usesIECBinaryPrefixesForDisplay forKey:NSStringFromSelector(@selector(usesIECBinaryPrefixesForDisplay))];
}

@end
