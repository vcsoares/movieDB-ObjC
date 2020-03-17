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

@property NSNumber* uid;

@property NSString* name;
@property NSString* synopsis;
@property NSString* genres;
@property NSNumber* rating;
@property NSURL* picture;

-(instancetype)initWithId:(NSNumber*) uid name:(NSString*) name synopsis:(NSString*) synopsis genres:(NSString*) genres rating:(NSNumber*) rating picture:(NSURL*) picture;

@end

NS_ASSUME_NONNULL_END
