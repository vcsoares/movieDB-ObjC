//
//  Movie.m
//  movieDB-objc
//
//  Created by Vinícius Chagas on 16/03/20.
//  Copyright © 2020 Vinícius Chagas. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(instancetype)initWithId:(NSNumber*) uid name:(NSString*) name synopsis:(NSString*) synopsis genres:(NSString*) genres rating:(NSNumber*) rating picture:(NSURL*) picture {
    self = [super init];
    
    if (self) {
        self.id = uid;
        self.title = name;
        self.overview = synopsis;
        self.genres = genres;
        self.vote_average = rating;
        self.poster_path = picture;
    }
    
    return self;
}

@end
