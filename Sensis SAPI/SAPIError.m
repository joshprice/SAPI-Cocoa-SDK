//
//  SAPIError.m
//  Sensis SAPI
//
//  Created by Mark Aufflick on 21/03/12.
//  Copyright (c) 2012 Pumptheory Pty Ltd. All rights reserved.
//

#import "SAPIError.h"

const NSString * SAPIErrorDomain = @"com.sensis.sapi.ErrorDomain";
const NSString * SAPIErrorValidationErrorsKey = @"com.sensis.sapi.ValidationErrors";
const NSString * SAPIErrorHTTPStatusCodeKey = @"com.sensis.sapi.HTTPStatusCode";


@implementation SAPIError

+ (SAPIError *)errorWithCode:(SAPIErrorCode)code
            errorDescription:(NSString *)description
               failureReason:(NSString *)failureReason
            validationErrors:(NSArray *)validationErrors
              httpStatusCode:(NSInteger)httpStatusCode
{
    NSMutableDictionary * userInfo = [NSMutableDictionary dictionary];

    if (description)
        [userInfo setObject:description forKey:NSLocalizedDescriptionKey];
    
    if (failureReason)
        [userInfo setObject:failureReason forKey:NSLocalizedFailureReasonErrorKey];
    
    if (validationErrors)
        [userInfo setObject:validationErrors forKey:SAPIErrorValidationErrorsKey];
    
    [userInfo setObject:[NSNumber numberWithInteger:httpStatusCode] forKey:SAPIErrorHTTPStatusCodeKey];
    
    return [self errorWithDomain:(NSString *)SAPIErrorDomain code:code userInfo:userInfo];
}

- (NSString *)validationErrors
{
    return [[self userInfo] objectForKey:SAPIErrorValidationErrorsKey];
}

- (NSInteger)httpStatusCode
{
    return [[[self userInfo] objectForKey:SAPIErrorHTTPStatusCodeKey] integerValue];
}

@end
