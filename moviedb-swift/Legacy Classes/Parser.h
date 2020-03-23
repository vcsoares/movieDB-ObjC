//
//  Parser.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 17/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class Movie;

@interface Parser : NSObject

+(NSArray*)movieListFromJSON:(NSData*) json error:(NSError**) error;
+(void)detailsForMovie:(Movie*) movie from:(NSData*) json error:(NSError**) error;

@end

NS_ASSUME_NONNULL_END
