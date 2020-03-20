//
//  Movie.h
//  movieDB-objc
//
//  Created by Vinícius Chagas on 16/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property NSNumber* id;

// The use of snake_case for property names reflects the way they are
// named in TMDb's API. This allows for automatic JSON parsing.
@property NSString* title;
@property NSString* overview;
@property NSString* genres;
@property NSNumber* vote_average;
@property NSURL* poster_path;

@end

NS_ASSUME_NONNULL_END
